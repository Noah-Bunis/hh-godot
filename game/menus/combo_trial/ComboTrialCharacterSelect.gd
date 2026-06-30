extends CharacterSelect

class_name ComboTrialCharacterSelect

var all_characters = [
	[Enums.AllCharacters.Hakka, Enums.AllCharacters.Fubuki, Enums.AllCharacters.Ollie, Enums.AllCharacters.Suisei, Enums.AllCharacters.Kanata, Enums.AllCharacters.AssistOllie, Enums.AllCharacters.AssistSuisei, Enums.AllCharacters.AssistKanata,],
	[Enums.AllCharacters.OkaKoro, Enums.AllCharacters.Fubuki, Enums.AllCharacters.Mio, Enums.AllCharacters.Subaru, Enums.AllCharacters.Oga, Enums.AllCharacters.AssistMio, Enums.AllCharacters.AssistSubaru, Enums.AllCharacters.AssistOga],
	[Enums.AllCharacters.Sana, Enums.AllCharacters.Sora, Enums.AllCharacters.Random, Enums.AllCharacters.Random, Enums.AllCharacters.Random, Enums.AllCharacters.Random, Enums.AllCharacters.Random, Enums.AllCharacters.Random],
	[Enums.AllCharacters.Fubuki, Enums.AllCharacters.Fubuki, Enums.AllCharacters.Flayon, Enums.AllCharacters.Random, Enums.PointCharacters.Random, Enums.AllCharacters.Flayon, Enums.AllCharacters.Random, Enums.AllCharacters.Random]
	]

func _ready():
	super._ready()
	Global.ASSIST_COMBO_TRIAL = false
	MainMenuMusicControl.reset_seek()
	if (Global.TRAINING_P1):
		P1Cursor.input_prefix = "player1_"
		P2Cursor.input_prefix = "player1_"
		P2Cursor.enable(false)
		P2Cursor.visible = false
	else:
		P1Cursor.input_prefix = "player2_"
		P2Cursor.input_prefix = "player2_"
		P1Cursor.enable(false)
		P1Cursor.visible = false

func connect_ui_elements():
	P1Cursor = $PresentationLayer/P1Cursor
	P2Cursor = $PresentationLayer/P2Cursor
	A1Portrait = $PresentationLayer/A1Portrait
	A2Portrait = $PresentationLayer/A2Portrait
	P1Portrait = $PresentationLayer/P1Portrait
	P2Portrait = $PresentationLayer/P2Portrait
	AkiMC = $PresentationLayer/AkiMC
	P1SelectFlash = $PresentationLayer/P1SelectFlash
	P2SelectFlash = $PresentationLayer/P2SelectFlash
	KimiNoHiroin = $PresentationLayer/KimiNoHiroin

func resolve_characters(row: int, col: int):
	var enumChara: int = all_characters[row][col]
	
	if (enumChara == Enums.AllCharacters.Random):
		enumChara = rng.randi_range(0, 5)
		print("RANDOM POINT " + str(enumChara))
	
	match enumChara:
		Enums.AllCharacters.Subaru:
			return ["res://game/fighter/SubaruPlayer.tscn", Enums.PointCharacters.Subaru, false]
		Enums.AllCharacters.Mio:
			return ["res://game/fighter/MioPlayer.tscn", Enums.PointCharacters.Mio, false]
		Enums.AllCharacters.Oga:
			return ["res://game/fighter/OgaPlayer.tscn", Enums.PointCharacters.Oga, false]
		Enums.AllCharacters.Ollie:
			return ["res://game/fighter/OlliePlayer.tscn", Enums.PointCharacters.Ollie, false]
		Enums.AllCharacters.Kanata:
			return ["res://game/fighter/KanataPlayer.tscn", Enums.PointCharacters.Kanata, false]
		Enums.AllCharacters.Suisei:
			return ["res://game/fighter/SuiseiPlayer.tscn", Enums.PointCharacters.Suisei, false]
		Enums.AllCharacters.Flayon:
			return ["res://game/fighter/FlayonPlayer.tscn", Enums.PointCharacters.Flayon, false]
		_:
			return ["res://game/fighter/SubaruPlayer.tscn", Enums.PointCharacters.Subaru, true]

func resolve_assists(row:int, col:int, is_p1):
	var enumChara: int = all_characters[row][col]
	if (is_p1):
		enumChara = all_characters[row][col]
	
	if (enumChara == Enums.AllCharacters.Random):
		enumChara = rng.randi_range(0, 8)
		print("RANDOM ASSIST " + str(enumChara))
	
	match enumChara:
		Enums.AllCharacters.Fubuki:
			return ["res://game/fighter/assist/fubuki/FubukiPlayer.tscn", Enums.AssistCharacters.Fubuki]
		Enums.AllCharacters.Sora:
			return ["res://game/fighter/assist/sora/SoraPlayer.tscn", Enums.AssistCharacters.Sora]
		Enums.AllCharacters.Sana:
			return ["res://game/fighter/assist/assistsana/SanaPlayer.tscn", Enums.AssistCharacters.Sana]
		Enums.AllCharacters.OkaKoro:
			return ["res://game/fighter/assist/okakoro/OkaKoroPlayer.tscn", Enums.AssistCharacters.OkaKoro]
		Enums.AllCharacters.Hakka:
			return ["res://game/fighter/assist/hakka/HakkaPlayer.tscn", Enums.AssistCharacters.Hakka]
		Enums.AllCharacters.AssistSubaru:
			return ["res://game/fighter/assist/assistsubaru/AssistSubaruPlayer.tscn", Enums.AssistCharacters.Subaru]
		Enums.AllCharacters.AssistMio:
			return ["res://game/fighter/assist/assistmio/AssistMioPlayer.tscn", Enums.AssistCharacters.Mio]
		Enums.AllCharacters.AssistOga:
			return ["res://game/fighter/assist/assistoga/AssistOgaPlayer.tscn", Enums.AssistCharacters.Oga]
		Enums.AllCharacters.AssistOllie:
			return ["res://game/fighter/assist/assistollie/AssistOlliePlayer.tscn", Enums.AssistCharacters.Ollie]
		Enums.AllCharacters.AssistKanata:
			return ["res://game/fighter/assist/assistkanata/AssistKanataPlayer.tscn", Enums.AssistCharacters.Kanata]
		Enums.AllCharacters.AssistSuisei:
			return ["res://game/fighter/assist/assistsuisei/AssistSuiseiPlayer.tscn", Enums.AssistCharacters.Suisei]
		# Enums.AllCharacters.AssistFlayon:
		# 	return ["res://game/fighter/assist/fubuki/FubukiPlayer.tscn", Enums.AssistCharacters.Fubuki]
		_:
			return ["res://game/fighter/assist/fubuki/FubukiPlayer.tscn", Enums.AssistCharacters.Fubuki]

func update_p1():
	p1_color_number = select_color(P1Cursor.input_prefix)
	var charaData = resolve_characters(P1Cursor.row, P1Cursor.col)
	
	if (charaData[2] == true):
		Global.ASSIST_COMBO_TRIAL = true
		charaData = ["res://game/fighter/SubaruPlayer.tscn", Enums.PointCharacters.Subaru, false]

	unload_character(charaData[0],true,false)
	Global.PLAYER_1_NODE_PATH[0] = charaData[0]
	Global.PLAYER_1_CHARACTER[0] = charaData[1]

	if (Global.ASSIST_COMBO_TRIAL):
		a1_color_number = p1_color_number
		p1_color_number = 1
		load_assist(P1Cursor.row, P1Cursor.col, true)
	else:
		load_assist(1, 1, true)
	Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[0])
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])
	
	
func update_p2():
	p2_color_number = select_color(P2Cursor.input_prefix)
	var charaData = resolve_characters(P2Cursor.row, P2Cursor.col)
	
	if (charaData[2] == true):
		Global.ASSIST_COMBO_TRIAL = true
		charaData = ["res://game/fighter/SubaruPlayer.tscn", Enums.PointCharacters.Subaru, false]

	unload_character(charaData[0],false,false)
	Global.PLAYER_2_NODE_PATH[0] = charaData[0]
	Global.PLAYER_2_CHARACTER[0] = charaData[1]
	
	if (Global.ASSIST_COMBO_TRIAL):
		a2_color_number = p2_color_number
		p2_color_number = 1
		load_assist(P2Cursor.row, P2Cursor.col, false)
	else:
		load_assist(1, 1, false)
	Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[0])
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[2])
	
	

func load_assist(row, col, is_p1=true):
	if (is_p1):
		var charaData = resolve_assists(row, col, is_p1)
		unload_character(charaData[0], true,true)
		Global.PLAYER_1_NODE_PATH[1] = charaData[0]
		Global.PLAYER_1_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[1])
		p1_ready = true
	else:
		var charaData = resolve_assists(row, col, is_p1)
		unload_character(charaData[0], false,true)
		Global.PLAYER_2_NODE_PATH[1] = charaData[0]
		Global.PLAYER_2_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[1])
		p2_ready = true
	ready_up_peer()
	pick_default_opponent()

func pick_default_opponent(row=1, col=1, a_row=1, a_col=1):
	var randRow = row
	var randCol = col
	if (Global.TRAINING_P1):
		var charaData = resolve_characters(randRow, randCol)
		unload_character(charaData[0],false,false)
		Global.PLAYER_2_NODE_PATH[0] = charaData[0]
		Global.PLAYER_2_CHARACTER[0] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[0])
		if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
			Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[2])
		
		charaData = resolve_assists(randRow, randCol, true)
		unload_character(charaData[0],false,true)
		p2_active_cursor = null
		Global.PLAYER_2_NODE_PATH[1] = charaData[0]
		Global.PLAYER_2_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[1])
		p2_ready = true
		p1_ready = true
		ready_up_peer()
	else:
		var charaData = resolve_characters(randRow, randCol)
		unload_character(charaData[0],true,false)
		Global.PLAYER_1_NODE_PATH[0] = charaData[0]
		Global.PLAYER_1_CHARACTER[0] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[0])
		if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
			Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])
		
		randRow = row
		randCol = col #p2_assist_select.cursor.gridX - 2
		charaData = resolve_assists(randRow, randCol, true)
		unload_character(charaData[0], true,true)
		p1_active_cursor = null
		Global.PLAYER_1_NODE_PATH[1] = charaData[0]
		Global.PLAYER_1_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[1])
		p1_ready = true
		p2_ready = true
		ready_up_peer()


func resolve_portrait(row:int, col:int, is_p1:bool):
	var enumChara: int = all_characters[row][col]
	var portrait: String = ""
	if (is_p1):
		P1Portrait.change_portrait_all_character(enumChara)
	else:
		P2Portrait.change_portrait_all_character(enumChara)

func resolve_assist_portrait(row:int, col:int, is_p1:bool):
	var enumChara: int = all_characters[row][col]
	if (is_p1):
		enumChara = all_characters[row][col]
	var color: String = ""
	var portrait: String = ""
	if (is_p1):
		A1Portrait.change_portrait_all_character(enumChara, true)
	else:
		A2Portrait.change_portrait_all_character(enumChara, true)

func start_loading_process():
	resolve_colors()
	resolve_assist_colors()
	go_to_next_scene()

func go_to_prev_scene():
	get_tree().change_scene_to_file("res://game/menus/buttonmap/ComboTrialControllerPickMenuScreen.tscn")

func go_to_next_scene():
	get_tree().change_scene_to_file("res://game/menus/stagemusicselect/ComboTrialStageMusicSelect.tscn")
