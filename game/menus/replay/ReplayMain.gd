extends DemoMain

class_name ReplayMain

@onready var error_label = $CanvasLayer/ErrorLabel
#var replay_file: FileAccess
const LogData = preload("res://game/menus/replay/ReplayLogData.gd")
const ReplayInputInterpreterScript = preload("res://game/fighter/ReplayInputInterpreter.gd")
const InputInterpreterScript = preload("res://game/fighter/InputInterpreter.gd")
var log_data
var current_tick := 0 # first log input is on tick 1
var replay_speed := 1
var rewind_delay = 0
var rewind_hold = 0
var setup_complete: bool = false

var takeover_state = {}
var takeover_is_p1 = true
var takeover_tick = 1

var state = {}
var state_tick_gap = 30

var dummy_input1: InputInterpreter
var dummy_input2: InputInterpreter

var is_waiting: bool

func _init() -> void:
	super._init()
	logging_enabled = false
	replay_logging_enabled = false
	game_mode_root = "/root/ReplayMain/FighterGame"
	Global.HITBOX_DISPLAY = true
	Global.TRAINING_HITBOX_ON = false
	is_waiting = true
	setup_complete = false

func report_error(msg):
	error_label.visible = true
	error_label.text = msg

func data_updated():
	message_label.text = "Data updated"

func load_finished():
	message_label.text = "Load complete!"
	is_waiting = false

func load_progress(progress, full):
	message_label.text = "Loading: " + str(progress) + "/" + str(full)

func setup_main() -> void:
	signal_connect()
	
	match_disconnected = false
	peer_ready = {}
	
	$FighterGame/ServerInputInterpreter.set_multiplayer_authority(1)
	
	logging_enabled = false

	$CanvasLayer/PingLabel.hide()
	$CanvasLayer/RollbackFrameLabel.hide()
	
	$CanvasLayer/TrainingOptionsMenu.connect("close_menu", Callable(self, "unpause_game"))
	$CanvasLayer/TrainingOptionsMenu.connect("exit", Callable(self, "exit"))
	$CanvasLayer/TrainingOptionsMenu.connect("reset", Callable(self, "reset"))
	$CanvasLayer/TrainingOptionsMenu.connect("loadstate", Callable(self, "takeover_loadstate"))
	
	var log_file_name = Global.REPLAY_FILE_NAME
	log_data = LogData.new()
	log_data.connect("load_error", Callable(self, "report_error"))
	log_data.connect("data_updated", Callable(self, "data_updated"))
	log_data.connect("load_finished", Callable(self, "load_finished"))
	log_data.connect("load_progress", Callable(self, "load_progress"))
	load_file(REPLAY_LOG_FILE_DIRECTORY + '/' + log_file_name)
	SyncManager.stop()
	SyncManager.clear_peers()
	
	setup_replay()

func load_file(save_path: String):
	if FileAccess.file_exists(save_path):
		log_data.load_log_file(save_path)
	else:
		print("replay doesn't exist")
		call_deferred("report_error","Replay file doesn't exist")

func process_message(match_info: Dictionary):
	SyncManager.stop()
	SyncManager.clear_peers()

	SyncManager.network_adaptor = DummyNetworkAdaptor.new()
	setup_mechanized()
	if (match_info.is_empty()):
		return false
	Global.PLAYER_1_NODE[0] = null
	Global.PLAYER_1_NODE[1] = null
	Global.PLAYER_2_NODE[0] = null
	Global.PLAYER_2_NODE[1] = null
	Global.PLAYER_1_NODE[2] = null
	Global.PLAYER_2_NODE[2] = null
	setup_match_for_replay(1, [1], match_info)

	return true

func setup_mechanized():
	SyncManager.mechanized = true

func _do_execute_frame_mechanized(tick, delta) -> bool:
	if (tick <= log_data.max_tick):
		if ((tick-1) % state_tick_gap == 0):
			state[tick] = SyncManager._call_save_state()
		
		var input_frames_received: Dictionary = {}
		var p1_input_dict = {}
		var p2_input_dict = {}
		var peer_dict = {}
		var p1_input_package = {}
		var p2_input_package = {}
		if (SyncManager.current_tick >= 0):
			if (tick >= 1):
				p1_input_dict[Enums.PlayerInput.InputVector] = log_data.p1_input[tick]
				p2_input_dict[Enums.PlayerInput.InputVector] = log_data.p2_input[tick]
				if (not takeover_state.is_empty()):
					if (takeover_is_p1):
						p1_input_dict = read_input()
					else:
						p2_input_dict = read_input()
			else:
				p1_input_dict[Enums.PlayerInput.InputVector] = 0
				p2_input_dict[Enums.PlayerInput.InputVector] = 0
			peer_dict[game_mode_root+"/ServerInputInterpreter"] = p1_input_dict
			peer_dict[game_mode_root+"/ClientInputInterpreter"] = p2_input_dict
			p1_input_package[SyncManager.current_tick + 1] = peer_dict
			p2_input_package[SyncManager.current_tick + 1] = peer_dict
			input_frames_received[1] = p1_input_package
			input_frames_received[2] = p2_input_package
		else:
			pass
		SyncManager.mechanized_input_received = input_frames_received
		SyncManager.mechanized_rollback_ticks = 0
		SyncManager.execute_mechanized_tick()
		SyncManager.execute_mechanized_interpolation_frame(delta)
		if (SyncManager.current_tick >= 0):
			return true
	else:
		report_error("Execute frame failed, tick not present in log data")
	return false

func _physics_process(delta):
	if (is_waiting):
		return
		
	var completed
	if (not setup_complete):
		completed = process_message(log_data.match_info)
		start_replay_sync()
		current_tick = 0
		
	if (setup_complete):
		for i in range(replay_speed):
			completed = _do_execute_frame_mechanized(current_tick, delta)
			
			if (completed):
				current_tick += 1
			else:
				if (SyncManager.current_tick >= 0):
					report_error("incomplete execute frame")
		replay_controls()

func _process(delta):
	if (is_waiting):
		return

	if (setup_complete):
		SyncManager.execute_mechanized_interpolation_frame(delta)

func start_replay_sync():
	setup_complete = true
	SyncManager.input_delay = 2
	SyncManager.start()
	if (fighter_game.get_node("Camera3D/BattleUI/WinScreenManager") != null):
		if (fighter_game.get_node("Camera3D/BattleUI/RoundTracker") != null):
			fighter_game.get_node("Camera3D/BattleUI/RoundTracker").disconnect("win", Callable(fighter_game.get_node("Camera3D/BattleUI/WinScreenManager"), "start_win_process"))
		

func get_next_rewind_tick(tick):
	var last_state_tick: int = int(tick / state_tick_gap)
	last_state_tick *= state_tick_gap
	last_state_tick += 1
	if (tick == last_state_tick):
		last_state_tick -= state_tick_gap
	if (last_state_tick <= 1):
		last_state_tick = 1 + state_tick_gap
	return last_state_tick
	
func get_rewind_state(tick):
	if (state.has(tick)):
		return state[tick]
	else:
		call_deferred("emit_signal", "load_error", "Error while rewinding replay")
		return {}

func replay_controls():
	if (not $CanvasLayer/TrainingOptionsMenu.is_enabled()):
		if (takeover_state.is_empty()):
			var x = -Input.get_action_strength("player1_left") + Input.get_action_strength("player1_right")
			if (abs(x) < .2):
				x = -Input.get_action_strength("player1_left_stick") + Input.get_action_strength("player1_right_stick")

			var virtual_deadzone = 0
			if (x < -virtual_deadzone):
				rewind_hold += 1
				if (rewind_delay > 0):
					rewind_delay -= 1
				else:
					rewind()
					rewind_delay = 10 - (rewind_hold / 20)
					if (rewind_delay < 1):
						rewind_delay = 1
			elif (x > virtual_deadzone and current_tick > 5):
				speed_up_replay()
				rewind_delay = 0
				rewind_hold = 0
			else:
				normal_speed()
				rewind_delay = 0
				rewind_hold = 0
		else:
			replay_speed = 1
	else:
		replay_speed = 0

func rewind():
	var rewind_tick = get_next_rewind_tick(current_tick)
	var next_state = get_rewind_state(rewind_tick)
	if (not next_state.is_empty()):
		SyncManager._call_load_state(next_state)
		current_tick = rewind_tick
	replay_speed = 0
	error_label.text = ""
	message_label.text = "rewinding..."

func speed_up_replay():
	replay_speed = 4
	message_label.text = "fast forwarding..."

func normal_speed():
	replay_speed = 1
	message_label.text = ""

func exit():
	sync_clear()
	MainMenuMusicControl.stop_music()
	free_main()
	Global.PLAYER_1_NODE[0] = null
	Global.PLAYER_1_NODE_INSTANCE[0] = null
	Global.PLAYER_2_NODE[0] = null
	Global.PLAYER_2_NODE_INSTANCE[0] = null
	Global.PLAYER_1_NODE[1] = null
	Global.PLAYER_1_NODE_INSTANCE[1] = null
	Global.PLAYER_2_NODE[1] = null
	Global.PLAYER_2_NODE_INSTANCE[1] = null
	
	Global.PLAYER_1_NODE[2] = null
	Global.PLAYER_1_NODE_INSTANCE[2] = null
	Global.PLAYER_2_NODE[2] = null
	Global.PLAYER_2_NODE_INSTANCE[2] = null
	
	get_tree().change_scene_to_file("res://game/menus/replay/ReplayFileMenu.tscn")

func reset():
	sync_clear()
	#reload_scene()
	fighter_game.stop_glowing_characters()
	get_tree().reload_current_scene()

func control_the_dummy(is_p1):
	if (not is_p1):
		fighter_game.get_node("ServerInputInterpreter").set_script(ReplayInputInterpreterScript)
		fighter_game.get_node("ClientInputInterpreter").set_script(InputInterpreterScript)
		message_label.text = "takeover p2"
		takeover_is_p1 = false
	else:
		fighter_game.get_node("ClientInputInterpreter").set_script(ReplayInputInterpreterScript)
		fighter_game.get_node("ServerInputInterpreter").set_script(InputInterpreterScript)
		message_label.text = "takeover p1"
		takeover_is_p1 = true
	takeover_savestate()

func return_control_to_recording():
	takeover_state = {}
	message_label.text = ""
	
func setup_replay():
	dummy_input2 = fighter_game.get_node("ClientInputInterpreter")
	dummy_input2.input_prefix = "player1_"
	dummy_input1 = fighter_game.get_node("ServerInputInterpreter")
	dummy_input1.input_prefix = "player1_"
	return_control_to_recording()
	
func toggle_menu():
	get_tree().paused = true
	$CanvasLayer/TrainingOptionsMenu.open_training_options_menu()

func unpause_game():
	get_tree().paused = false
	try_take_control()

func try_take_control():
	var player: int = $CanvasLayer/TrainingOptionsMenu.get_takeover_player()
	var is_p1 = false
	if (player == 1):
		is_p1 = true
	
	if (player == 0):
		if (not takeover_state.is_empty()):
			takeover_loadstate()
		return_control_to_recording()
	else:
		if (takeover_state.is_empty()):
			control_the_dummy(is_p1)
		else:
			if (takeover_is_p1 != is_p1):
				control_the_dummy(is_p1)
	
func takeover_savestate():
	if (takeover_state.is_empty()):
		takeover_state = SyncManager._call_save_state()
		takeover_tick = current_tick

func takeover_loadstate():
	if (not takeover_state.is_empty()):
		SyncManager._call_load_state(takeover_state)
		current_tick = takeover_tick
	else:
		message_label.text = "not currently in replay takeover state"

func input_helper(event):
	if Input.is_action_just_pressed("player1_start") or Input.is_action_just_pressed("player1_record"):
		toggle_menu()
	elif Input.is_action_just_pressed("player1_cancel") or Input.is_action_just_pressed("player1_replay"):
		takeover_loadstate()


func read_input() -> Dictionary:
	var input_prefix = "player1_"
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

	if (Input.get_action_strength(input_prefix+"abcd") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.BHold
		bit_input |= Enums.InputFlags.CHold
		bit_input |= Enums.InputFlags.DHold
	elif (Input.get_action_strength(input_prefix+"abc") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.BHold
		bit_input |= Enums.InputFlags.CHold
	elif (Input.get_action_strength(input_prefix+"bc") > 0):
		bit_input |= Enums.InputFlags.BHold
		bit_input |= Enums.InputFlags.CHold
		
	if (Input.get_action_strength(input_prefix+"ad") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.DHold

	if (Input.get_action_strength(input_prefix+"a") > 0):
		bit_input |= Enums.InputFlags.AHold
	
	if (Input.get_action_strength(input_prefix+"b") > 0):
		bit_input |= Enums.InputFlags.BHold
	
	if (Input.get_action_strength(input_prefix+"c") > 0):
		bit_input |= Enums.InputFlags.CHold
		
	if (Input.get_action_strength(input_prefix+"d") > 0):
		bit_input |= Enums.InputFlags.DHold

	var input := {}
	input[Enums.PlayerInput.InputVector] = bit_input
	return input
