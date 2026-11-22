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
var _analysis_frame := 0
var _analysis_was_frozen := false

@onready var _frame_bar: FrameBar = get_node_or_null("CanvasLayer/FrameBar") as FrameBar
@onready var _punish_analysis: PunishAnalysis = get_node_or_null("CanvasLayer/PunishAnalysis") as PunishAnalysis
@onready var _punish_analysis_p2: PunishAnalysis = get_node_or_null("CanvasLayer/PunishAnalysisP2") as PunishAnalysis
@onready var _move_data: ReplayMoveData = $CanvasLayer/MoveData
@onready var _move_data_p2: ReplayMoveData = $CanvasLayer/MoveDataP2

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
	message_label.text = tr("UI_STATUS_DATA_UPDATED")

func load_finished():
	message_label.text = tr("UI_STATUS_LOAD_COMPLETE")
	is_waiting = false

func load_progress(progress, full):
	message_label.text = tr("UI_STATUS_LOADING").format({"progress": progress, "total": full})

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
	if _frame_bar != null:
		$CanvasLayer/TrainingOptionsMenu.frame_bar_toggled.connect(_on_frame_bar_toggled)
		$CanvasLayer/TrainingOptionsMenu.assist_frame_bars_toggled.connect(_on_assist_frame_bars_toggled)
		_frame_bar.set_assist_rows_visible(false)
	if _punish_analysis != null or _punish_analysis_p2 != null:
		$CanvasLayer/TrainingOptionsMenu.punish_analysis_toggled.connect(_on_punish_analysis_toggled)
	$CanvasLayer/TrainingOptionsMenu.move_data_toggled.connect(_on_move_data_toggled)
	_move_data.reset_tracking()
	_move_data_p2.reset_tracking()
	
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
	_move_data.setup(fighter_game)
	_move_data_p2.setup(fighter_game)

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
		if SyncManager.current_tick >= 0:
			_move_data.capture_frame()
			_move_data_p2.capture_frame()
			_capture_analysis_frame()
		SyncManager.execute_mechanized_interpolation_frame(delta)
		if (SyncManager.current_tick >= 0):
			return true
	else:
		report_error("Execute frame failed, tick not present in log data")
	return false

func _on_frame_bar_toggled(is_visible: bool) -> void:
	if _frame_bar != null:
		_frame_bar.visible = is_visible

func _on_assist_frame_bars_toggled(is_visible: bool) -> void:
	if _frame_bar != null:
		_frame_bar.set_assist_rows_visible(is_visible)

func _on_punish_analysis_toggled(player_index: int, is_visible: bool) -> void:
	var analysis: PunishAnalysis = _punish_analysis if player_index == 0 else _punish_analysis_p2
	if analysis != null:
		analysis.set_enabled(is_visible)

func _on_move_data_toggled(player_index: int, is_visible: bool) -> void:
	var move_data: ReplayMoveData = _move_data if player_index == 0 else _move_data_p2
	move_data.visible = is_visible

func _reset_replay_analysis() -> void:
	_analysis_frame = 0
	_analysis_was_frozen = false
	if _frame_bar != null:
		_frame_bar.reset_at_frame(_analysis_frame)
	if _punish_analysis != null:
		_punish_analysis.reset_analysis()
	if _punish_analysis_p2 != null:
		_punish_analysis_p2.reset_analysis()
	_move_data.reset_tracking()
	_move_data_p2.reset_tracking()

func _capture_analysis_frame() -> void:
	if _frame_bar == null and _punish_analysis == null and _punish_analysis_p2 == null:
		return
	var entities: Array[BasePlayer] = [
		fighter_game.AssistPlayer1,
		fighter_game.ServerPlayer,
		fighter_game.ClientPlayer,
		fighter_game.AssistPlayer2,
	]
	var frozen: bool = fighter_game.frozen and fighter_game.frozenFrame > 0
	for entity in entities:
		if is_instance_valid(entity) and entity.currentState.get(Enums.StKey.hitStopFrame, 0) > 0:
			frozen = true
			break
	var skip_frozen_frame := frozen and _analysis_was_frozen
	_analysis_was_frozen = frozen
	if skip_frozen_frame:
		return

	_analysis_frame += 1
	if _frame_bar != null:
		for row in range(entities.size()):
			var entity: BasePlayer = entities[row]
			if not is_instance_valid(entity) or entity.fighterState == null:
				_frame_bar.capture_missing_row(row, _analysis_frame)
				continue
			var move_events: Array[FrameEvent] = []
			var move_state: State = entity.fighterState.state
			if move_state is AttackState or move_state is AirAttackState:
				move_events = FrameBar.get_frame_bar_move_events(
					move_state, entity.currentState.get(Enums.StKey.stateName, "")
				)
			_frame_bar.capture_state_changes(entity, _analysis_frame, move_events)

	if _punish_analysis != null and $CanvasLayer/TrainingOptionsMenu.punish_analysis_visible[0]:
		_punish_analysis.update_analysis(
			fighter_game.ServerPlayer, fighter_game.AssistPlayer1, fighter_game.ClientPlayer
		)
	if _punish_analysis_p2 != null and $CanvasLayer/TrainingOptionsMenu.punish_analysis_visible[1]:
		_punish_analysis_p2.update_analysis(
			fighter_game.ClientPlayer, fighter_game.AssistPlayer2, fighter_game.ServerPlayer
		)

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
		_reset_replay_analysis()
	replay_speed = 0
	error_label.text = ""
	message_label.text = tr("UI_STATUS_REWINDING")

func speed_up_replay():
	replay_speed = 4
	message_label.text = tr("UI_STATUS_FAST_FORWARDING")

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
		message_label.text = tr("UI_STATUS_TAKEOVER_P2")
		takeover_is_p1 = false
	else:
		fighter_game.get_node("ClientInputInterpreter").set_script(ReplayInputInterpreterScript)
		fighter_game.get_node("ServerInputInterpreter").set_script(InputInterpreterScript)
		message_label.text = tr("UI_STATUS_TAKEOVER_P1")
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
		_reset_replay_analysis()
	else:
		message_label.text = tr("UI_STATUS_NO_REPLAY_TAKEOVER")

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
