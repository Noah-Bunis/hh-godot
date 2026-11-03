extends DemoMain

class_name TrainingMain

enum TrainingResetPosition {
	CENTER,
	CENTER_SWITCHED,
	LEFT,
	LEFT_SWITCHED,
	RIGHT,
	RIGHT_SWITCHED,
}

var meter_refresher: TrainingMeterRefresher
var savestate: Dictionary
var last_reset_position: int = TrainingResetPosition.CENTER
var state_history: Array
var reaction_save_state: Dictionary
var dummy_input: InputInterpreter
var load_state_delay: int = 0

var is_recording: bool = false
var is_replaying: bool = false
var player_input: InputInterpreter
var record_left_face_ref: bool

var recording_machine
var replay_restore_player_input: InputInterpreter

var _input_frames_received: Dictionary = {}
var _reaction_state_active: bool = false
var _move_data_state_name: String = ""
var _move_data_advantage_locked: bool = false
var _move_data_contacted: bool = false
var _move_data_actor: BasePlayer
var _move_data_advantage_player: BasePlayer
var _move_data_advantage_state_name: String = ""
var _move_data_contact_advantage: int = 0
var _move_data_contact_end_frame: int = 0
var _move_data_contact_start_frame: int = 0
var _move_data_contact_last_frame: int = 0
var _move_data_projectile_sources: Dictionary = {}
var _has_move_data_ui: bool = false

func _init() -> void:
	super._init()
	logging_enabled = false
	replay_logging_enabled = false
	meter_refresher = TrainingMeterRefresher.new()
	recording_machine = preload("res://game/menus/training/TrainingRecordingMachine.gd").new()
	recording_machine.switch_section(0)
	meter_refresher.fighter_game = fighter_game
	game_mode_root = "/root/TrainingMain/FighterGame"
	fighter_game.ko_enabled = false
	Global.HITBOX_DISPLAY = true
	Global.TRAINING_HITBOX_ON = false
	savestate = {}
	state_history = []
	fillWith(state_history, {}, 3+SyncManager.input_delay)

func setup_mechanized():
	SyncManager.mechanized = true

func fillWith(array, contents, size):
	for i in range(size):
		array.push_back(contents)

func _ready() -> void:
	setup_mechanized()
	super._ready()
	setup_training()
	var controlled_is_p1: bool = self is ComboTrialMain or Global.TRAINING_P1
	$CanvasLayer/TrainingOptionsMenu.set_training_character(
		controlled_is_p1,
		false,
		_get_side_character(controlled_is_p1, false)
	)
	$CanvasLayer/TrainingOptionsMenu.set_training_character(
		controlled_is_p1,
		true,
		_get_side_character(controlled_is_p1, true)
	)
	$CanvasLayer/TrainingOptionsMenu.set_training_character(
		not controlled_is_p1,
		false,
		_get_side_character(not controlled_is_p1, false)
	)
	$CanvasLayer/TrainingOptionsMenu.set_training_character(
		not controlled_is_p1,
		true,
		_get_side_character(not controlled_is_p1, true)
	)
	$CanvasLayer/TrainingOptionsMenu.connect("close_menu", Callable(self, "set_new_training_options"))
	$CanvasLayer/TrainingOptionsMenu.connect("exit", Callable(self, "exit"))
	$CanvasLayer/TrainingOptionsMenu.connect("reset", Callable(self, "reset"))
	$CanvasLayer/TrainingOptionsMenu.connect("loadstate", Callable(self, "loadstate_menu"))
	$CanvasLayer/TrainingOptionsMenu.connect("savestate", Callable(self, "execute_savestate"))
	$CanvasLayer/TrainingOptionsMenu.connect("play_demo", Callable(self, "play_demo"))
	$CanvasLayer/TrainingOptionsMenu.command_list = $CanvasLayer/CommandList
	$CanvasLayer/TrainingOptionsMenu.command_list.connect("close_menu", Callable($CanvasLayer/TrainingOptionsMenu, "command_list_closed"))
	dummy_input.connect("strike_hurt", Callable(self, "load_reaction_state"))
	_has_move_data_ui = has_node("CanvasLayer/MoveData")
	if (_has_move_data_ui):
		$CanvasLayer/TrainingOptionsMenu.connect("move_data_toggled", Callable(self, "_on_move_data_toggled"))
		_on_move_data_toggled($CanvasLayer/TrainingOptionsMenu.move_data_visible)
		for training_opponent in _get_move_data_opponents():
			training_opponent.attack_hurt_resolved.connect(
				Callable(self, "_on_training_opponent_attack_hurt").bind(training_opponent)
			)
		for attacker in _get_move_data_attackers():
			attacker.projectilespawn.connect(
				Callable(self, "_on_move_data_projectile_spawned").bind(attacker)
			)
		_reset_move_data_display()

func _on_move_data_toggled(is_visible: bool) -> void:
	$CanvasLayer/MoveData.visible = is_visible

func _on_training_opponent_attack_hurt(
	hitbox_name: String,
	hit_type: int,
	_opponent: BasePlayer
) -> void:
	var was_parried: bool = hit_type == Enums.HitType.Parry
	var player: BasePlayer = _find_move_data_attacker(hitbox_name)
	if (player == null):
		var projectile_source: Dictionary = _move_data_projectile_sources.get(
			_normalize_projectile_name(hitbox_name),
			{}
		)
		if (projectile_source.is_empty()):
			return
		player = projectile_source["actor"]
		if (not is_instance_valid(player)):
			return
		_queue_move_data_contact(
			player,
			projectile_source["move_data"],
			true,
			was_parried
		)
		return
	_queue_move_data_contact(player, {}, false, was_parried)

func _on_move_data_projectile_spawned(
	_x: int,
	_y: int,
	_scene: PackedScene,
	node_name: String,
	_player_data: PlayerSetup,
	attacker: BasePlayer
) -> void:
	if (attacker.fighterState == null):
		return
	var move_state: State = attacker.fighterState.state
	var move_data: Dictionary = _get_move_frame_data(move_state)
	_move_data_projectile_sources[_normalize_projectile_name(node_name)] = {
		"actor": attacker,
		"move_data": move_data,
	}

func _normalize_projectile_name(projectile_name: String) -> String:
	return projectile_name.rstrip("0123456789")

func _queue_move_data_contact(
	player: BasePlayer,
	move_data_snapshot: Dictionary = {},
	is_projectile: bool = false,
	was_parried: bool = false
) -> void:
	if (player.fighterState == null):
		return
	var move_state: State = player.fighterState.state
	var move_data: Dictionary = move_data_snapshot
	if (move_data.is_empty()):
		if (not is_projectile and not move_state is AttackState and not move_state is AirAttackState):
			return
		move_data = _get_move_frame_data(move_state)
	if (move_data.is_empty() and not is_projectile):
		return
	call_deferred(
		"_record_move_data_contact",
		player,
		player.currentState.get(Enums.StKey.stateName, ""),
		move_data,
		is_projectile,
		was_parried
	)

func _record_move_data_contact(
	player: BasePlayer,
	move_state_name: String,
	move_data_snapshot: Dictionary,
	is_projectile: bool,
	was_parried: bool
) -> void:
	if (not is_instance_valid(player) or player.fighterState == null):
		return
	var base_player: BasePlayer = _get_controlled_player()
	var opponent: BasePlayer = _get_opponent_point_player()
	if (base_player.fighterState == null):
		return
	if (move_data_snapshot.is_empty()):
		var move_state: State = player.fighterState.state
		if (not is_projectile and not move_state is AttackState and not move_state is AirAttackState):
			return
		move_data_snapshot = _get_move_frame_data(move_state)
		if (move_data_snapshot.is_empty() and not is_projectile):
			return
	var opponent_stun: int = 0 if was_parried else opponent.currentState.get(Enums.StKey.hitstun, 0)
	if (opponent_stun <= 0 and not was_parried):
		return
	var opponent_next_state: String = opponent.currentState.get(Enums.StKey.next_state, "")
	if (opponent.currentState.get(Enums.StKey.transition_state_flag, false)
			and opponent_next_state.ends_with("HurtCrouch")):
		opponent_stun += 1

	var base_move_state: State = base_player.fighterState.state
	var player_recovery: int = maxi(
		base_move_state.endFrame - base_player.currentState.get(Enums.StKey.frame, 0),
		0
	)
	_move_data_contact_advantage = _calculate_frame_advantage(
		base_player,
		opponent,
		opponent_stun,
		player_recovery
	)
	_move_data_contact_end_frame = base_move_state.endFrame
	_move_data_contact_last_frame = base_player.currentState.get(Enums.StKey.frame, 0)

	_move_data_actor = player
	_move_data_advantage_player = base_player
	_move_data_advantage_state_name = base_player.currentState.get(Enums.StKey.stateName, "")
	_move_data_state_name = move_state_name
	_move_data_advantage_locked = true
	_move_data_contacted = true
	if (not move_data_snapshot.is_empty()):
		_set_move_data_frame_values(move_data_snapshot)
	else:
		$CanvasLayer/MoveData/AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " --"
		$CanvasLayer/MoveData/ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " --"
		$CanvasLayer/MoveData/AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " --"
	$CanvasLayer/MoveData/FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " --"

func _get_controlled_player() -> BasePlayer:
	return fighter_game.ServerPlayer if (self is ComboTrialMain or Global.TRAINING_P1) else fighter_game.ClientPlayer

func _get_opponent_point_player() -> BasePlayer:
	return fighter_game.ClientPlayer if (self is ComboTrialMain or Global.TRAINING_P1) else fighter_game.ServerPlayer

func _get_side_character(is_p1: bool, is_assist: bool) -> int:
	var characters = Global.PLAYER_1_CHARACTER if is_p1 else Global.PLAYER_2_CHARACTER
	return characters[1 if is_assist else 0]

func _get_move_data_attackers() -> Array[BasePlayer]:
	var controlled_is_server: bool = self is ComboTrialMain or Global.TRAINING_P1
	var attackers: Array[BasePlayer] = [
		fighter_game.ServerPlayer if controlled_is_server else fighter_game.ClientPlayer,
		fighter_game.AssistPlayer1 if controlled_is_server else fighter_game.AssistPlayer2,
	]
	var puppet: PuppetPlayer = fighter_game.Hato1 if controlled_is_server else fighter_game.Hato2
	if (puppet != null):
		attackers.append(puppet)
	return attackers

func _get_move_data_opponents() -> Array[BasePlayer]:
	var controlled_is_server: bool = self is ComboTrialMain or Global.TRAINING_P1
	var opponents: Array[BasePlayer] = [
		_get_opponent_point_player(),
		fighter_game.AssistPlayer2 if controlled_is_server else fighter_game.AssistPlayer1,
	]
	var puppet: PuppetPlayer = fighter_game.Hato2 if controlled_is_server else fighter_game.Hato1
	if (puppet != null):
		opponents.append(puppet)
	return opponents

func _find_move_data_attacker(hitbox_name: String) -> BasePlayer:
	for attacker in _get_move_data_attackers():
		if (attacker.fighterState == null):
			continue
		if (attacker.currentState.get(Enums.StKey.stateName, "") != hitbox_name):
			continue
		var move_state: State = attacker.fighterState.state
		if (not move_state is AttackState and not move_state is AirAttackState):
			continue
		if (not _get_move_frame_data(move_state).is_empty()):
			return attacker
	return null

func _get_active_move_data_attacker() -> BasePlayer:
	for attacker in _get_move_data_attackers():
		if (attacker.fighterState == null):
			continue
		var move_state: State = attacker.fighterState.state
		if ((move_state is AttackState or move_state is AirAttackState)
				and not _get_move_frame_data(move_state).is_empty()):
			return attacker
	return null

func _reset_move_data_display() -> void:
	$CanvasLayer/MoveData/AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " --"
	$CanvasLayer/MoveData/ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " --"
	$CanvasLayer/MoveData/AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " --"
	$CanvasLayer/MoveData/FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " --"

func _get_move_frame_data(move_state: State) -> Dictionary:
	var animation_frames: Array = move_state.anim_data.keys()
	animation_frames.sort()
	var startup: int = -1
	var last_active_frame: int = -1
	var active_frames: int = 0

	for index in range(animation_frames.size()):
		var frame: int = int(animation_frames[index])
		if (frame > move_state.endFrame):
			break
		var frame_data: Dictionary = move_state.anim_data[frame]
		var hitbox_active: bool = (
			not frame_data.get(Enums.StKey.Hit1Disable, true)
			or not frame_data.get(Enums.StKey.Hit2Disable, true)
		)
		if (not hitbox_active):
			continue

		if (startup < 0):
			startup = maxi(frame, 0)
		var active_until: int = move_state.endFrame
		if (index + 1 < animation_frames.size()):
			active_until = mini(active_until, int(animation_frames[index + 1]) - 1)
		last_active_frame = maxi(last_active_frame, active_until)
		active_frames += maxi(active_until - maxi(frame, 0) + 1, 0)

	if (startup < 0):
		return {}
	return {
		"startup": startup,
		"active": active_frames,
		"recovery": maxi(move_state.endFrame - last_active_frame, 0),
	}

func _update_move_data() -> void:
	var player: BasePlayer = _move_data_actor if _move_data_contacted else _get_active_move_data_attacker()
	if (player == null):
		player = _move_data_actor if is_instance_valid(_move_data_actor) else _get_controlled_player()
	var advantage_player: BasePlayer = (
		_move_data_advantage_player if _move_data_contacted else _get_controlled_player()
	)

	if (player.fighterState == null):
		return
	var move_state: State = player.fighterState.state
	var state_name: String = player.currentState.get(Enums.StKey.stateName, "")
	if (advantage_player.fighterState == null):
		return
	var advantage_state_name: String = advantage_player.currentState.get(Enums.StKey.stateName, "")
	var move_data: Dictionary = {}
	if (move_state is AttackState or move_state is AirAttackState):
		move_data = _get_move_frame_data(move_state)
	var is_attack_move: bool = not move_data.is_empty()

	if (_move_data_contacted and advantage_state_name == _move_data_advantage_state_name):
		_move_data_contact_last_frame = maxi(
			_move_data_contact_last_frame,
			advantage_player.currentState.get(Enums.StKey.frame, 0)
		)
	if (_move_data_contacted and advantage_state_name != _move_data_advantage_state_name):
		var cancelled_recovery: int = 0
		var advantage_state: State = advantage_player.fighterState.state
		var was_interrupted: bool = (
			advantage_state is HurtState
			or advantage_state is AirReactionState
		)
		var is_attack_followup: bool = (
			(advantage_state is AttackState or advantage_state is AirAttackState)
			and not _get_move_frame_data(advantage_state).is_empty()
		)
		if (not was_interrupted
				and _move_data_contact_last_frame < _move_data_contact_end_frame - 1):
			cancelled_recovery = _move_data_contact_end_frame - _move_data_contact_last_frame
		_move_data_contact_advantage += cancelled_recovery
		if (not was_interrupted and is_attack_followup):
			_move_data_advantage_state_name = advantage_state_name
			_move_data_contact_end_frame = advantage_state.endFrame
			_move_data_contact_start_frame = advantage_player.currentState.get(
				Enums.StKey.frame,
				0
			)
			_move_data_contact_last_frame = advantage_player.currentState.get(
				Enums.StKey.frame,
				0
			)
			_move_data_contact_advantage -= maxi(
				advantage_state.endFrame - _move_data_contact_start_frame,
				0
			)
		else:
			_set_move_data_advantage_value(_move_data_contact_advantage)
			_move_data_contacted = false
			_move_data_advantage_player = null
	elif (not _move_data_contacted and state_name != _move_data_state_name):
		if (is_attack_move):
			_move_data_advantage_locked = false
			$CanvasLayer/MoveData/FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " --"

	if (not _move_data_contacted):
		_move_data_state_name = state_name

	if (not is_attack_move):
		if (not _move_data_advantage_locked):
			_reset_move_data_display()
		_move_data_actor = player
		return

	var startup: int = move_data["startup"]
	var active: int = move_data["active"]
	var recovery: int = move_data["recovery"]
	$CanvasLayer/MoveData/AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " " + str(startup)
	$CanvasLayer/MoveData/ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " " + str(active)
	$CanvasLayer/MoveData/AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " " + str(recovery)
	_move_data_actor = player

func _calculate_frame_advantage(
	player: BasePlayer,
	opponent: BasePlayer,
	opponent_stun: int,
	player_recovery: int
) -> int:
	var opponent_hitstop: int = maxi(opponent.currentState.get(Enums.StKey.hitStopFrame, 0), 0)
	var player_hitstop: int = maxi(player.currentState.get(Enums.StKey.hitStopFrame, 0), 0)
	return opponent_stun + opponent_hitstop - player_hitstop - player_recovery

func _set_move_data_advantage_value(advantage: int) -> void:
	_set_move_data_advantage_text(advantage)
	_move_data_advantage_locked = true

func _set_move_data_frame_values(move_data: Dictionary) -> void:
	$CanvasLayer/MoveData/AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " " + str(move_data["startup"])
	$CanvasLayer/MoveData/ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " " + str(move_data["active"])
	$CanvasLayer/MoveData/AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " " + str(move_data["recovery"])

func _set_move_data_advantage_text(advantage: int) -> void:
	var value := "%+d" % advantage
	if advantage > 0:
		value = "[color=green]%s[/color]" % value
	elif advantage < 0:
		value = "[color=red]%s[/color]" % value
	$CanvasLayer/MoveData/FrameAdvantage.text = (
		tr("UI_TRAINING_FRAME_ADVANTAGE") + " " + value
	)

func _physics_process(delta):
	if (not $CanvasLayer/TrainingOptionsMenu.is_enabled()):
		meter_refresher.tick(
		$CanvasLayer/TrainingOptionsMenu.get_super_meter(),
		$CanvasLayer/TrainingOptionsMenu.get_assist_meter(),
		$CanvasLayer/TrainingOptionsMenu.get_sync_rate())
		$CanvasLayer/DamageCounter.tick()
		if (_has_move_data_ui):
			_update_move_data()
		$CanvasLayer/TrainingInputDisplay.update_input(player_input.get_most_recent_input())
		if (is_recording):
			var train_input: int = player_input.get_training_input(record_left_face_ref)
			recording_machine.record_input(train_input)
			$CanvasLayer/MessageLabel.text = recording_machine.string_recording_frame()
		elif (is_replaying):
			if (recording_machine.has_input()):
				var input:int = recording_machine.read_input()
				if (self is ComboTrialMain):
					var replay_target: InputInterpreter = fighter_game.get_node("ServerInputInterpreter")
					replay_target.replay_input = input
					replay_target.is_replaying = true
				else:
					dummy_input.replay_input = input
					dummy_input.is_replaying = true
				$CanvasLayer/MessageLabel.text = recording_machine.string_replaying_frame()
			else:
				if (self is ComboTrialMain):
					var replay_target: InputInterpreter = fighter_game.get_node("ServerInputInterpreter")
					replay_target.is_replaying = false
					replay_target.replay_input = 0
				else:
					dummy_input.is_replaying = false
					dummy_input.replay_input = 0
				stop_replay()
		update_reaction_save_state()
		
		var new_left_face : bool
		if (dummy_input.player.team == fighter_game.ServerPlayer.team):
			new_left_face = fighter_game.point_left_face_calculation(true)
		else:
			new_left_face = fighter_game.point_left_face_calculation(false)
		dummy_input.game_left_face = new_left_face
		if (load_state_delay > 0):
			load_state_delay -= 1
			if (load_state_delay == 0):
				execute_loadstate()
	input_helper(null)

	_do_execute_frame_mechanized(SyncManager.current_tick, delta)

func _do_execute_frame_mechanized(tick, delta) -> bool:
	var p1_input_dict = {}
	var p2_input_dict = {}
	var peer_dict = {}
	var p1_input_package = {}
	var p2_input_package = {}
	var processing_reaction_state: bool = _reaction_state_active and not _input_frames_received.is_empty()
	
	if (not _input_frames_received.is_empty()):
		p1_input_package = _input_frames_received[1]
		p2_input_package = _input_frames_received[2]
		SyncManager.mechanized_rollback_ticks = p1_input_package.size()+1
		dummy_input.in_rollback = true
	p1_input_dict = get_input_vector(true)
	p2_input_dict = get_input_vector(false)
	peer_dict[game_mode_root+"/ServerInputInterpreter"] = p1_input_dict
	peer_dict[game_mode_root+"/ClientInputInterpreter"] = p2_input_dict
	
	p1_input_package[SyncManager.current_tick + SyncManager.input_delay+1] = peer_dict
	p2_input_package[SyncManager.current_tick + SyncManager.input_delay+1] = peer_dict
	_input_frames_received[1] = p1_input_package
	_input_frames_received[2] = p2_input_package
	SyncManager.mechanized_input_received = _input_frames_received
	SyncManager.execute_mechanized_tick()
	SyncManager.execute_mechanized_interpolation_frame(delta)
	
	dummy_input.in_rollback = false
	_input_frames_received = {}
	SyncManager.reset_mechanized_data()
	if (processing_reaction_state):
		_reaction_state_active = false
	return true

func get_input_vector(is_p1: bool) -> Dictionary:
	var input_interpreter : InputInterpreter = player_input
	if (is_p1 and dummy_input.name == "ServerInputInterpreter"):
		input_interpreter = dummy_input
	elif (not is_p1 and dummy_input.name == "ClientInputInterpreter"):
		input_interpreter = dummy_input
	var out = input_interpreter.read_input()
	return out

func execute_savestate():
	savestate = SyncManager._call_save_state()
	var input_source: InputSource = player_input.get_node("InputSource")
	var input_source_path: String = str(input_source.get_path())
	var input_source_state: Dictionary = savestate.get(input_source_path, {})
	if (input_source_state.is_empty()):
		return

	var button_flags = {
		"a": Enums.InputFlags.ADown | Enums.InputFlags.AHold | Enums.InputFlags.AUp,
		"b": Enums.InputFlags.BDown | Enums.InputFlags.BHold | Enums.InputFlags.BUp,
		"c": Enums.InputFlags.CDown | Enums.InputFlags.CHold | Enums.InputFlags.CUp,
		"d": Enums.InputFlags.DDown | Enums.InputFlags.DHold | Enums.InputFlags.DUp,
	}
	var active_button_flags: int = 0
	for button in button_flags:
		var button_action: String = player_input.input_prefix + button
		if (Input.is_action_pressed(button_action) or Input.is_action_just_pressed(button_action) or Input.is_action_just_released(button_action)):
			active_button_flags |= button_flags[button]
	if (active_button_flags != 0):
		var input_history: Array = input_source_state[InputSource.State.inputHistory]
		var current_index: int = input_source_state[InputSource.State.zeroIndex]
		input_history[current_index] &= ~active_button_flags

	# Uncomment while authoring a minigame savestate; leave disabled in builds.
	#save_minigame_savestate("default_corner")

func save_minigame_savestate(minigame_name: String) -> void:
	var resource_name := minigame_name.validate_filename()
	if resource_name.is_empty():
		push_error("TrainingMain: Minigame savestate name cannot be empty.")
		return

	var minigame := Minigame.new()
	minigame.display_name = minigame_name
	for node_path in savestate:
		var minigame_node_path: String = str(node_path).replace(
			"/root/TrainingMain/",
			"/root/MinigameMain/"
		)
		minigame.savestate[minigame_node_path] = savestate[node_path].duplicate(true)

	var script_path := (
		"res://game/menus/minigame/minigames/Minigame%s.gd"
		% resource_name.capitalize()
	)
	var script_contents := (
		"extends Minigame\n\n"
		+ "const SAVESTATE: Dictionary = %s\n\n"
		+ "func _init() -> void:\n"
		+ "\tdisplay_name = %s\n"
		+ "\tsavestate = SAVESTATE.duplicate(true)\n"
	) % [var_to_str(minigame.savestate), var_to_str(minigame_name)]
	var file := FileAccess.open(script_path, FileAccess.WRITE)
	if file == null:
		push_error(
			"TrainingMain: Could not open minigame savestate script '%s': %s"
			% [script_path, error_string(FileAccess.get_open_error())]
		)
		return

	file.store_string(script_contents)
	var error := file.get_error()
	file.close()
	if error != OK:
		push_error(
			"TrainingMain: Could not write minigame '%s' savestate to '%s': %s"
			% [minigame_name, script_path, error_string(error)]
		)
	
func update_reaction_save_state():
	var new_state = SyncManager._call_save_state()
	state_history.push_front(new_state)
	reaction_save_state = state_history.pop_back()
	if (reaction_save_state.is_empty()):
		reaction_save_state = savestate

func load_reaction_state():
	#SyncManager._call_load_state(reaction_save_state)
	_input_frames_received = {}
	var input_frame
	var key = 1
	var p1_input_package = {}
	var p2_input_package = {}
	for i in range(state_history.size()):
		var tick = SyncManager.current_tick + -i + SyncManager.input_delay
		input_frame = SyncManager.get_input_frame(tick)
		if (not input_frame.players.is_empty()):
			key = input_frame.players.keys()[0]
			var p1_input_dict = {}
			var p2_input_dict = {}
			var peer_dict = {}
			if (dummy_input.name == "ServerInputInterpreter"):
				peer_dict[game_mode_root+"/ClientInputInterpreter"] = input_frame.players[key].input[game_mode_root+"/ClientInputInterpreter"].duplicate(true)
				peer_dict[game_mode_root+"/ServerInputInterpreter"] = dummy_input.hurt_response_override(i-SyncManager.input_delay-2)
			else:
				peer_dict[game_mode_root+"/ServerInputInterpreter"] = input_frame.players[key].input[game_mode_root+"/ServerInputInterpreter"].duplicate(true)
				peer_dict[game_mode_root+"/ClientInputInterpreter"] = dummy_input.hurt_response_override(i-SyncManager.input_delay-2)
			p1_input_package[tick] = peer_dict
			p2_input_package[tick] = peer_dict
			_input_frames_received[1] = p1_input_package
			_input_frames_received[2] = p2_input_package
	if (p1_input_package.is_empty()):
		return
	_reaction_state_active = true
	store_rollback_state.call_deferred(_input_frames_received, state_history.size())

func store_rollback_state(p_input_frames_received, rollback_ticks):
	_input_frames_received = p_input_frames_received.duplicate(true)
	SyncManager.mechanized_rollback_ticks = rollback_ticks
	
func loadstate():
	load_state_delay = SyncManager.input_delay
	dummy_input.clear_input()

func loadstate_menu():
	loadstate()
	#fighter_game.un_freeze_game_sim()

func execute_loadstate():
	if (not savestate.is_empty()):
		SyncManager._call_load_state(savestate)
		dummy_input.clear_input()
		SyncManager.clear_all_sounds()
		$CanvasLayer/LoadedStateLabel.show_text()
	else:
		self.execute_savestate()
		self.loadstate()
	fighter_game.un_freeze_game_sim()

func exit():
	get_tree().change_scene_to_file("res://game/menus/characterselect/TrainingCharacterSelect.tscn")
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()

func reset(position: int = TrainingResetPosition.CENTER):
	if (_reaction_state_active):
		return
	last_reset_position = position
	sync_clear()
	$CanvasLayer/TrainingOptionsMenu.hide()
	fighter_game.stop_glowing_characters()
	reload_scene(position)
	#get_tree().reload_current_scene()

func _get_back_reset_position(input_prefix: String) -> int:
	var left_pressed: bool = Input.get_action_strength(input_prefix + "left") > 0 or Input.get_action_strength(input_prefix + "left_stick") > 0
	var right_pressed: bool = Input.get_action_strength(input_prefix + "right") > 0 or Input.get_action_strength(input_prefix + "right_stick") > 0
	var up_pressed: bool = Input.get_action_strength(input_prefix + "up") > 0 or Input.get_action_strength(input_prefix + "up_stick") > 0
	var down_pressed: bool = Input.get_action_strength(input_prefix + "down") > 0 or Input.get_action_strength(input_prefix + "down_stick") > 0

	if (left_pressed):
		return TrainingResetPosition.LEFT_SWITCHED if down_pressed else TrainingResetPosition.LEFT
	if (right_pressed):
		return TrainingResetPosition.RIGHT_SWITCHED if down_pressed else TrainingResetPosition.RIGHT
	if (up_pressed):
		return TrainingResetPosition.CENTER
	if (down_pressed):
		return TrainingResetPosition.CENTER_SWITCHED
	return -1

func reload_scene(position: int = TrainingResetPosition.CENTER):
	var music_stream = MainMenuMusicControl.audio_player.stream if MainMenuMusicControl != null else null
	var music_position = MainMenuMusicControl.audio_player.get_playback_position() if MainMenuMusicControl != null else 0.0
	var music_is_playing = MainMenuMusicControl.audio_player.playing if MainMenuMusicControl != null else false
	var sfx_stream = MainMenuMusicControl.menu_sounds.stream if MainMenuMusicControl != null else null
	var sfx_position = MainMenuMusicControl.menu_sounds.get_playback_position() if MainMenuMusicControl != null else 0.0
	var sfx_is_playing = MainMenuMusicControl.menu_sounds.playing if MainMenuMusicControl != null else false

	if (MainMenuMusicControl != null):
		MainMenuMusicControl.skip_next_fade_in()
	super.reload_scene()
	_apply_training_reset_position(position)
	setup_training()
	skip_training_intro()
	stop_record()
	stop_replay()

	if (MainMenuMusicControl != null):
		if (music_stream != null and music_is_playing):
			MainMenuMusicControl.audio_player.stream = music_stream
			MainMenuMusicControl.audio_player.play(music_position)
		if (sfx_stream != null and sfx_is_playing):
			MainMenuMusicControl.menu_sounds.stream = sfx_stream
			MainMenuMusicControl.menu_sounds.play(sfx_position)

func _apply_training_reset_position(position: int) -> void:
	var server_x: int
	var client_x: int
	var server_scale_x: int = SGFixed.ONE
	var client_scale_x: int = -SGFixed.ONE

	match position:
		TrainingResetPosition.CENTER:
			server_x = -23292288
			client_x = 23292288
		TrainingResetPosition.CENTER_SWITCHED:
			server_x = 23292288
			client_x = -23292288
		TrainingResetPosition.LEFT:
			server_x = -175570000
			client_x = -145570000
		TrainingResetPosition.LEFT_SWITCHED:
			server_x = -145570000
			client_x = -175570000
		TrainingResetPosition.RIGHT:
			server_x = 145570000
			client_x = 175570000
		TrainingResetPosition.RIGHT_SWITCHED:
			server_x = 175570000
			client_x = 145570000
		_:
			server_x = -23292288
			client_x = 23292288

	fighter_game.ServerPlayer.fixed_position.x = server_x
	fighter_game.ServerPlayer.fixed_position.y = 29949952
	fighter_game.ServerPlayer.fixed_scale.x = server_scale_x
	fighter_game.ServerPlayer.sync_to_physics_engine()

	fighter_game.ClientPlayer.fixed_position.x = client_x
	fighter_game.ClientPlayer.fixed_position.y = 29949952
	fighter_game.ClientPlayer.fixed_scale.x = client_scale_x
	fighter_game.ClientPlayer.sync_to_physics_engine()
	
	if (fighter_game.AssistPlayer1 != null):
		fighter_game.AssistPlayer1.fixed_position.x = server_x - 16946816
		fighter_game.AssistPlayer1.fixed_position.y = Util.ASSIST_WARP_POSITION_Y
		fighter_game.AssistPlayer1.fixed_scale.x = server_scale_x
		fighter_game.AssistPlayer1.sync_to_physics_engine()
	if (fighter_game.AssistPlayer2 != null):
		fighter_game.AssistPlayer2.fixed_position.x = client_x + 16946816
		fighter_game.AssistPlayer2.fixed_position.y = Util.ASSIST_WARP_POSITION_Y
		fighter_game.AssistPlayer2.fixed_scale.x = client_scale_x
		fighter_game.AssistPlayer2.sync_to_physics_engine()
	
	if (fighter_game.Hato1 != null):
		fighter_game.Hato1.fixed_position.x = server_x - 8000000
		fighter_game.Hato1.fixed_position.y = Util.ASSIST_WARP_POSITION_Y
		fighter_game.Hato1.fixed_scale.x = server_scale_x
		fighter_game.Hato1.sync_to_physics_engine()
	if (fighter_game.Hato2 != null):
		fighter_game.Hato2.fixed_position.x = client_x + 8000000
		fighter_game.Hato2.fixed_position.y = Util.ASSIST_WARP_POSITION_Y
		fighter_game.Hato2.fixed_scale.x = client_scale_x
		fighter_game.Hato2.sync_to_physics_engine()

	var camera: Camera2D = fighter_game.get_node("Camera3D")
	var server_position: Vector2 = fighter_game.ServerPlayer.global_position
	var client_position: Vector2 = fighter_game.ClientPlayer.global_position
	var camera_target_x: float = (server_position.x + client_position.x) * 0.5
	var camera_target_y: float = server_position.y + camera.yCameraOffset1
	if (client_position.y + camera.yCameraOffset2 < camera_target_y):
		camera_target_y = client_position.y + camera.yCameraOffset2
	camera.position = camera.camera_clamp(camera_target_x, camera_target_y)

func control_the_dummy():
	if (not dummy_input.player == null):
		dummy_input.disconnect_signals()
	if (self is ComboTrialMain):
		player_input = fighter_game.get_node("ServerInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = player_input
		fighter_game.ClientPlayer.input_interpreter = dummy_input
		fighter_game.AssistPlayer1.input_interpreter = player_input
		fighter_game.AssistPlayer2.input_interpreter = dummy_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = player_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = dummy_input
		dummy_input.player = fighter_game.ClientPlayer
		record_left_face_ref = fighter_game.ServerPlayer.currentState[Enums.StKey.leftface]
	elif (Global.TRAINING_P1):
		player_input = fighter_game.get_node("ServerInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = dummy_input
		fighter_game.ClientPlayer.input_interpreter = player_input
		fighter_game.AssistPlayer1.input_interpreter = dummy_input
		fighter_game.AssistPlayer2.input_interpreter = player_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = dummy_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = player_input
		dummy_input.player = fighter_game.ServerPlayer
		record_left_face_ref = fighter_game.ClientPlayer.currentState[Enums.StKey.leftface]
	else:
		player_input = fighter_game.get_node("ClientInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = player_input
		fighter_game.ClientPlayer.input_interpreter = dummy_input
		fighter_game.AssistPlayer1.input_interpreter = player_input
		fighter_game.AssistPlayer2.input_interpreter = dummy_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = player_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = dummy_input
		dummy_input.player = fighter_game.ClientPlayer
		record_left_face_ref = fighter_game.ServerPlayer.currentState[Enums.StKey.leftface]
	dummy_input.connect_signals()

func return_control_to_player():
	if (not dummy_input.player == null):
		dummy_input.disconnect_signals()
	if (self is ComboTrialMain):
		player_input = fighter_game.get_node("ServerInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = player_input
		fighter_game.ClientPlayer.input_interpreter = dummy_input
		fighter_game.AssistPlayer1.input_interpreter = player_input
		fighter_game.AssistPlayer2.input_interpreter = dummy_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = player_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = dummy_input
		dummy_input.player = fighter_game.ClientPlayer
	elif (Global.TRAINING_P1):
		player_input = fighter_game.get_node("ServerInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = player_input
		fighter_game.ClientPlayer.input_interpreter = dummy_input
		fighter_game.AssistPlayer1.input_interpreter = player_input
		fighter_game.AssistPlayer2.input_interpreter = dummy_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = player_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = dummy_input
		dummy_input.player = fighter_game.ClientPlayer
	else:
		player_input = fighter_game.get_node("ClientInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = dummy_input
		fighter_game.ClientPlayer.input_interpreter = player_input
		fighter_game.AssistPlayer1.input_interpreter = dummy_input
		fighter_game.AssistPlayer2.input_interpreter = player_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = dummy_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = player_input
		dummy_input.player = fighter_game.ServerPlayer
	dummy_input.connect_signals()

func setup_training():
	if (Global.TRAINING_P1):
		fighter_game.get_node("ClientInputInterpreter").set_script(DummyInputInterpreter)
		dummy_input = fighter_game.get_node("ClientInputInterpreter")
		dummy_input.input_prefix = "player2_"
		$CanvasLayer/DamageCounter.hp_bar = fighter_game.get_node("Camera3D/BattleUI/ClientHPBar")
	else:
		fighter_game.get_node("ServerInputInterpreter").set_script(DummyInputInterpreter)
		dummy_input = fighter_game.get_node("ServerInputInterpreter")
		dummy_input.input_prefix = "player1_"
		$CanvasLayer/DamageCounter.hp_bar = fighter_game.get_node("Camera3D/BattleUI/ServerHPBar")
	return_control_to_player()
	call_deferred("skip_training_intro")

func skip_training_intro():
	fighter_game.get_node("Camera3D/BattleUI/NowLoadingText").skip()
	fighter_game.ServerPlayer.skip_intro()
	fighter_game.ClientPlayer.skip_intro()
	fighter_game.AssistPlayer1.skip_intro()
	fighter_game.AssistPlayer2.skip_intro()
	fighter_game.intro_shutters_set_visible(false)
	meter_refresher.refresh_meter(
		$CanvasLayer/TrainingOptionsMenu.get_super_meter(),
		$CanvasLayer/TrainingOptionsMenu.get_assist_meter(),
		$CanvasLayer/TrainingOptionsMenu.get_sync_rate())
	var assist_build = $CanvasLayer/TrainingOptionsMenu.get_assist_build_option()
	var meter_reset_option = $CanvasLayer/TrainingOptionsMenu.get_meter_reset_option()
	fighter_game.ServerPlayer.assist_meter_build_frozen = not assist_build
	fighter_game.ClientPlayer.assist_meter_build_frozen = not assist_build
	meter_refresher.assist_build = assist_build
	meter_refresher.meter_reset_option = meter_reset_option

func _on_SyncManager_sync_started() -> void:
	super._on_SyncManager_sync_started()
	Global.server_input_interpreter.get_node("InputSource").countdown = 0
	Global.client_input_interpreter.get_node("InputSource").countdown = 0

func toggle_training_menu():
	fighter_game.permaFreeze()
	$CanvasLayer/TrainingOptionsMenu.open_training_options_menu()
	if ($CanvasLayer/TrainingOptionsMenu.visible == false):
		$CanvasLayer/TrainingInputDisplay.visible = true
	else:
		$CanvasLayer/TrainingInputDisplay.visible = false

func set_new_training_options():
	fighter_game.un_freeze_game_sim()
	_apply_training_character_settings()

	var stance = $CanvasLayer/TrainingOptionsMenu.get_stance()
	var blocking = $CanvasLayer/TrainingOptionsMenu.get_blocking()
	var block_switch = $CanvasLayer/TrainingOptionsMenu.get_block_switch()
	var block_type = $CanvasLayer/TrainingOptionsMenu.get_block_type()
	var air_recovery = $CanvasLayer/TrainingOptionsMenu.get_air_recovery()
	var counter_hit = $CanvasLayer/TrainingOptionsMenu.get_counter_hit()
	var assist_build = $CanvasLayer/TrainingOptionsMenu.get_assist_build_option()
	var meter_reset_option = $CanvasLayer/TrainingOptionsMenu.get_meter_reset_option()
	
	dummy_input.stance = stance
	dummy_input.blocking = blocking
	dummy_input.block_switch = block_switch
	dummy_input.block_type = block_type
	dummy_input.air_recovery = air_recovery
	dummy_input.counter_hit = counter_hit
	
	fighter_game.ServerPlayer.assist_meter_build_frozen = not assist_build
	fighter_game.ClientPlayer.assist_meter_build_frozen = not assist_build
	
	meter_refresher.assist_build = assist_build
	meter_refresher.meter_reset_option = meter_reset_option

func _apply_training_character_settings() -> void:
	var controlled_is_p1: bool = self is ComboTrialMain or Global.TRAINING_P1
	var options = $CanvasLayer/TrainingOptionsMenu
	_apply_character_setting(
		controlled_is_p1,
		false,
		options.get_training_character(controlled_is_p1, false)
	)
	_apply_character_setting(
		controlled_is_p1,
		true,
		options.get_training_character(controlled_is_p1, true)
	)
	_apply_character_setting(
		not controlled_is_p1,
		false,
		options.get_training_character(not controlled_is_p1, false)
	)
	_apply_character_setting(
		not controlled_is_p1,
		true,
		options.get_training_character(not controlled_is_p1, true)
	)

func _apply_character_setting(
	is_p1: bool,
	is_assist: bool,
	new_character: int
) -> void:
	var old_character: int = _get_side_character(is_p1, is_assist)
	if new_character == old_character:
		return

	var character_data := (
		_get_assist_character_data(new_character)
		if is_assist
		else _get_point_character_data(new_character)
	)
	if character_data.is_empty():
		push_error("TrainingMain: Unsupported character selection %s." % new_character)
		$CanvasLayer/TrainingOptionsMenu.set_training_character(
			is_p1,
			is_assist,
			old_character
		)
		return

	var colors = Global.PLAYER_1_COLOR if is_p1 else Global.PLAYER_2_COLOR
	var current_color_path: String = colors[1 if is_assist else 0]
	var current_palette_number: int = current_color_path.get_file().get_basename().to_int()
	var old_palette_directory: String = (
		_get_assist_palette_directory(old_character)
		if is_assist
		else _get_point_palette_directory(old_character)
	)
	var new_palette_directory: String = character_data["palette_directory"]
	var palette_number: int = _choose_character_palette(
		current_palette_number,
		old_palette_directory,
		new_palette_directory
	)
	if palette_number == 0:
		push_error(
			"TrainingMain: No color palettes found for character %s."
			% new_character
		)
		$CanvasLayer/TrainingOptionsMenu.set_training_character(
			is_p1,
			is_assist,
			old_character
		)
		return

	var character_scene: PackedScene = load(character_data["scene_path"]) as PackedScene
	if character_scene == null:
		push_error(
			"TrainingMain: Could not load character scene '%s'."
			% character_data["scene_path"]
		)
		$CanvasLayer/TrainingOptionsMenu.set_training_character(
			is_p1,
			is_assist,
			old_character
		)
		return

	colors[1 if is_assist else 0] = (
		new_palette_directory + str(palette_number) + ".png"
	)
	Global.load_new_color(is_p1, is_assist)

	if is_assist:
		fighter_game.set_assist_character(is_p1, new_character, character_scene)
	else:
		if dummy_input.player != null:
			dummy_input.disconnect_signals()
			dummy_input.player = null
		fighter_game.set_point_character(is_p1, new_character, character_scene)
		return_control_to_player()

	if _has_move_data_ui:
		_refresh_move_data_signals(is_p1)

func _refresh_move_data_signals(changed_side_is_p1: bool) -> void:
	var controlled_is_p1: bool = self is ComboTrialMain or Global.TRAINING_P1
	var is_controlled_side: bool = changed_side_is_p1 == controlled_is_p1
	var point_player: PointPlayer = (
		fighter_game.ServerPlayer if changed_side_is_p1 else fighter_game.ClientPlayer
	)
	var assist_player: AssistPlayer = (
		fighter_game.AssistPlayer1 if changed_side_is_p1 else fighter_game.AssistPlayer2
	)
	if is_controlled_side:
		point_player.projectilespawn.connect(
			Callable(self, "_on_move_data_projectile_spawned").bind(point_player)
		)
		assist_player.projectilespawn.connect(
			Callable(self, "_on_move_data_projectile_spawned").bind(assist_player)
		)
	else:
		point_player.attack_hurt_resolved.connect(
			Callable(self, "_on_training_opponent_attack_hurt").bind(point_player)
		)
		assist_player.attack_hurt_resolved.connect(
			Callable(self, "_on_training_opponent_attack_hurt").bind(assist_player)
		)

func _choose_character_palette(
	current_palette_number: int,
	old_palette_directory: String,
	new_palette_directory: String
) -> int:
	if (
		current_palette_number > 0
		and ResourceLoader.exists(
			old_palette_directory + str(current_palette_number) + ".png"
		)
		and ResourceLoader.exists(
			new_palette_directory + str(current_palette_number) + ".png"
		)
	):
		return current_palette_number

	for candidate in range(1, Util.MAX_COLOR_PALETTE_NUMBER + 1):
		if ResourceLoader.exists(new_palette_directory + str(candidate) + ".png"):
			return candidate
	return 0

func _get_point_character_data(character: int) -> Dictionary:
	match character:
		Enums.PointCharacters.Subaru:
			return {
				"scene_path": "res://game/fighter/SubaruPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/subaru/ColorPalettes/",
			}
		Enums.PointCharacters.Mio:
			return {
				"scene_path": "res://game/fighter/MioPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/mio/ColorPalettes/",
			}
		Enums.PointCharacters.Oga:
			return {
				"scene_path": "res://game/fighter/OgaPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/oga/ColorPalettes/",
			}
		Enums.PointCharacters.Ollie:
			return {
				"scene_path": "res://game/fighter/OlliePlayer.tscn",
				"palette_directory": "res://game/assets/sprites/ollie/ColorPalettes/",
			}
		Enums.PointCharacters.Suisei:
			return {
				"scene_path": "res://game/fighter/SuiseiPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/suisei/ColorPalettes/",
			}
		Enums.PointCharacters.Kanata:
			return {
				"scene_path": "res://game/fighter/KanataPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/kanata/ColorPalettes/",
			}
		Enums.PointCharacters.Flayon:
			return {
				"scene_path": "res://game/fighter/FlayonPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/flayon/ColorPalettes/",
			}
	return {}

func _get_point_palette_directory(character: int) -> String:
	var character_data := _get_point_character_data(character)
	return character_data.get("palette_directory", "")

func _get_assist_character_data(assist: int) -> Dictionary:
	match assist:
		Enums.AssistCharacters.Fubuki:
			return {
				"scene_path": "res://game/fighter/assist/fubuki/FubukiPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/assists/fubuki/ColorPalettes/",
			}
		Enums.AssistCharacters.Sora:
			return {
				"scene_path": "res://game/fighter/assist/sora/SoraPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/assists/sora/ColorPalettes/",
			}
		Enums.AssistCharacters.Sana:
			return {
				"scene_path": "res://game/fighter/assist/assistsana/SanaPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/assists/sana/ColorPalettes/",
			}
		Enums.AssistCharacters.OkaKoro:
			return {
				"scene_path": "res://game/fighter/assist/okakoro/OkaKoroPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/assists/okakoro/ColorPalettes/",
			}
		Enums.AssistCharacters.Hakka:
			return {
				"scene_path": "res://game/fighter/assist/hakka/HakkaPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/assists/hakka/ColorPalettes/",
			}
		Enums.AssistCharacters.Rikka:
			return {
				"scene_path": "res://game/fighter/assist/rikka/RikkaPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/assists/rikka/ColorPalettes/",
			}
		Enums.AssistCharacters.Subaru:
			return {
				"scene_path": "res://game/fighter/assist/assistsubaru/AssistSubaruPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/subaru/ColorPalettes/",
			}
		Enums.AssistCharacters.Mio:
			return {
				"scene_path": "res://game/fighter/assist/assistmio/AssistMioPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/mio/ColorPalettes/",
			}
		Enums.AssistCharacters.Oga:
			return {
				"scene_path": "res://game/fighter/assist/assistoga/AssistOgaPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/oga/ColorPalettes/",
			}
		Enums.AssistCharacters.Ollie:
			return {
				"scene_path": "res://game/fighter/assist/assistollie/AssistOlliePlayer.tscn",
				"palette_directory": "res://game/assets/sprites/ollie/ColorPalettes/",
			}
		Enums.AssistCharacters.Suisei:
			return {
				"scene_path": "res://game/fighter/assist/assistsuisei/AssistSuiseiPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/suisei/ColorPalettes/",
			}
		Enums.AssistCharacters.Kanata:
			return {
				"scene_path": "res://game/fighter/assist/assistkanata/AssistKanataPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/kanata/ColorPalettes/",
			}
		Enums.AssistCharacters.Flayon:
			return {
				"scene_path": "res://game/fighter/assist/flayon/AssistFlayonPlayer.tscn",
				"palette_directory": "res://game/assets/sprites/flayon/ColorPalettes/",
			}
	return {}

func _get_assist_palette_directory(assist: int) -> String:
	var assist_data := _get_assist_character_data(assist)
	return assist_data.get("palette_directory", "")

### RECORDING 

enum RecordingStates {
	Idle,
	PreRecord,
	Recording,
	Replaying
}

var recording_state: int = RecordingStates.Idle

func recording_fsm_record_input():
	if (recording_state == RecordingStates.Idle):
		start_pre_record()
	elif (recording_state == RecordingStates.PreRecord):
		start_record()
	elif (recording_state == RecordingStates.Recording):
		save_record()
	elif (recording_state == RecordingStates.Replaying):
		start_pre_record()

func recording_fsm_replay_input():
	if (recording_state == RecordingStates.Idle):
		start_replay()
	elif (recording_state == RecordingStates.PreRecord):
		stop_replay()
	elif (recording_state == RecordingStates.Recording):
		stop_record()
	elif (recording_state == RecordingStates.Replaying):
		stop_replay()

func start_pre_record():
	recording_state = RecordingStates.PreRecord
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_RECORDING_READY")
	control_the_dummy()
	is_recording = false
	recording_machine.switch_section(0)
	is_replaying = false

func prepare_for_demo_playback() -> void:
	pass

func get_demo_file_path() -> String:
	var combo_index = $CanvasLayer/ComboTrialListener.current_combo_index
	var character_enum = Global.PLAYER_2_CHARACTER[0]
	var is_assist_combo = false
	if Global.ASSIST_COMBO_TRIAL:
		is_assist_combo = true
		character_enum = Global.PLAYER_2_CHARACTER[1]
		if Global.TRAINING_P1:
			character_enum = Global.PLAYER_1_CHARACTER[1]
	else:
		if Global.TRAINING_P1:
			character_enum = Global.PLAYER_1_CHARACTER[0]
	var file_name = recording_machine.get_combo_trial_file_name(combo_index, character_enum, is_assist_combo)
	print("looking for " + file_name)
	var packaged_candidate = "res://game/ui/combotrialdemos/%s" % file_name
	return packaged_candidate
	return "user://training_recording.dat"

func play_demo():
	var demo_file_path = "user://training_recording.dat"
	if (self is ComboTrialMain):
		demo_file_path = get_demo_file_path()
	if recording_machine.load_recording_from_file(demo_file_path):
		recording_machine.switch_section(recording_machine.section)
		recording_machine.index = 0
		if (self is ComboTrialMain):
			prepare_for_demo_playback()
		$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PLAYING_DEMO")
		print(demo_file_path)
		start_replay()
	else:
		$CanvasLayer/MessageLabel.text = tr("UI_STATUS_NO_RECORDING")

func start_record():
	recording_state = RecordingStates.Recording
	$CanvasLayer/MessageLabel.text = recording_machine.string_recording_frame()
	is_recording = true
	control_the_dummy()

func save_record():
	recording_state = RecordingStates.Idle
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_RECORDING_SAVED")
	is_recording = false
	if (self is ComboTrialMain):
		var character_enum = Global.PLAYER_2_CHARACTER[0]
		var is_assist_combo = false
		if Global.ASSIST_COMBO_TRIAL:
			is_assist_combo = true
			character_enum = Global.PLAYER_2_CHARACTER[1]
			if Global.TRAINING_P1:
				character_enum = Global.PLAYER_1_CHARACTER[1]
		else:
			if Global.TRAINING_P1:
				character_enum = Global.PLAYER_1_CHARACTER[0]
		recording_machine.save_recording_to_combo_trial($CanvasLayer/ComboTrialListener.current_combo_index, character_enum, is_assist_combo)
	else:
		recording_machine.save_recording()
	return_control_to_player()

func stop_record():
	recording_state = RecordingStates.Idle
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_RECORDING_CANCELLED")
	is_recording = false
	recording_machine.cancel_recording()
	return_control_to_player()

func start_replay():
	recording_state = RecordingStates.Replaying
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_REPLAYING")
	if (self is ComboTrialMain):
		replay_restore_player_input = player_input
		player_input = fighter_game.get_node("ServerInputInterpreter")
		player_input.prep_for_replay()
		$CanvasLayer/ComboTrialListener.set_auto_advance_on_complete(false)
		$CanvasLayer/ComboTrialListener.set_hold_completion_for_demo(true)
	else:
		replay_restore_player_input = null
		dummy_input.prep_for_replay()
	return_control_to_player()
	if (self is ComboTrialMain):
		player_input = fighter_game.get_node("ServerInputInterpreter")
	is_replaying = true

func stop_replay():
	recording_state = RecordingStates.Idle
	$CanvasLayer/MessageLabel.text = ""
	if (self is ComboTrialMain):
		var replay_target: InputInterpreter = fighter_game.get_node("ServerInputInterpreter")
		replay_target.is_replaying = false
		replay_target.replay_input = 0
		$CanvasLayer/ComboTrialListener.set_auto_advance_on_complete(true)
	else:
		dummy_input.is_replaying = false
		dummy_input.replay_input = 0
	return_control_to_player()
	if (self is ComboTrialMain and replay_restore_player_input != null):
		player_input = replay_restore_player_input
	recording_machine.cancel_replay()
	is_replaying = false
	replay_restore_player_input = null

func _input(event):
	pass

func input_helper(event):
	if (Global.TRAINING_P1 and Input.is_action_just_pressed("player1_start")) or (not Global.TRAINING_P1 and Input.is_action_just_pressed("player2_start")):
		if (not $CanvasLayer/TrainingOptionsMenu.is_enabled()):
			toggle_training_menu()
	elif (Global.TRAINING_P1 and Input.is_action_just_pressed("player1_cancel")) or (not Global.TRAINING_P1 and Input.is_action_just_pressed("player2_cancel")):
		if (not $CanvasLayer/TrainingOptionsMenu.is_enabled()):
			var input_prefix: String = "player1_" if Global.TRAINING_P1 else "player2_"
			var reset_position: int = _get_back_reset_position(input_prefix)
			if (reset_position >= 0):
				reset(reset_position)
			elif (self is ComboTrialMain):
				reset(TrainingResetPosition.get($CanvasLayer/ComboTrialListener.current_reset_position, TrainingResetPosition.CENTER))
			elif (savestate.is_empty()):
				reset(last_reset_position)
			else:
				loadstate()
	elif (Global.TRAINING_P1 and Input.is_action_just_pressed("player1_record")) or (not Global.TRAINING_P1 and Input.is_action_just_pressed("player2_record")):
		if (not $CanvasLayer/TrainingOptionsMenu.is_enabled()):
			if not (self is ComboTrialMain): #WARN DEBUG FUNCTION FOR RECORDING COMBO TRIALS ENABLE ME BEFORE BUILDING
				recording_fsm_record_input()
	elif (Global.TRAINING_P1 and Input.is_action_just_pressed("player1_replay")) or (not Global.TRAINING_P1 and Input.is_action_just_pressed("player2_replay")):
		if (not $CanvasLayer/TrainingOptionsMenu.is_enabled()):
			if (self is ComboTrialMain):
				if (recording_state == RecordingStates.Replaying):
					stop_replay()
				else:
					play_demo()
			else:
				recording_fsm_replay_input()
