extends Node

class_name StageMusicSelect

var input_prefix: String

var stage_id: int
var bgm_id: int

var selected_index: int

var frame_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	prepare_stage_music_select()
	frame_timer = -1

func _physics_process(delta):
	if (frame_timer > 0):
		frame_timer -= 1
		if frame_timer == 0:
			_setup_match_deferred()

func prepare_stage_music_select():
	if (Global.P1_WON_MATCH):
		$P1Side.queue_free()
		input_prefix = "player2_"
	else:
		$P2Side.queue_free()
		input_prefix = "player1_"
	selected_index = 0
	stage_id = Global.STAGE_ART_ID
	bgm_id = Global.BGM_ID
	if (Global.STAGE_RANDOM_ONCE):
		stage_id = 1
	if (Global.BGM_RANDOM_ONCE):
		bgm_id = 1
	update_UI()

func go_to_prev_scene():
	MainMenuMusicControl.play_cursor_deselect()
	get_tree().change_scene_to_file("res://game/menus/characterselect/CharacterSelect.tscn")

func go_to_next_scene():
	get_tree().change_scene_to_file("res://game/OfflineVersusMain.tscn")

func _setup_match_deferred():
	MainMenuMusicControl.stop_music()
	
	Global.SET_TOTAL = 0
	Global.P1_SET_WIN_TOTAL = 0
	
	Global.STAGE_ART_ID = stage_id
	Global.BGM_ID = bgm_id
	if (evaluate_p1_side_bgm()):
		Global.BGM_IS_P1_SIDE = true
	else:
		Global.BGM_IS_P1_SIDE = false
	
	if (Global.STAGE_ART_ID == 1):
		Global.STAGE_RANDOM_ONCE = true
	else:
		Global.STAGE_RANDOM_ONCE = false
	if (Global.BGM_ID == 1):
		Global.BGM_RANDOM_ONCE = true
	else:
		Global.BGM_RANDOM_ONCE = false
	MainMenuMusicControl.play_cursor_select()
	MainMenuMusicControl.reset_seek()
		
	Global.PLAYER_1_NODE[0] = Global.load_queue.get_resource(Global.PLAYER_1_NODE_PATH[0])
	Global.PLAYER_1_NODE_INSTANCE[0] = Global.PLAYER_1_NODE[0].instantiate()
	
	Global.PLAYER_2_NODE[0] = Global.load_queue.get_resource(Global.PLAYER_2_NODE_PATH[0])
	Global.PLAYER_2_NODE_INSTANCE[0] = Global.PLAYER_2_NODE[0].instantiate()
	
	Global.PLAYER_1_NODE[1] = Global.load_queue.get_resource(Global.PLAYER_1_NODE_PATH[1])
	Global.PLAYER_1_NODE_INSTANCE[1] = Global.PLAYER_1_NODE[1].instantiate()
	
	Global.PLAYER_2_NODE[1] = Global.load_queue.get_resource(Global.PLAYER_2_NODE_PATH[1])
	Global.PLAYER_2_NODE_INSTANCE[1] = Global.PLAYER_2_NODE[1].instantiate()
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.PLAYER_1_NODE[2] = Global.load_queue.get_resource(Global.PLAYER_1_NODE_PATH[2])
		Global.PLAYER_1_NODE_INSTANCE[2] = Global.PLAYER_1_NODE[2].instantiate()
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.PLAYER_2_NODE[2] = Global.load_queue.get_resource(Global.PLAYER_2_NODE_PATH[2])
		Global.PLAYER_2_NODE_INSTANCE[2] = Global.PLAYER_2_NODE[2].instantiate()
	Global.load_queue.load_stage_art()
	go_to_next_scene()

func evaluate_p1_side_bgm():
	return not Global.P1_WON_MATCH

func setup_match():
	disable_controls()
	var load_screen = load("res://game/ui/LoadingScreen.tscn").instantiate()
	add_child(load_screen)
	frame_timer = 2
	
func disable_controls():
	$CanvasLayer.hide()

func update_UI():
	var cursor = $P1Side
	if (cursor == null):
		cursor = $P2Side
	
	if (selected_index == 0):
		cursor.position.y = 124
	else:
		cursor.position.y = 624
	
	$CanvasLayer/StageLabel.text = tr("UI_LABEL_STAGE").format({"stage": Global.STAGE_LIST[stage_id]})
	$CanvasLayer/BGMLabel.text = tr("UI_LABEL_BGM").format({"bgm": Global.BGM_LIST[bgm_id]})

func update_selected_index():
	selected_index = (selected_index + 1) % 2
	update_UI()

func update_left_index():
	if (selected_index == 1):
		stage_id -= 1
		if (stage_id < 0):
			stage_id = Global.STAGE_LIST.size() - 1
	else:
		bgm_id -= 1
		if (bgm_id < 0):
			bgm_id = Global.BGM_LIST.size() - 1
	update_UI()

func update_right_index():
	if (selected_index == 1):
		stage_id += 1
		if (stage_id > Global.STAGE_LIST.size() - 1):
			stage_id = 0
	else:
		bgm_id += 1
		if (bgm_id > Global.BGM_LIST.size() - 1):
			bgm_id = 0
	update_UI()

func _input(event):
	if (frame_timer < 0):
		if Util.is_left_pressed_prefix(input_prefix):
			update_left_index()
		elif Util.is_right_pressed_prefix(input_prefix):
			update_right_index()
		elif Util.is_up_pressed_prefix(input_prefix):
			update_selected_index()
		elif Util.is_down_pressed_prefix(input_prefix):
			update_selected_index()
		elif Input.is_action_just_pressed(input_prefix+"a"):
			Global.BGM_IS_ASSIST = false
			setup_match()
		elif Input.is_action_just_pressed(input_prefix+"b"):
			Global.BGM_IS_ASSIST = false
			setup_match()
		elif Input.is_action_just_pressed(input_prefix+"c"):
			Global.BGM_IS_ASSIST = false
			setup_match()
		elif Input.is_action_just_pressed(input_prefix+"d"):
			Global.BGM_IS_ASSIST = true
			setup_match()
		elif Input.is_action_just_pressed("player1_cancel") or Input.is_action_just_pressed("player2_cancel") or Input.is_action_just_pressed("menu_back_b"):
			go_to_prev_scene()
