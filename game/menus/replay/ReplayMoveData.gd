extends Node2D

class_name ReplayMoveData

@export var player_one := true

var fighter_game: FighterGame
var _pending_move_data_contacts: Array[Dictionary] = []
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

func _ready() -> void:
	$PlayerLabel.text = "UI_REPLAY_PLAYER_ONE" if player_one else "UI_REPLAY_PLAYER_TWO"

func setup(game: FighterGame) -> void:
	fighter_game = game
	for entity in _get_replay_team(not player_one):
		if is_instance_valid(entity):
			entity.attack_hurt_resolved.connect(
				_on_training_opponent_attack_hurt.bind(entity)
			)
	for entity in _get_replay_team(player_one):
		if is_instance_valid(entity):
			entity.projectilespawn.connect(_on_move_data_projectile_spawned.bind(entity))

func _get_replay_team(is_p1: bool) -> Array[BasePlayer]:
	var team: Array[BasePlayer] = [
		fighter_game.ServerPlayer if is_p1 else fighter_game.ClientPlayer,
		fighter_game.AssistPlayer1 if is_p1 else fighter_game.AssistPlayer2,
	]
	var puppet: PuppetPlayer = fighter_game.Hato1 if is_p1 else fighter_game.Hato2
	if is_instance_valid(puppet):
		team.append(puppet)
	return team

func capture_frame() -> void:
	for contact in _pending_move_data_contacts:
		_record_move_data_contact(
			contact["player"], contact["state_name"], contact["events"],
			contact["is_projectile"], contact["was_parried"]
		)
	_pending_move_data_contacts.clear()
	_update_move_data()

func reset_tracking() -> void:
	_pending_move_data_contacts.clear()
	_reset_move_data_tracking()

func _on_training_opponent_attack_hurt(
	hitbox_name: String,
	hit_type: int,
	_opponent: BasePlayer
) -> void:
	var was_parried: bool = hit_type == Enums.HitType.Parry
	var player: BasePlayer = _find_move_data_attacker(hitbox_name)
	if player == null:
		var projectile_source: Dictionary = _move_data_projectile_sources.get(
			_normalize_projectile_name(hitbox_name), {}
		)
		if projectile_source.is_empty():
			return
		player = projectile_source["actor"]
		if not is_instance_valid(player):
			return
		_queue_move_data_contact(player, projectile_source["move_frame_events"], true, was_parried)
		return
	_queue_move_data_contact(player, [], false, was_parried)

func _on_move_data_projectile_spawned(
	_x: int,
	_y: int,
	_scene: PackedScene,
	node_name: String,
	_player_data: PlayerSetup,
	attacker: BasePlayer
) -> void:
	if attacker.fighterState == null:
		return
	var move_state: State = attacker.fighterState.state
	if move_state == null:
		return
	_move_data_projectile_sources[_normalize_projectile_name(node_name)] = {
		"actor": attacker,
		"move_frame_events": _get_move_frame_events(move_state),
	}

func _normalize_projectile_name(projectile_name: String) -> String:
	return projectile_name.rstrip("0123456789")

func _queue_move_data_contact(
	player: BasePlayer,
	move_frame_events_snapshot: Array[FrameEvent] = [],
	is_projectile: bool = false,
	was_parried: bool = false
) -> void:
	if player.fighterState == null:
		return
	var move_state: State = player.fighterState.state
	var move_frame_events: Array[FrameEvent] = move_frame_events_snapshot
	if move_frame_events.is_empty():
		if move_state == null or (
			not is_projectile and not move_state is AttackState and not move_state is AirAttackState
		):
			return
		move_frame_events = _get_move_frame_events(move_state)
	if move_frame_events.is_empty() and not is_projectile:
		return
	_dispatch_move_data_contact(
		player, player.currentState.get(Enums.StKey.stateName, ""),
		move_frame_events, is_projectile, was_parried
	)

func _dispatch_move_data_contact(
	player: BasePlayer, state_name: String, events: Array[FrameEvent],
	is_projectile: bool, was_parried: bool
) -> void:
	_pending_move_data_contacts.append({
		"player": player,
		"state_name": state_name,
		"events": events,
		"is_projectile": is_projectile,
		"was_parried": was_parried,
	})

func _record_move_data_contact(
	player: BasePlayer,
	move_state_name: String,
	move_frame_events_snapshot: Array[FrameEvent],
	is_projectile: bool,
	was_parried: bool
) -> void:
	if not is_instance_valid(player) or player.fighterState == null:
		return
	var base_player: BasePlayer = _get_controlled_player()
	var opponent: BasePlayer = _get_opponent_point_player()
	if not is_instance_valid(base_player) or base_player.fighterState == null \
			or base_player.fighterState.state == null or not is_instance_valid(opponent):
		return
	if move_frame_events_snapshot.is_empty():
		var move_state: State = player.fighterState.state
		if move_state == null or (
			not is_projectile and not move_state is AttackState and not move_state is AirAttackState
		):
			return
		move_frame_events_snapshot = _get_move_frame_events(move_state)
		if move_frame_events_snapshot.is_empty() and not is_projectile:
			return
	var opponent_stun: int = 0 if was_parried else opponent.currentState.get(Enums.StKey.hitstun, 0)
	if opponent_stun <= 0 and not was_parried:
		return
	var opponent_next_state: String = opponent.currentState.get(Enums.StKey.next_state, "")
	if opponent.currentState.get(Enums.StKey.transition_state_flag, false) \
			and opponent_next_state.ends_with("HurtCrouch"):
		opponent_stun += 1
	var base_move_state: State = base_player.fighterState.state
	var player_recovery: int = maxi(
		base_move_state.endFrame - base_player.currentState.get(Enums.StKey.frame, 0), 0
	)
	_move_data_contact_advantage = _calculate_frame_advantage(
		base_player, opponent, opponent_stun, player_recovery
	)
	_move_data_contact_end_frame = base_move_state.endFrame
	_move_data_contact_last_frame = base_player.currentState.get(Enums.StKey.frame, 0)
	_move_data_actor = player
	_move_data_advantage_player = base_player
	_move_data_advantage_state_name = base_player.currentState.get(Enums.StKey.stateName, "")
	_move_data_state_name = move_state_name
	_move_data_advantage_locked = true
	_move_data_contacted = true
	if not move_frame_events_snapshot.is_empty():
		_set_move_data_frame_values(move_frame_events_snapshot)
	else:
		$AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " --"
		$ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " --"
		$AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " --"
	$FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " --"

func _get_controlled_player() -> BasePlayer:
	return fighter_game.ServerPlayer if _move_data_is_server() else fighter_game.ClientPlayer

func _get_opponent_point_player() -> BasePlayer:
	return fighter_game.ClientPlayer if _move_data_is_server() else fighter_game.ServerPlayer

func _move_data_is_server() -> bool:
	return player_one

func _get_move_data_attackers() -> Array[BasePlayer]:
	return _get_replay_team(player_one)

func _find_move_data_attacker(hitbox_name: String) -> BasePlayer:
	for attacker in _get_move_data_attackers():
		if not is_instance_valid(attacker) or attacker.fighterState == null:
			continue
		if attacker.currentState.get(Enums.StKey.stateName, "") != hitbox_name:
			continue
		var move_state: State = attacker.fighterState.state
		if not move_state is AttackState and not move_state is AirAttackState:
			continue
		if not _get_move_frame_events(move_state).is_empty():
			return attacker
	return null

func _get_active_move_data_attacker() -> BasePlayer:
	for attacker in _get_move_data_attackers():
		if not is_instance_valid(attacker) or attacker.fighterState == null:
			continue
		var move_state: State = attacker.fighterState.state
		if (move_state is AttackState or move_state is AirAttackState) \
				and not _get_move_frame_events(move_state).is_empty():
			return attacker
	return null

func _reset_move_data_display() -> void:
	$AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " --"
	$ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " --"
	$AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " --"
	$FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " --"

func _reset_move_data_tracking() -> void:
	_move_data_state_name = ""
	_move_data_advantage_locked = false
	_move_data_contacted = false
	_move_data_actor = null
	_move_data_advantage_player = null
	_move_data_advantage_state_name = ""
	_move_data_contact_advantage = 0
	_move_data_contact_end_frame = 0
	_move_data_contact_start_frame = 0
	_move_data_contact_last_frame = 0
	_move_data_projectile_sources.clear()
	_reset_move_data_display()

func _get_move_frame_events(move_state: State) -> Array[FrameEvent]:
	return FrameBar.get_move_frame_events(move_state)

func _get_move_frame_event_duration(events: Array[FrameEvent], event_type: FrameEvent.EventType) -> int:
	var duration: int = 0
	for event in events:
		if event.type == event_type:
			duration += event.duration
	return duration

func _get_first_active_frame(events: Array[FrameEvent]) -> int:
	for event in events:
		if event.type == FrameEvent.EventType.FIRST_ACTIVE:
			return event.start_frame + 1
	return 0

func _update_move_data() -> void:
	var player: BasePlayer = _move_data_actor if _move_data_contacted else _get_active_move_data_attacker()
	if not is_instance_valid(player):
		player = _move_data_actor if is_instance_valid(_move_data_actor) else _get_controlled_player()
	var advantage_player: BasePlayer = (
		_move_data_advantage_player if _move_data_contacted else _get_controlled_player()
	)
	if not is_instance_valid(player) or player.fighterState == null \
			or not is_instance_valid(advantage_player) or advantage_player.fighterState == null:
		return
	var move_state: State = player.fighterState.state
	var state_name: String = player.currentState.get(Enums.StKey.stateName, "")
	var advantage_state: State = advantage_player.fighterState.state
	if advantage_state == null:
		return
	var advantage_state_name: String = advantage_player.currentState.get(Enums.StKey.stateName, "")
	var events: Array[FrameEvent] = []
	if move_state is AttackState or move_state is AirAttackState:
		events = _get_move_frame_events(move_state)
	var is_attack_move: bool = not events.is_empty()

	if _move_data_contacted and advantage_state_name == _move_data_advantage_state_name:
		_move_data_contact_last_frame = maxi(
			_move_data_contact_last_frame, advantage_player.currentState.get(Enums.StKey.frame, 0)
		)
	if _move_data_contacted and advantage_state_name != _move_data_advantage_state_name:
		var cancelled_recovery: int = 0
		var was_interrupted: bool = advantage_state is HurtState or advantage_state is AirReactionState
		var is_attack_followup: bool = (
			(advantage_state is AttackState or advantage_state is AirAttackState)
			and not _get_move_frame_events(advantage_state).is_empty()
		)
		var is_landing_recovery: bool = _is_landing_recovery_state(advantage_state_name)
		if not was_interrupted and _move_data_contact_last_frame < _move_data_contact_end_frame - 1:
			cancelled_recovery = _move_data_contact_end_frame - _move_data_contact_last_frame
		_move_data_contact_advantage += cancelled_recovery
		if not was_interrupted and is_landing_recovery:
			_move_data_contact_advantage -= maxi(
				advantage_state.endFrame - advantage_player.currentState.get(Enums.StKey.frame, 0), 0
			)
		if not was_interrupted and is_attack_followup:
			_move_data_advantage_state_name = advantage_state_name
			_move_data_contact_end_frame = advantage_state.endFrame
			_move_data_contact_start_frame = advantage_player.currentState.get(Enums.StKey.frame, 0)
			_move_data_contact_last_frame = _move_data_contact_start_frame
			_move_data_contact_advantage -= maxi(
				advantage_state.endFrame - _move_data_contact_start_frame, 0
			)
		else:
			_set_move_data_advantage_value(_move_data_contact_advantage)
			_move_data_contacted = false
			_move_data_advantage_player = null
	elif not _move_data_contacted and state_name != _move_data_state_name:
		if is_attack_move:
			_move_data_advantage_locked = false
			$FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " --"

	if not _move_data_contacted:
		_move_data_state_name = state_name
	if not is_attack_move:
		if not _move_data_advantage_locked:
			_reset_move_data_display()
		_move_data_actor = player
		return
	_set_move_data_frame_values(events)
	_move_data_actor = player

func _calculate_frame_advantage(
	player: BasePlayer, opponent: BasePlayer, opponent_stun: int, player_recovery: int
) -> int:
	var opponent_hitstop: int = maxi(opponent.currentState.get(Enums.StKey.hitStopFrame, 0), 0)
	var player_hitstop: int = maxi(player.currentState.get(Enums.StKey.hitStopFrame, 0), 0)
	return opponent_stun + opponent_hitstop - player_hitstop - player_recovery

func _is_landing_recovery_state(state_name: String) -> bool:
	return state_name.ends_with("LandingRecovery") or state_name.ends_with("LandAttackRecovery")

func _set_move_data_advantage_value(advantage: int) -> void:
	_set_move_data_advantage_text(advantage)
	_move_data_advantage_locked = true

func _set_move_data_frame_values(events: Array[FrameEvent]) -> void:
	$AttackStartup.text = tr("UI_TRAINING_ATTACK_STARTUP") + " " + str(
		_get_first_active_frame(events)
	)
	$ActiveFrames.text = tr("UI_TRAINING_ATTACK_ACTIVE") + " " + str(
		_get_move_frame_event_duration(events, FrameEvent.EventType.ACTIVE)
	)
	$AttackRecovery.text = tr("UI_TRAINING_ATTACK_RECOVERY") + " " + str(
		_get_move_frame_event_duration(events, FrameEvent.EventType.RECOVERY)
	)

func _set_move_data_advantage_text(advantage: int) -> void:
	var value := "%+d" % advantage
	if advantage > 0:
		value = "[color=green]%s[/color]" % value
	elif advantage < 0:
		value = "[color=red]%s[/color]" % value
	$FrameAdvantage.text = tr("UI_TRAINING_FRAME_ADVANTAGE") + " " + value
