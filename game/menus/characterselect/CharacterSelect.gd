extends Node2D

class_name CharacterSelect

# initialize

var rng : RandomNumberGenerator

var next_scene_packed
var prev_scene_packed

var P1Cursor
var P2Cursor
var A1Portrait
var A2Portrait
var P1Portrait
var P2Portrait
var AkiMC
var P1SelectFlash
var P2SelectFlash
var KimiNoHiroin
var WinCounterP1
var WinCounterP2

var character = [
	[Enums.PointCharacters.Ollie, Enums.PointCharacters.Suisei, Enums.PointCharacters.Kanata],
	[Enums.PointCharacters.Mio, Enums.PointCharacters.Subaru, Enums.PointCharacters.Oga],
	[Enums.PointCharacters.Random, Enums.PointCharacters.Flayon, Enums.PointCharacters.Random],
	[Enums.PointCharacters.Random, Enums.PointCharacters.Random, Enums.PointCharacters.Random]
	]

var assist2 = [
	[Enums.AssistCharacters.Ollie, Enums.AssistCharacters.Suisei, Enums.AssistCharacters.Kanata, Enums.AssistCharacters.Rikka, Enums.AssistCharacters.Hakka],
	[Enums.AssistCharacters.Mio, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Oga, Enums.AssistCharacters.Fubuki, Enums.AssistCharacters.OkaKoro],
	[Enums.AssistCharacters.Random, Enums.AssistCharacters.Flayon, Enums.AssistCharacters.Random, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Sana],
	[Enums.AssistCharacters.Random, Enums.AssistCharacters.Random, Enums.AssistCharacters.Random, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Sana]
	]
var assist1 = [
	[Enums.AssistCharacters.Hakka, Enums.AssistCharacters.Rikka, Enums.AssistCharacters.Ollie, Enums.AssistCharacters.Suisei, Enums.AssistCharacters.Kanata],
	[Enums.AssistCharacters.OkaKoro, Enums.AssistCharacters.Fubuki, Enums.AssistCharacters.Mio, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Oga],
	[Enums.AssistCharacters.Sana, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Random, Enums.AssistCharacters.Flayon, Enums.AssistCharacters.Random],
	[Enums.AssistCharacters.Sana, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Random, Enums.AssistCharacters.Random, Enums.AssistCharacters.Random]
	]

@onready var AssistSelect = preload("res://game/menus/characterselect/AssistCharacterSelect.tscn")
var p1_assist_select
var p2_assist_select

@onready var ButtonMap = preload("res://game/menus/buttonmap/ButtonMapMenu.tscn")
@onready var KeyButtonMap = preload("res://game/menus/buttonmap/KeyboardButtonMapMenu.tscn")
var p1_button_map: ButtonMapMenuBase
var p2_button_map: ButtonMapMenuBase

var p1_ready:bool = false
var p2_ready:bool = false

var p1_active_cursor
var p2_active_cursor

var p1_color_number: int = 1
var p2_color_number: int = 1
var a1_color_number: int = 1
var a2_color_number: int = 1
var p1_color_capture: Dictionary = {}
var p2_color_capture: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_ui_elements()

	Global.load_queue.start()
	rng = RandomNumberGenerator.new()
	rng.randomize()
	P1Cursor.connect("change_character", Callable(self, "update_p1_portrait"))
	P2Cursor.connect("change_character", Callable(self, "update_p2_portrait"))
	P1Cursor.connect("select_chara", Callable(self, "update_p1"))
	P2Cursor.connect("select_chara", Callable(self, "update_p2"))
	P1Cursor.connect("select_chara", Callable(AkiMC, "p1_call"))
	P2Cursor.connect("select_chara", Callable(AkiMC, "p2_call"))
	P1Cursor.connect("select_chara", Callable(P1SelectFlash, "player_call"))
	P2Cursor.connect("select_chara", Callable(P2SelectFlash, "player_call"))
	KimiNoHiroin.connect("start_intro_sequence", Callable(MainMenuMusicControl, "play_character_select_music"))
	update_p1_portrait(P1Cursor.row, P1Cursor.col)
	update_p2_portrait(P2Cursor.row, P2Cursor.col)
	if (self.has_node("CanvasLayer/WinCounterP1")):
		WinCounterP1.update_win_count(true)
		WinCounterP2.update_win_count(false)
	p1_active_cursor = P1Cursor
	p2_active_cursor = P2Cursor
	MainMenuMusicControl.reset_seek()

func connect_ui_elements():
	P2Cursor = $P2Cursor
	P1Cursor = $P1Cursor
	A1Portrait = $A1Portrait
	A2Portrait = $A2Portrait
	P1Portrait = $P1Portrait
	P2Portrait = $P2Portrait
	AkiMC = $AkiMC
	P1SelectFlash = $P1SelectFlash
	P2SelectFlash = $P2SelectFlash
	KimiNoHiroin = $KimiNoHiroin
	WinCounterP1 = $CanvasLayer/WinCounterP1
	WinCounterP2 = $CanvasLayer/WinCounterP2

func try_react_to_new_controller(event):
	if (event is InputEventJoypadMotion or event is InputEventJoypadButton):
		if (Global.p1_device_id < 0 or Global.p2_device_id < 0):
			Util.try_replace_controller(event.device)

func update_p1_portrait(row:int,col:int):
	P1Portrait.change_portrait_anim()
	resolve_portrait(row, col, true)

func update_p2_portrait(row:int,col:int):
	P2Portrait.change_portrait_anim()
	resolve_portrait(row, col, false)

func update_a1_portrait(row:int,col:int):
	A1Portrait.change_portrait_anim()
	resolve_assist_portrait(row, col, true)

func update_a2_portrait(row:int,col:int):
	A2Portrait.change_portrait_anim()
	resolve_assist_portrait(row, col, false)

func update_p1():
	begin_color_capture(true, P1Cursor.input_prefix, false, Callable(self, "complete_p1_selection"))

func complete_p1_selection():
	p1_assist_select = AssistSelect.instantiate() 
	add_child(p1_assist_select)
	p1_active_cursor = p1_assist_select
	p1_assist_select.position.x = 966
	p1_assist_select.position.y = 300
	p1_assist_select.setup(true, true)
	p1_assist_select.get_node("CharacterCursor").connect("change_character", Callable(self, "update_a1_portrait"))
	p1_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(self, "update_a1"))
	p1_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(P1SelectFlash, "player_call"))
	p1_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(AkiMC, "p1_call"))
	update_a1_portrait(p1_assist_select.cursor_row(), p1_assist_select.cursor_col())
	var charaData = resolve_characters(P1Cursor.row, P1Cursor.col)
	p1_color_number = fit_color_number_to_character(charaData[1], false, p1_color_number)
	P1Portrait.change_color_number(p1_color_number)
	
	unload_character(charaData[0],true,false)
	Global.PLAYER_1_NODE_PATH[0] = charaData[0]
	Global.PLAYER_1_CHARACTER[0] = charaData[1]
	Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[0])
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])
	
func update_p2():
#	Global.PLAYER_2_COLOR[0] = "res://game/assets/sprites/subaru/ColorPalettes/2.png"
#	P2Portrait.material.set_shader_param("palette", load(Global.PLAYER_2_COLOR[0]))
	begin_color_capture(false, P2Cursor.input_prefix, false, Callable(self, "complete_p2_selection"))

func complete_p2_selection():
	p2_assist_select = AssistSelect.instantiate() 
	add_child(p2_assist_select)
	p2_active_cursor = p2_assist_select
	p2_assist_select.position.x = 966
	p2_assist_select.position.y = 300
	p2_assist_select.setup(false, false)
	p2_assist_select.get_node("CharacterCursor").connect("change_character", Callable(self, "update_a2_portrait"))
	p2_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(self, "update_a2"))
	p2_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(P2SelectFlash, "player_call"))
	p2_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(AkiMC, "p2_call"))
	update_a2_portrait(p2_assist_select.cursor_row(), p2_assist_select.cursor_col())
	var charaData = resolve_characters(P2Cursor.row, P2Cursor.col)
	p2_color_number = fit_color_number_to_character(charaData[1], false, p2_color_number)
	P2Portrait.change_color_number(p2_color_number)
	unload_character(charaData[0],false,false)
	Global.PLAYER_2_NODE_PATH[0] = charaData[0]
	Global.PLAYER_2_CHARACTER[0] = charaData[1]
	Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[0])
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[2])

#@rpc("any_peer", "call_local", "reliable")
func update_a1():
	var cursor = p1_assist_select.get_node("CharacterCursor")
	begin_color_capture(true, cursor.input_prefix, true, Callable(self, "complete_a1_selection"))

func complete_a1_selection():
	var charaData = resolve_assists(p1_assist_select.cursor_row(), p1_assist_select.cursor_col(), true)
	a1_color_number = fit_color_number_to_character(charaData[1], true, a1_color_number)
	A1Portrait.change_color_number(a1_color_number)
	unload_character(charaData[0], true,true)
	p1_active_cursor = null
	Global.PLAYER_1_NODE_PATH[1] = charaData[0]
	Global.PLAYER_1_CHARACTER[1] = charaData[1]
	Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[1])
	p1_ready = true
	ready_up_peer()

func update_a2():
	var cursor = p2_assist_select.get_node("CharacterCursor")
	begin_color_capture(false, cursor.input_prefix, true, Callable(self, "complete_a2_selection"))

func complete_a2_selection():
	var charaData = resolve_assists(p2_assist_select.cursor_row(), p2_assist_select.cursor_col(), false)
	a2_color_number = fit_color_number_to_character(charaData[1], true, a2_color_number)
	A2Portrait.change_color_number(a2_color_number)
	unload_character(charaData[0],false,true)
	p2_active_cursor = null
	Global.PLAYER_2_NODE_PATH[1] = charaData[0]
	Global.PLAYER_2_CHARACTER[1] = charaData[1]
	Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[1])
	p2_ready = true
	ready_up_peer()

func unload_character(next_character, is_p1, is_assist)-> void:
	var index = 0
	if (is_assist):
		index = 1
	
	#if (Global.PLAYER_2_NODE_PATH[index] != Global.PLAYER_1_NODE_PATH[index]):
		#if (is_p1):
			#if (Global.PLAYER_1_NODE_PATH[index] != next_character):
				#Global.PLAYER_1_NODE[0] = (Global.PLAYER_1_NODE_PATH[index])
		#else:
			#if (Global.PLAYER_2_NODE_PATH[index] != next_character):
				#Global.load_queue.cancel_resource(Global.PLAYER_2_NODE_PATH[index])

func ready_up_peer():
	if (p1_ready and p2_ready):
		start_loading_process()

func start_loading_process():
	resolve_colors()
	resolve_assist_colors()
	go_to_next_scene()

func _physics_process(_delta):
	physics_tick()

func physics_tick():
	process_color_captures()

func resolve_characters(row: int, col: int):
	var enumChara: int = character[row][col]
	
	if (enumChara == Enums.PointCharacters.Random):
		enumChara = rng.randi_range(0, 5)
		print("RANDOM POINT " + str(enumChara))
	
	match enumChara:
		Enums.PointCharacters.Subaru:
			return ["res://game/fighter/SubaruPlayer.tscn", Enums.PointCharacters.Subaru]
		Enums.PointCharacters.Mio:
			return ["res://game/fighter/MioPlayer.tscn", Enums.PointCharacters.Mio]
		Enums.PointCharacters.Oga:
			return ["res://game/fighter/OgaPlayer.tscn", Enums.PointCharacters.Oga]
		Enums.PointCharacters.Ollie:
			return ["res://game/fighter/OlliePlayer.tscn", Enums.PointCharacters.Ollie]
		Enums.PointCharacters.Kanata:
			return ["res://game/fighter/KanataPlayer.tscn", Enums.PointCharacters.Kanata]
		Enums.PointCharacters.Suisei:
			return ["res://game/fighter/SuiseiPlayer.tscn", Enums.PointCharacters.Suisei]
		Enums.PointCharacters.Flayon:
			return ["res://game/fighter/FlayonPlayer.tscn", Enums.PointCharacters.Flayon]
		_:
			return ["res://game/fighter/SubaruPlayer.tscn", Enums.PointCharacters.Subaru]

func resolve_assists(row:int, col:int, is_p1):
	var enumChara: int = assist2[row][col]
	if (is_p1):
		enumChara = assist1[row][col]
	
	if (enumChara == Enums.AssistCharacters.Random):
		enumChara = rng.randi_range(0, 8)
		print("RANDOM ASSIST " + str(enumChara))
	
	match enumChara:
		Enums.AssistCharacters.Fubuki:
			return ["res://game/fighter/assist/fubuki/FubukiPlayer.tscn", Enums.AssistCharacters.Fubuki]
		Enums.AssistCharacters.Sora:
			return ["res://game/fighter/assist/sora/SoraPlayer.tscn", Enums.AssistCharacters.Sora]
		Enums.AssistCharacters.Sana:
			return ["res://game/fighter/assist/assistsana/SanaPlayer.tscn", Enums.AssistCharacters.Sana]
		Enums.AssistCharacters.OkaKoro:
			return ["res://game/fighter/assist/okakoro/OkaKoroPlayer.tscn", Enums.AssistCharacters.OkaKoro]
		Enums.AssistCharacters.Hakka:
			return ["res://game/fighter/assist/hakka/HakkaPlayer.tscn", Enums.AssistCharacters.Hakka]
		Enums.AssistCharacters.Rikka:
			return ["res://game/fighter/assist/rikka/RikkaPlayer.tscn", Enums.AssistCharacters.Rikka]
		Enums.AssistCharacters.Subaru:
			return ["res://game/fighter/assist/assistsubaru/AssistSubaruPlayer.tscn", Enums.AssistCharacters.Subaru]
		Enums.AssistCharacters.Mio:
			return ["res://game/fighter/assist/assistmio/AssistMioPlayer.tscn", Enums.AssistCharacters.Mio]
		Enums.AssistCharacters.Oga:
			return ["res://game/fighter/assist/assistoga/AssistOgaPlayer.tscn", Enums.AssistCharacters.Oga]
		Enums.AssistCharacters.Ollie:
			return ["res://game/fighter/assist/assistollie/AssistOlliePlayer.tscn", Enums.AssistCharacters.Ollie]
		Enums.AssistCharacters.Kanata:
			return ["res://game/fighter/assist/assistkanata/AssistKanataPlayer.tscn", Enums.AssistCharacters.Kanata]
		Enums.AssistCharacters.Suisei:
			return ["res://game/fighter/assist/assistsuisei/AssistSuiseiPlayer.tscn", Enums.AssistCharacters.Suisei]
		Enums.AssistCharacters.Flayon:
			return ["res://game/fighter/assist/flayon/AssistFlayonPlayer.tscn", Enums.AssistCharacters.Flayon]
		_:
			return ["res://game/fighter/assist/fubuki/FubukiPlayer.tscn", Enums.AssistCharacters.Fubuki]

func resolve_colors():
	var enumChara1: int = Global.PLAYER_1_CHARACTER[0]
	var enumChara2: int = Global.PLAYER_2_CHARACTER[0]
	var color1: String = ""
	var color2: String = ""
	color1 = match_color(enumChara1)
	color2 = match_color(enumChara2)
	if (enumChara1 == enumChara2 and p1_color_number == p2_color_number):
		if (p1_color_number == 1):
			color1 += "1.png"
			color2 += "2.png"
		else:
			color1 += str(p1_color_number)+".png"
			color2 += "1.png"
	else:
		color1 += str(p1_color_number)+".png"
		color2 += str(p2_color_number)+".png"
	Global.PLAYER_1_COLOR[0] = color1
	Global.PLAYER_2_COLOR[0] = color2
	Global.load_new_color(true, false)
	Global.load_new_color(false, false)

func resolve_assist_colors():
	var enumChara1: int = Global.PLAYER_1_CHARACTER[1]
	var enumChara2: int = Global.PLAYER_2_CHARACTER[1]
	var color1: String = ""
	var color2: String = ""
	color1 = match_color(enumChara1, true)
	color2 = match_color(enumChara2, true)
	if (enumChara1 == enumChara2 and a1_color_number == a2_color_number):
		if (a1_color_number == 1):
			color1 += "1.png"
			color2 += "2.png"
		else:
			color1 += str(a1_color_number)+".png"
			color2 += "1.png"
	else:
		color1 += str(a1_color_number)+".png"
		color2 += str(a2_color_number)+".png"
	Global.PLAYER_1_COLOR[1] = color1
	Global.PLAYER_2_COLOR[1] = color2
	Global.load_new_color(true, true)
	Global.load_new_color(false, true)

func match_color(enumChara:int, is_assist=false) -> String:
	var color = ""
	if (is_assist):
		match enumChara:
			Enums.AssistCharacters.Fubuki:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
			Enums.AssistCharacters.Sora:
				color = "res://game/assets/sprites/assists/sora/ColorPalettes/"
			Enums.AssistCharacters.OkaKoro:
				color = "res://game/assets/sprites/assists/okakoro/ColorPalettes/"
			Enums.AssistCharacters.Hakka:
				color = "res://game/assets/sprites/assists/hakka/ColorPalettes/"
			Enums.AssistCharacters.Sana:
				color = "res://game/assets/sprites/assists/sana/ColorPalettes/"
			Enums.AssistCharacters.Rikka:
				color = "res://game/assets/sprites/assists/rikka/ColorPalettes/"
			Enums.AssistCharacters.Subaru:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
			Enums.AssistCharacters.Mio:
				color = "res://game/assets/sprites/mio/ColorPalettes/"
			Enums.AssistCharacters.Oga:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
			Enums.AssistCharacters.Ollie:
				color = "res://game/assets/sprites/ollie/ColorPalettes/"
			Enums.AssistCharacters.Kanata:
				color = "res://game/assets/sprites/kanata/ColorPalettes/"
			Enums.AssistCharacters.Suisei:
				color = "res://game/assets/sprites/suisei/ColorPalettes/"
			Enums.AssistCharacters.Flayon:
				color = "res://game/assets/sprites/flayon/ColorPalettes/"
			_:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
	else:
		match enumChara:
			Enums.PointCharacters.Subaru:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
			Enums.PointCharacters.Mio:
				color = "res://game/assets/sprites/mio/ColorPalettes/"
			Enums.PointCharacters.Oga:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
			Enums.PointCharacters.Ollie:
				color = "res://game/assets/sprites/ollie/ColorPalettes/"
			Enums.PointCharacters.Kanata:
				color = "res://game/assets/sprites/kanata/ColorPalettes/"
			Enums.PointCharacters.Suisei:
				color = "res://game/assets/sprites/suisei/ColorPalettes/"
			Enums.PointCharacters.Flayon:
				color = "res://game/assets/sprites/flayon/ColorPalettes/"
			_:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
	return color

func resolve_portrait(row:int, col:int, is_p1:bool):
	var enumChara: int = character[row][col]
	var portrait: String = ""
	if (is_p1):
		P1Portrait.change_portrait(enumChara)
	else:
		P2Portrait.change_portrait(enumChara)

func resolve_assist_portrait(row:int, col:int, is_p1:bool):
	var enumChara: int = assist2[row][col]
	if (is_p1):
		enumChara = assist1[row][col]
	var color: String = ""
	var portrait: String = ""
	if (is_p1):
		A1Portrait.change_portrait(enumChara, true)
	else:
		A2Portrait.change_portrait(enumChara, true)

func button_set_complete(is_p1:bool):
	if (is_p1):
		p1_button_map.free_button_menu()
		remove_child(p1_button_map)
		p1_button_map = null
		if (p1_active_cursor != null):
			p1_active_cursor.enable(true)
	else:
		remove_child(p2_button_map)
		p2_button_map.free_button_menu()
		p2_button_map = null
		if (p2_active_cursor != null):
			p2_active_cursor.enable(true)

func _input(event):
	input_helper(event)

func input_helper(event):
	button_set_initiate(event)
	try_react_to_new_controller(event)
	back_button(event)

func back_button(event):
	if (p1_color_capture.is_empty() and p1_button_map == null and (Input.is_action_just_pressed("player1_cancel") or Util.is_action_pressed_player_specific(event, "menu_back_b", true))):
		if (not P1Cursor.selected):
			go_to_prev_scene()
			return
		else:
			if (p1_assist_select != null and p1_assist_select.is_selected()):
				p1_assist_select.deselect()
				p1_active_cursor = p1_assist_select
				p1_ready = false
			else:
				p1_assist_select.queue_free()
				remove_child(p1_assist_select)
				A1Portrait.clear_portrait()
				p1_assist_select = null
				p1_active_cursor = P1Cursor
				P1Cursor.deselect()
	if (p2_color_capture.is_empty() and p2_button_map == null and (Input.is_action_just_pressed("player2_cancel") or Util.is_action_pressed_player_specific(event, "menu_back_b", false))):
		if (not P2Cursor.selected):
			go_to_prev_scene()
			return
		else:
			if (p2_assist_select != null and p2_assist_select.is_selected()):
				p2_assist_select.deselect()
				p2_active_cursor = p2_assist_select
				p2_ready = false
			else:
				p2_assist_select.queue_free()
				remove_child(p2_assist_select)
				A2Portrait.clear_portrait()
				p2_assist_select = null
				p2_active_cursor = P2Cursor
				P2Cursor.deselect()

func button_set_initiate(event):
	if event.is_action_pressed("player1_start"):
		if (p1_button_map == null):
			if (event is InputEventJoypadButton and Global.p1_is_gamepad):
				p1_button_map = ButtonMap.instantiate()
			elif (event is InputEventKey and not Global.p1_is_gamepad):
				p1_button_map = KeyButtonMap.instantiate()
			else:
				return
			add_child(p1_button_map)
			p1_button_map.position.x = 50
			p1_button_map.position.y = 50
			p1_button_map.set_is_p1(true)
			p1_button_map.connect("button_set_complete", Callable(self, "button_set_complete"))
			if (p1_active_cursor != null):
				p1_active_cursor.enable(false)
			if (p1_assist_select != null):
				p1_assist_select.deselect()
				p1_ready = false
				p1_active_cursor = p1_assist_select
				p1_assist_select.enable(false)
	if event.is_action_pressed("player2_start"):
		if (p2_button_map == null):
			if (event is InputEventJoypadButton and Global.p2_is_gamepad):
				p2_button_map = ButtonMap.instantiate()
			elif (event is InputEventKey and not Global.p2_is_gamepad):
				p2_button_map = KeyButtonMap.instantiate()
			else:
				return
			add_child(p2_button_map)
			p2_button_map.position.x = 1150
			p2_button_map.position.y = 50
			p2_button_map.set_is_p1(false)
			p2_button_map.connect("button_set_complete", Callable(self, "button_set_complete"))
			if (p2_active_cursor != null):
				p2_active_cursor.enable(false)
			if (p2_assist_select != null):
				p2_assist_select.deselect()
				p2_ready = false
				p2_active_cursor = p2_assist_select
				p2_assist_select.enable(false)


func begin_color_capture(is_p1: bool, input_prefix: String, is_assist: bool, callback: Callable):
	var selection_action = ""
	for action in ["a", "b", "c", "d"]:
		if (Input.is_action_pressed(input_prefix + action)):
			selection_action = input_prefix + action
			break
	var capture = {
		"input_prefix": input_prefix,
		"selection_action": selection_action,
		"is_assist": is_assist,
		"callback": callback
	}
	if (is_p1):
		p1_color_capture = capture
	else:
		p2_color_capture = capture
	apply_color_capture(is_p1, capture)
	if (selection_action.is_empty()):
		finish_color_capture(is_p1, callback)

func process_color_captures():
	process_color_capture(true)
	process_color_capture(false)

func process_color_capture(is_p1: bool):
	var capture = p1_color_capture if is_p1 else p2_color_capture
	if (capture.is_empty()):
		return
	if (Input.is_action_pressed(capture["selection_action"])):
		apply_color_capture(is_p1, capture)
	else:
		finish_color_capture(is_p1, capture["callback"])

func apply_color_capture(is_p1: bool, capture: Dictionary):
	var selected_character = get_selected_character_enum(is_p1, capture["is_assist"])
	var color_number = get_color_number_from_input(capture["input_prefix"])
	color_number = fit_color_number_to_character(selected_character, capture["is_assist"], color_number)
	if (is_p1):
		if (capture["is_assist"]):
			a1_color_number = color_number
			A1Portrait.change_color_number(color_number)
		else:
			p1_color_number = color_number
			P1Portrait.change_color_number(color_number)
	else:
		if (capture["is_assist"]):
			a2_color_number = color_number
			A2Portrait.change_color_number(color_number)
		else:
			p2_color_number = color_number
			P2Portrait.change_color_number(color_number)

func finish_color_capture(is_p1: bool, callback: Callable):
	if (is_p1):
		p1_color_capture = {}
	else:
		p2_color_capture = {}
	callback.call()

func get_selected_character_enum(is_p1: bool, is_assist: bool) -> int:
	if (is_assist):
		var assist_select = p1_assist_select if is_p1 else p2_assist_select
		var row = assist_select.cursor_row()
		var col = assist_select.cursor_col()
		return assist1[row][col] if is_p1 else assist2[row][col]
	var cursor = P1Cursor if is_p1 else P2Cursor
	return character[cursor.row][cursor.col]

func fit_color_number_to_character(enum_chara: int, is_assist: bool, color_number: int) -> int:
	var palette_directory = match_color(enum_chara, is_assist)
	var available_palette_numbers: Array[int] = []
	for palette_number in range(1, Util.MAX_COLOR_PALETTE_NUMBER + 1):
		if (ResourceLoader.exists(palette_directory + str(palette_number) + ".png")):
			available_palette_numbers.append(palette_number)
	if (available_palette_numbers.is_empty()):
		return 1
	return available_palette_numbers[(color_number - 1) % available_palette_numbers.size()]

func get_color_number_from_input(input_prefix: String) -> int:
	var input_vector: Vector2 = Vector2(
			-Input.get_action_strength(input_prefix+"left") + Input.get_action_strength(input_prefix+"right"), 
			-Input.get_action_strength(input_prefix+"down") + Input.get_action_strength(input_prefix+"up"))
	var input_vector_stick: Vector2 = Vector2(
			-Input.get_action_strength(input_prefix+"left_stick") + Input.get_action_strength(input_prefix+"right_stick"), 
			-Input.get_action_strength(input_prefix+"down_stick") + Input.get_action_strength(input_prefix+"up_stick"))
	var bit_input = 0
	var virtual_deadzone = 0

	if (input_vector.x == 0 and input_vector.y == 0):
		input_vector.x = input_vector_stick.x
		input_vector.y = input_vector_stick.y
	
	if (input_vector.x < -virtual_deadzone):
		bit_input |= Enums.InputFlags.LEFT
	elif (input_vector.x > virtual_deadzone):
		bit_input |= Enums.InputFlags.RIGHT

	if (input_vector.y < -virtual_deadzone):
		bit_input |= Enums.InputFlags.DOWN
	elif (input_vector.y > virtual_deadzone):
		bit_input |= Enums.InputFlags.UP

	if (Input.get_action_strength(input_prefix+"a") > 0):
		bit_input |= Enums.InputFlags.AHold
	
	if (Input.get_action_strength(input_prefix+"b") > 0):
		bit_input |= Enums.InputFlags.BHold
	
	if (Input.get_action_strength(input_prefix+"c") > 0):
		bit_input |= Enums.InputFlags.CHold
		
	if (Input.get_action_strength(input_prefix+"d") > 0):
		bit_input |= Enums.InputFlags.DHold
	
	var color_number = 0
	if (bit_input & Enums.InputFlags.AHold):
		color_number += 1
	elif (bit_input & Enums.InputFlags.BHold):
		color_number += 2
	elif (bit_input & Enums.InputFlags.CHold):
		color_number += 3
	elif (bit_input & Enums.InputFlags.DHold):
		color_number += 0
	
	if (bit_input & Enums.InputFlags.DOWN):
		color_number += (4*1)
	elif (bit_input & Enums.InputFlags.UP):
		color_number += (4*3)
	elif (bit_input & Enums.InputFlags.LEFT):
		color_number += (4*2)
	elif (bit_input & Enums.InputFlags.RIGHT):
		color_number += (4*4)
	
	color_number %= Util.MAX_COLOR_PALETTE_NUMBER
	color_number += 1
	return color_number

func select_color(input_prefix: String) -> int:
	return get_color_number_from_input(input_prefix)

func go_to_prev_scene():
	get_tree().change_scene_to_file("res://game/menus/buttonmap/ControllerPickMenuScreen.tscn")

func go_to_next_scene():
	get_tree().change_scene_to_file("res://game/menus/stagemusicselect/StageMusicSelect.tscn")
