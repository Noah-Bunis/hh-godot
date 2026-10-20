extends TrainingCharacterSelect

class_name VersusCPUCharacterSelect

func _ready():
	super._ready()
	MainMenuMusicControl.reset_seek()
	if (Global.TRAINING_P1):
		$P1Cursor.input_prefix = "player1_"
		$P2Cursor.input_prefix = "player1_"
		$P2Cursor.enable(false)
		$P2Cursor.visible = false
		$CanvasLayer/WinStreak.text = tr("UI_LABEL_WIN_STREAK").format({"count": Global.P1_WIN_STREAK})
	else:
		$P1Cursor.input_prefix = "player2_"
		$P2Cursor.input_prefix = "player2_"
		$P1Cursor.enable(false)
		$P1Cursor.visible = false
		$CanvasLayer/WinStreak.text = tr("UI_LABEL_WIN_STREAK").format({"count": Global.P2_WIN_STREAK})

func update_a1():
	if (Global.TRAINING_P1):
		super.update_a1()
		p1_active_cursor = $P2Cursor
		pick_random_opponent()

func update_a2():
	if (not Global.TRAINING_P1):
		super.update_a2()
		p2_active_cursor = $P1Cursor
		pick_random_opponent()

func pick_random_color() -> int:
	var colorNumber = rng.randi_range(1, Util.MAX_COLOR_PALETTE_NUMBER)
	return colorNumber

func pick_random_opponent():
	var randRow = 3
	var randCol = 1
	var randColor1 = 0
	var randColor2 = 0
	
	if (Global.TRAINING_P1):
		p2_color_number = pick_random_color()
		a2_color_number = pick_random_color()
		var charaData = resolve_characters(randRow, randCol)
		p2_color_number = fit_color_number_to_character(charaData[1], false, p2_color_number)
		unload_character(charaData[0],false,false)
		Global.PLAYER_2_NODE_PATH[0] = charaData[0]
		Global.PLAYER_2_CHARACTER[0] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[0])
		if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
			Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[2])
		
		charaData = resolve_assists(randRow, randCol, false)
		a2_color_number = fit_color_number_to_character(charaData[1], true, a2_color_number)
		unload_character(charaData[0],false,true)
		p2_active_cursor = null
		Global.PLAYER_2_NODE_PATH[1] = charaData[0]
		Global.PLAYER_2_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[1])
		p2_ready = true
		ready_up_peer()
	else:
		p1_color_number = pick_random_color()
		a1_color_number = pick_random_color()
		var charaData = resolve_characters(randRow, randCol)
		p1_color_number = fit_color_number_to_character(charaData[1], false, p1_color_number)
		unload_character(charaData[0],true,false)
		Global.PLAYER_1_NODE_PATH[0] = charaData[0]
		Global.PLAYER_1_CHARACTER[0] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[0])
		if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
			Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])
		
		randRow = 3
		randCol = p2_assist_select.cursor.gridX - 2
		charaData = resolve_assists(randRow, randCol, true)
		a1_color_number = fit_color_number_to_character(charaData[1], true, a1_color_number)
		unload_character(charaData[0], true,true)
		p1_active_cursor = null
		Global.PLAYER_1_NODE_PATH[1] = charaData[0]
		Global.PLAYER_1_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[1])
		p1_ready = true
		ready_up_peer()

func start_loading_process():
	resolve_colors()
	resolve_assist_colors()
	go_to_next_scene()

func go_to_prev_scene():
	get_tree().change_scene_to_file("res://game/menus/buttonmap/VersusCPUControllerPickMenuScreen.tscn")

func go_to_next_scene():
	get_tree().change_scene_to_file("res://game/menus/stagemusicselect/VersusCPUStageMusicSelect.tscn")
