extends Container

signal close_menu()

var menu_close_delay: int
var rendering_complete: bool
var index: int
var icon_paths: Dictionary = load("res://game/ui/IconPaths.gd").ICON_PATHS
var button_icon_size: int = 20

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	rendering_complete = false
	index = 0
	$Moves.columns = 1
	$P2Moves.columns = 1
	$UniversalMechanics.columns = 1

func reset_position():
	$Moves.position.x = 0
	$Moves.position.y = 24
	$P2Moves.position.x = 0
	$P2Moves.position.y = 24
	$UniversalMechanics.position.x = 0
	$UniversalMechanics.position.y = 24

func _physics_process(delta):
	if menu_close_delay > 0:
		menu_close_delay -= 1
		if (menu_close_delay == 0):
			close_command_list()
	
	var vertical_input: float
	vertical_input = -Input.get_action_strength("player2_down") + Input.get_action_strength("player2_up") -Input.get_action_strength("player2_down_stick") + Input.get_action_strength("player2_up_stick")
	if (abs(vertical_input) < 0.2):
		vertical_input = -Input.get_action_strength("player1_down") + Input.get_action_strength("player1_up") -Input.get_action_strength("player1_down_stick") + Input.get_action_strength("player1_up_stick")
	if (vertical_input > 0.5):
		scroll_up()
	elif (vertical_input < -0.5):
		scroll_down()

func open_command_list():
	if (not is_enabled()):
		self.visible = true
		$CloseButton.grab_focus()
		load_character_moves()
		reset_position()
		display_move_list()
	
func set_close_delay():
	if (is_enabled()):
		menu_close_delay = 2

func close_command_list():
	if (is_enabled()):
		self.visible = false
		emit_signal("close_menu")

func _on_CloseButton_pressed():
	set_close_delay()

func is_enabled() -> bool:
	return self.visible

func load_character_moves():
	if (not rendering_complete):
		var point: int = Global.PLAYER_1_CHARACTER[0]
		var assist: int = Global.PLAYER_1_CHARACTER[1]
		load_player_move_list(point, assist, $Moves)
		point = Global.PLAYER_2_CHARACTER[0]
		assist = Global.PLAYER_2_CHARACTER[1]
		load_player_move_list(point, assist, $P2Moves)
		load_move_list(Enums.UniversalMoveList, $UniversalMechanics)
		$UniversalMechanics.visible = false
		rendering_complete = true

func load_player_move_list(point, assist, container):
	match point:
		Enums.PointCharacters.Subaru:
			load_move_list(Enums.SubaruMoveList, container)
		Enums.PointCharacters.Mio:
			load_move_list(Enums.MioMoveList, container)
		Enums.PointCharacters.Oga:
			load_move_list(Enums.OgaMoveList, container)
		Enums.PointCharacters.Ollie:
			load_move_list(Enums.OllieMoveList, container)
		Enums.PointCharacters.Kanata:
			load_move_list(Enums.KanataMoveList, container)
		Enums.PointCharacters.Suisei:
			load_move_list(Enums.SuiseiMoveList, container)
		Enums.PointCharacters.Flayon:
			load_move_list(Enums.FlayonMoveList, container)
		_:
			printerr("invalid point character given")
	match assist:
		Enums.AssistCharacters.Fubuki:
			load_move_list(Enums.FubukiMoveList, container)
		Enums.AssistCharacters.Sora:
			load_move_list(Enums.SoraMoveList, container)
		Enums.AssistCharacters.OkaKoro:
			load_move_list(Enums.OkakoroMoveList, container)
		Enums.AssistCharacters.Sana:
			load_move_list(Enums.SanaMoveList, container)
		Enums.AssistCharacters.Hakka:
			load_move_list(Enums.HakkaMoveList, container)
		Enums.AssistCharacters.Subaru:
			load_move_list(Enums.AssistSubaruMoveList, container)
		Enums.AssistCharacters.Mio:
			load_move_list(Enums.AssistMioMoveList, container)
		Enums.AssistCharacters.Oga: 
			load_move_list(Enums.AssistOgaMoveList, container)
		Enums.AssistCharacters.Ollie:
			load_move_list(Enums.AssistOllieMoveList, container)
		Enums.AssistCharacters.Kanata: 
			load_move_list(Enums.AssistKanataMoveList, container)
		Enums.AssistCharacters.Suisei:
			load_move_list(Enums.AssistSuiseiMoveList, container)
		_:
			printerr("invalid assist character given")

func load_move_list(move_list, container):
	var newLabel: RichTextLabel
	var newText: String = ""
	for row in move_list:
		newText = ""
		for i in row.size():
			var item_string := str(row[i])
			for j in item_string.length():
				var character := item_string[j]
				if _should_parse_icon(item_string, j):
					newText += _bbcode_icon(character)
				else:
					newText += character
			newText += "   "
		newLabel = RichTextLabel.new()
		newLabel.bbcode_enabled = true
		newLabel.fit_content = true
		newLabel.text = newText
		newLabel.custom_minimum_size.x = 600
		newLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART 
		container.add_child(newLabel)
	newText = " "
	newLabel = RichTextLabel.new()
	newLabel.bbcode_enabled = true
	newLabel.fit_content = true
	newLabel.text = newText
	container.add_child(newLabel)

func scroll_up():
	if ($Moves.visible):
		$Moves.position.y += 5
	elif ($P2Moves.visible):
		$P2Moves.position.y += 5
	elif ($UniversalMechanics.visible):
		$UniversalMechanics.position.y += 5

func scroll_down():
	if ($Moves.visible):
		$Moves.position.y -= 5
	elif ($P2Moves.visible):
		$P2Moves.position.y -= 5
	elif ($UniversalMechanics.visible):
		$UniversalMechanics.position.y -= 5

func scroll_left():
	index -= 1
	if (index < 0):
		index = 2
	display_move_list()

func scroll_right():
	index += 1
	if (index > 2):
		index = 0
	display_move_list()

func display_move_list():
	if (index == 0):
		$UniversalMechanics.visible = false
		$P2Moves.visible = false
		$Moves.visible = true
		$Sprite2D.self_modulate.r = .1
		$Sprite2D.self_modulate.g = .3
		$Sprite2D.self_modulate.b = .1
	elif (index == 1):
		$UniversalMechanics.visible = false
		$P2Moves.visible = true
		$Moves.visible = false
		$Sprite2D.self_modulate.r = .1
		$Sprite2D.self_modulate.g = .2
		$Sprite2D.self_modulate.b = .4
	else:
		$UniversalMechanics.visible = true
		$P2Moves.visible = false
		$Moves.visible = false
		$Sprite2D.self_modulate.r = .1
		$Sprite2D.self_modulate.g = .1
		$Sprite2D.self_modulate.b = .1

func _input(event):
	input_helper(event)

func input_helper(event: InputEvent):
	if event.is_action_pressed("player1_start") or event.is_action_pressed("player2_start"):
		_on_CloseButton_pressed()
	elif event.is_action_pressed("player1_cancel") or event.is_action_pressed("player2_cancel"):
		_on_CloseButton_pressed()
	elif Util.is_left_pressed(true):
		scroll_left()
	elif Util.is_left_pressed(false):
		scroll_left()
	elif Util.is_right_pressed(true):
		scroll_right()
	elif Util.is_right_pressed(false):
		scroll_right()


func _bbcode_icon(name: String) -> String:
	var path = icon_paths.get(name, "")
	if path == "":
		return name
	return "[img width=%d height=%d]%s[/img]"% [button_icon_size, button_icon_size, path]

func _should_parse_icon(text: String, index: int) -> bool:
	var character := text[index]
	if not icon_paths.has(character):
		return false

	if character in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]:
		if text.length() == 1:
			return false

		var previous := text[index - 1] if index > 0 else ""
		var next := text[index + 1] if index < text.length() - 1 else ""

		if next == " " or (next == "" and previous != ""):
			return false

	if character in ["A", "B", "C", "D", "X"]:
		if text.length() == 1:
			return true

		var previous := text[index - 1] if index > 0 else ""
		var next := text[index + 1] if index < text.length() - 1 else ""

		return (
			(previous != "" and (previous.is_valid_int() or previous in ["[", "]", "+"]))
			or
			(next != "" and (next.is_valid_int() or next in ["[", "]", "+"]))
		)
	return true