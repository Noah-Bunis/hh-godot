extends PanelContainer

class_name PunishAnalysis

const MAX_DISPLAYED_MOVES := 25
const COMBO_TRIAL_DISPLAY_NAMES = preload("res://game/ui/ComboTrialDisplayNames.gd")
const PUNISH_HITBOX_SIMULATOR = preload(
	"res://game/ui/framebar/PunishHitboxSimulator.gd"
)
const ASSIST_CALL_STATES := [
	"AssistAttack",
	"AssistAttack2",
	"AssistAirAttack",
	"AssistAirAttack2",
	"AssistSuper",
	"AssistAirSuper"
]
const SUISEI_NORMAL_MOVES := [
	"Stand5A", "Stand5B", "StandcB", "Stand6A", "Crouch2A", "Crouch2B",
	"Jump5A", "Jump5B", "Jump6B", "GroundThrowWhiff", "GroundBackThrowWhiff",
	"AirThrowWhiff", "AirBackThrowWhiff", "YoruMatsuyo", "LightYoruMatsuyo",
	"GatoKick", "GatoDive", "Pendulum", "CaramelThrust", "AirCaramelThrust",
]
const SUISEI_SUICOPATH_MOVES := [
	"AngelStand5A", "AngelStand5B", "AngelStandcB", "AngelStand6A",
	"AngelCrouch2A", "AngelCrouch2B", "AngelJump5A", "AngelJump5B",
	"AngelJump2B", "AngelGroundThrowWhiff", "AngelGroundBackThrowWhiff",
	"AngelAirThrowWhiff", "AngelAirBackThrowWhiff", "Scissors", "Chainsaws",
]
const PROJECTILE_SUMMON_NAMES := [
	"subarustarball",
	"subarubattersetball",
	"subaruexbattersetball",
	"miocards",
	"suicopathchainsaw",
	"rook",
	"chargerook",
	"bishop",
	"chargebishop",
	"knight",
	"airknight",
	"chargeknight",
	"queen",
	"protoncannon",
	"rikkaball",
	"rikkaredball",
	"rikkasuperball",
	"assistsubarustarball",
	"assistprotoncannon",
	"hakkatags",
]
const STATIONARY_BEAM_SUMMON_NAMES := [
	"protoncannon",
	"assistprotoncannon",
]

@export var move_blacklist: Array[String] = [
	"StandParryWhiff",
	"CrouchParryWhiff",
	"AirParryWhiff",
	"RedStandParryWhiff",
	"RedCrouchParryWhiff",
	"RedAirParryWhiff",
	"StandParryCatch",
	"CrouchParryCatch",
	"AirParryCatch",
	"AngelStandParryWhiff",
	"AngelCrouchParryWhiff",
	"AngelAirParryWhiff",
	"AngelRedStandParryWhiff",
	"AngelRedCrouchParryWhiff",
	"AngelRedAirParryWhiff",
	"AngelStandParryCatch",
	"AngelCrouchParryCatch",
	"AngelAirParryCatch",
	"AngelUninstall",
	"GroundAssistCall",
	"GroundAssistCall2",
	"GroundAssistCallSuper",
	"AirAssistCall",
	"AirAssistCall2",
	"AirAssistCallSuper",
	"AngelGroundAssistCall",
	"AngelGroundAssistCall2",
	"AngelGroundAssistCallSuper",
	"AngelAirAssistCall",
	"AngelAirAssistCall2",
	"AngelAirAssistCallSuper",
	"KanataFiftyKGHit",
	"KanataFiftyRekkaA",
	"KanataAirFiftyKGHit",
	"KanataAirFiftyRekkaA",
	"KanataSuperFiftyKGHit",
	"KanataSuperFiftyRekkaA",
	"GroundThrowHit",
	"GroundBackThrowHit",
	"AirThrowHit",
	"AirBackThrowHit",
	"AngelGroundThrowHit",
	"AngelGroundBackThrowHit",
	"AngelAirThrowHit",
	"AngelAirBackThrowHit",
	"AngelJump2B2",
	"Burst",
	"GrappleFollowup"

]

@export var player_label: String = ""

@onready var _output: RichTextLabel = $Output

var icon_paths: Dictionary = load("res://game/ui/IconPaths.gd").ICON_PATHS
var button_icon_size := 20
var combo_prose_regex := RegEx.new()
var _hitbox_simulator = PUNISH_HITBOX_SIMULATOR.new()

var _enabled := false
var _last_state_property_snapshot: Dictionary = {}
var _last_geometry_snapshot: Dictionary = {}
var _last_valid_output := ""
var _last_result_window := 0
var _last_player_moves: Array[Dictionary] = []
var _last_assist_moves: Array[Dictionary] = []
var _last_assist_available := false
var _has_last_state_property_snapshot := false
var _has_last_geometry_snapshot := false
var _best_punish_window := -1
var _punish_window_latched := false
var _neutral_hold_active := false
var _neutral_hold_reached_both := false
var _tracked_suisei_instance_id := 0
var _suisei_suicopath_stance := false

func _ready() -> void:
	combo_prose_regex.compile("UI_COMBO_WORD_[A-Z_]+")
	visible = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready() \
			and not _last_valid_output.is_empty():
		_refresh_last_output()

func set_enabled(is_enabled: bool) -> void:
	if _enabled == is_enabled:
		return
	_enabled = is_enabled
	reset_analysis()

func update_analysis(player: BasePlayer, assist: BasePlayer, opponent: BasePlayer) -> void:
	if (
		not is_instance_valid(player)
		or not is_instance_valid(opponent)
	):
		reset_analysis()
		return

	_update_suisei_stance(player)
	var state_property_snapshot := {
		"player": _get_entity_snapshot(player),
		"assist": _get_entity_snapshot(assist) if is_instance_valid(assist) else {},
		"opponent": _get_entity_snapshot(opponent),
	}
	var geometry_snapshot := {
		"player": _get_geometry_snapshot(player),
		"assist": _get_geometry_snapshot(assist) if is_instance_valid(assist) else {},
		"opponent": _get_geometry_snapshot(opponent),
	}
	var was_both_neutral := (
		_has_last_state_property_snapshot
		and _are_player_and_opponent_neutral(_last_state_property_snapshot)
	)
	var are_both_neutral := _are_player_and_opponent_neutral(state_property_snapshot)
	var entered_neutral := (
		_has_last_state_property_snapshot
		and _entered_neutral_state(
			_last_state_property_snapshot,
			state_property_snapshot
		)
	)
	var state_or_property_changed := (
		not _has_last_state_property_snapshot
		or state_property_snapshot != _last_state_property_snapshot
	)
	var geometry_changed := (
		not _has_last_geometry_snapshot
		or geometry_snapshot != _last_geometry_snapshot
	)
	var opponent_action_changed: bool = (
		_has_last_state_property_snapshot
		and (
			_last_state_property_snapshot["opponent"]["instance_id"]
				!= state_property_snapshot["opponent"]["instance_id"]
			or _last_state_property_snapshot["opponent"]["state_name"]
				!= state_property_snapshot["opponent"]["state_name"]
		)
	)
	if opponent_action_changed and not _is_neutral_state_name(
		str(state_property_snapshot["opponent"]["state_name"])
	):
		_punish_window_latched = false

	var left_neutral_after_hold := (
		_neutral_hold_active
		and _neutral_hold_reached_both
		and was_both_neutral
		and not are_both_neutral
	)
	var left_neutral_before_both := (
		_neutral_hold_active
		and not _neutral_hold_reached_both
		and not are_both_neutral
		and _left_neutral_state(
			_last_state_property_snapshot,
			state_property_snapshot
		)
	)
	var ended_neutral_hold := (
		left_neutral_after_hold or left_neutral_before_both
	)
	if ended_neutral_hold:
		_neutral_hold_active = false
		_neutral_hold_reached_both = false
		_punish_window_latched = false
	elif entered_neutral and not _last_valid_output.is_empty():
		_neutral_hold_active = true
		_output.text = _last_valid_output
		visible = _enabled
	if _neutral_hold_active and are_both_neutral:
		_neutral_hold_reached_both = true

	_last_state_property_snapshot = state_property_snapshot
	_has_last_state_property_snapshot = true
	_last_geometry_snapshot = geometry_snapshot
	_has_last_geometry_snapshot = true
	if ended_neutral_hold:
		_best_punish_window = -1
		_last_valid_output = ""
		visible = false
	elif (
		state_or_property_changed
		and not _neutral_hold_active
	):
		_best_punish_window = -1
		_punish_window_latched = false
		visible = false
		if not entered_neutral:
			_last_valid_output = ""
	elif (
		geometry_changed
		and not _neutral_hold_active
		and not _punish_window_latched
	):
		_best_punish_window = -1
		visible = false

	if int(player.currentState.get(Enums.StKey.hitstun, 0)) > 0:
		_punish_window_latched = false
		_best_punish_window = -1
		_last_valid_output = ""
		_output.text = ""
		visible = false
		return

	if _punish_window_latched:
		_output.text = _last_valid_output
		visible = _enabled
		return

	if _neutral_hold_active:
		_output.text = _last_valid_output
		visible = _enabled
		return

	var opponent_state := _get_current_state(opponent)
	if opponent_state == null or _has_projectile_summon(opponent_state):
		return

	var recovery_frames := _get_recovery_frames(
		opponent,
		opponent_state,
		player
	)
	if recovery_frames <= 0:
		return

	var player_delay := _get_earliest_action_delay(player)
	var punish_window := maxi(recovery_frames - player_delay, 0)
	if punish_window <= _best_punish_window:
		return
	_best_punish_window = punish_window

	var air_move_startup_delay := _get_air_move_startup_delay(player)
	var player_moves := _get_punish_moves(
		player,
		punish_window,
		false,
		air_move_startup_delay,
		opponent,
		opponent_state,
		player_delay,
		null
	)
	var assist_available := (
		is_instance_valid(assist)
		and assist.fighterState != null
		and assist.has_property(Enums.StateProperty.DormantAssist)
	)
	var assist_moves: Array[Dictionary] = []
	if assist_available:
		assist_moves = _get_punish_moves(
			assist,
			punish_window,
			true,
			air_move_startup_delay,
			opponent,
			opponent_state,
			0,
			player
		)

	if player_moves.is_empty() and assist_moves.is_empty():
		_output.text = ""
		visible = false
		return

	_last_result_window = punish_window
	_last_player_moves = player_moves
	_last_assist_moves = assist_moves
	_last_assist_available = assist_available
	_refresh_last_output()
	_punish_window_latched = true
	visible = _enabled

func _refresh_last_output() -> void:
	var assist_text := (
		_format_move_list(_last_assist_moves)
		if _last_assist_available else tr("UI_PUNISH_UNAVAILABLE")
	)
	var lines: Array[String] = [tr("UI_PUNISH_WINDOW").format({
		"frames": _last_result_window,
		"newline": "\n",
		"player_moves": _format_move_list(_last_player_moves),
		"assist_moves": assist_text,
	})]
	if not player_label.is_empty():
		lines.push_front("[b]%s[/b]" % tr(player_label))
	lines.append(tr("UI_PUNISH_DISTANCE_NOTE"))
	_last_valid_output = "\n".join(lines)
	_output.text = _last_valid_output

func reset_analysis() -> void:
	_last_state_property_snapshot.clear()
	_last_geometry_snapshot.clear()
	_last_valid_output = ""
	_last_player_moves.clear()
	_last_assist_moves.clear()
	_has_last_state_property_snapshot = false
	_has_last_geometry_snapshot = false
	_best_punish_window = -1
	_punish_window_latched = false
	_neutral_hold_active = false
	_neutral_hold_reached_both = false
	_tracked_suisei_instance_id = 0
	_suisei_suicopath_stance = false
	visible = false

func _get_punish_moves(
	entity: BasePlayer,
	startup_budget: int,
	is_assist: bool = false,
	air_move_startup_delay: int = 0,
	opponent: BasePlayer = null,
	opponent_state: State = null,
	action_delay: int = 0,
	attacker_anchor: BasePlayer = null
) -> Array[Dictionary]:
	var moves: Array[Dictionary] = []
	if startup_budget <= 0 or entity.fighterState == null:
		return moves

	var state_factory: StateFactory = entity.fighterState.state_factory
	if state_factory == null:
		return moves
	var is_subaru := state_factory is SubaruStateFactory
	var is_suisei := state_factory is SuiseiStateFactory
	var subaru_angel_install_active := (
		is_subaru and _is_subaru_angel_install_active(entity)
	)
	var display_character_name := _get_display_character_name(entity, is_assist)
	for move_name in state_factory.states_instance:
		var move_name_string := str(move_name)
		var normalized_move_name := move_name_string.to_lower()
		var is_angel_move := normalized_move_name.begins_with("angel")
		var is_suicopath_only_move := normalized_move_name in [
			"scissors",
			"chainsaws",
		]
		if is_subaru and is_angel_move and not subaru_angel_install_active:
			continue
		if is_suisei and not is_assist:
			if move_name_string == "Scissors" and not Global.level_1_OK(entity.currentState):
				continue
			if move_name_string == "Chainsaws" and not Global.level_2_OK(entity.currentState):
				continue
		var requires_suisei_switch := is_suisei and not is_assist and (
			_suisei_suicopath_stance != (is_angel_move or is_suicopath_only_move)
		)
		if requires_suisei_switch:
			var available_moves := (
				SUISEI_NORMAL_MOVES if _suisei_suicopath_stance
				else SUISEI_SUICOPATH_MOVES
			)
			if move_name_string not in available_moves:
				continue
		if (
			move_name_string in move_blacklist
			or normalized_move_name.contains("parry")
			or normalized_move_name.contains("boostcancel")
			or normalized_move_name.contains("guardcancel")
		):
			continue
		if normalized_move_name.contains("throwwhiff") \
				and int(entity.currentState.get(
					Enums.StKey.distance_to_opponent,
					Util.PROXY_NORMAL + 1
				)) > Util.PROXY_NORMAL:
			continue
		if is_assist and move_name_string not in ASSIST_CALL_STATES:
			continue
		var move_state: State = state_factory.states_instance[move_name]
		if not (move_state is AttackState or move_state is AirAttackState):
			continue
		if is_suisei and not is_assist and _suisei_suicopath_stance \
				and not requires_suisei_switch and move_state is AirAttackState \
				and not entity.has_property(Enums.StateProperty.AirThrowOK):
			continue
		var beam_startup := _get_stationary_beam_startup(move_state)
		var is_stationary_beam := beam_startup >= 0
		if _has_projectile_summon(move_state) and not is_stationary_beam:
			continue
		var timing: Dictionary = (
			{"startup": beam_startup} if is_stationary_beam
			else _hitbox_simulator.get_attack_timing(move_state)
		)
		if timing.is_empty():
			continue
		var move_delay := _get_move_action_delay(
			entity, move_name_string, move_state, is_assist, air_move_startup_delay
		)
		if move_delay < 0:
			continue
		if requires_suisei_switch:
			var switch_delay := _get_suisei_form_switch_delay(
				entity, move_name_string, move_state
			)
			if switch_delay < 0:
				continue
			move_delay += switch_delay - _get_action_delay(entity)
		var startup: int = timing["startup"] + maxi(move_delay - action_delay, 0)
		if startup > startup_budget:
			continue
		if not is_stationary_beam:
			if not _hitbox_simulator.will_move_hit_during_recovery(
				entity,
				move_state,
				opponent,
				opponent_state,
				timing,
				move_delay,
				attacker_anchor
			):
				continue
		var display_name := COMBO_TRIAL_DISPLAY_NAMES.get_display_name(
			display_character_name, move_name_string
		)
		if requires_suisei_switch:
			var switch_input := "C UI_COMBO_WORD_CHANGE UI_COMBO_WORD_THEN "
			if not entity.has_property(Enums.StateProperty.AirThrowOK) \
					and _is_suisei_air_only_move(move_name_string, move_state):
				if _suisei_suicopath_stance:
					switch_input += "Up UI_COMBO_WORD_THEN "
				else:
					switch_input = "Up UI_COMBO_WORD_THEN " + switch_input
			display_name = switch_input + display_name
		moves.append({
			"name": move_name_string,
			"display_name": display_name,
			"startup": startup,
		})

	moves.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if a["startup"] == b["startup"]:
			return a["name"] < b["name"]
		return a["startup"] > b["startup"]
	)
	return moves

func _get_display_character_name(entity: BasePlayer, is_assist: bool) -> String:
	if is_assist or entity.fighterState == null:
		return ""

	var state_factory: StateFactory = entity.fighterState.state_factory
	if state_factory is SubaruStateFactory:
		return "Subaru"
	if state_factory is MioStateFactory:
		return "Mio"
	if state_factory is OgaStateFactory:
		return "Oga"
	if state_factory is SuiseiStateFactory:
		return "Suisei"
	if state_factory is OllieStateFactory:
		return "Ollie"
	if state_factory is KanataStateFactory:
		return "Kanata"
	if state_factory is FlayonStateFactory:
		return "Flayon"
	return ""

func _update_suisei_stance(entity: BasePlayer) -> void:
	if entity.fighterState == null \
			or not (entity.fighterState.state_factory is SuiseiStateFactory):
		_tracked_suisei_instance_id = 0
		_suisei_suicopath_stance = false
		return

	var instance_id := entity.get_instance_id()
	if instance_id != _tracked_suisei_instance_id:
		_tracked_suisei_instance_id = instance_id
		_suisei_suicopath_stance = false

	var state_name := str(entity.currentState.get(Enums.StKey.stateName, ""))
	var normalized_state_name := state_name.to_lower()
	var current_state: State = entity.fighterState.state
	if current_state is SuicopathToSuiseiState \
			or current_state is SuicopathToSuiseiAirState:
		_suisei_suicopath_stance = false
	elif current_state is SuiseiToSuicopathState \
			or current_state is SuiseiToSuicopathAirState:
		_suisei_suicopath_stance = true
	elif (
		normalized_state_name.begins_with("angel")
		or normalized_state_name.contains("suicopath")
		or normalized_state_name in ["scissors", "chainsaws"]
	):
		_suisei_suicopath_stance = true
	elif normalized_state_name != "intro" \
			and not _is_landing_recovery_state(state_name):
		_suisei_suicopath_stance = false

func _is_subaru_angel_install_active(entity: BasePlayer) -> bool:
	var state_name := str(entity.currentState.get(Enums.StKey.stateName, ""))
	return (
		state_name.to_lower().begins_with("angel")
		and int(entity.currentState.get(Enums.StKey.super_meter, 0)) > 0
	)

func _has_projectile_summon(move_state: State) -> bool:
	if move_state.anim_data == null:
		return false
	for frame_data in move_state.anim_data.values():
		var summon_name := str(frame_data.get(Enums.StKey.Summon, "")).to_lower()
		if summon_name in PROJECTILE_SUMMON_NAMES:
			return true
	return false

func _get_stationary_beam_startup(move_state: State) -> int:
	if move_state.anim_data == null:
		return -1
	var first_beam_frame := -1
	for frame in move_state.anim_data:
		var frame_data: Dictionary = move_state.anim_data[frame]
		var summon_name := str(frame_data.get(Enums.StKey.Summon, "")).to_lower()
		if summon_name in STATIONARY_BEAM_SUMMON_NAMES:
			if first_beam_frame < 0 or int(frame) < first_beam_frame:
				first_beam_frame = int(frame)
	if first_beam_frame < 0:
		return -1
	return first_beam_frame + 1

func _get_recovery_frames(
	entity: BasePlayer,
	state: State,
	target: BasePlayer
) -> int:
	var current_frame: int = entity.currentState.get(Enums.StKey.frame, 0)
	if current_frame > state.endFrame:
		return 0
	if _is_landing_recovery_state(
		str(entity.currentState.get(Enums.StKey.stateName, ""))
	):
		return (
			maxi(state.endFrame - current_frame + 1, 0)
			+ _get_remaining_hitstop_delay(entity)
		)
	if not (state is AttackState or state is AirAttackState):
		return 0

	var timing := _hitbox_simulator.get_attack_timing(state)
	if timing.is_empty():
		return 0
	var remaining_frames := (
		maxi(state.endFrame - current_frame + 1, 0)
		+ _get_remaining_hitstop_delay(entity)
	)
	var active_frames_remaining := (
		maxi(timing["last_active_frame"] - current_frame + 1, 0)
		+ _get_remaining_hitstop_delay(entity)
	)
	if current_frame <= timing["last_active_frame"] \
			and not _has_attack_cooldown_against_target(
				entity,
				target,
				active_frames_remaining
			):
		return 0
	return remaining_frames

func _has_attack_cooldown_against_target(
	attacker: BasePlayer,
	target: BasePlayer,
	frames_until_active_end: int
) -> bool:
	var hit_cooldowns: Dictionary = attacker.currentState.get(
		Enums.StKey.hit_cooldown,
		{}
	)
	var cooldown := -1
	if hit_cooldowns.has(str(target.name)):
		cooldown = int(hit_cooldowns[str(target.name)])
	elif hit_cooldowns.size() == 1:
		cooldown = int(hit_cooldowns.values()[0])
	return cooldown > frames_until_active_end

func _get_entity_snapshot(entity: BasePlayer) -> Dictionary:
	var properties: Dictionary = {}
	if entity.fighterState != null:
		for state_property in Enums.StateProperty.values():
			properties[state_property] = entity.has_property(state_property)
	return {
		"instance_id": entity.get_instance_id(),
		"state_name": entity.currentState.get(Enums.StKey.stateName, "Neutral"),
		"properties": properties,
	}

func _get_geometry_snapshot(entity: BasePlayer) -> Dictionary:
	var position: SGFixedVector2 = entity.get_global_fixed_position()
	return {
		"position_x": int(position.x),
		"position_y": int(position.y),
		"frame": int(entity.currentState.get(Enums.StKey.frame, 0)),
		"leftface": bool(entity.currentState.get(Enums.StKey.leftface, false)),
		"scale_x": int(entity.fixed_scale.x),
		"scale_y": int(entity.fixed_scale.y),
	}

func _entered_neutral_state(
	previous_snapshot: Dictionary,
	current_snapshot: Dictionary
) -> bool:
	for entity_name in ["player", "opponent"]:
		var previous_entity: Dictionary = previous_snapshot[entity_name]
		var current_entity: Dictionary = current_snapshot[entity_name]
		var previous_state_name: String = str(previous_entity["state_name"])
		var current_state_name: String = str(current_entity["state_name"])
		if previous_state_name != current_state_name \
				and _is_neutral_state_name(current_state_name):
			return true
	return false

func _left_neutral_state(
	previous_snapshot: Dictionary,
	current_snapshot: Dictionary
) -> bool:
	for entity_name in ["player", "opponent"]:
		var previous_state_name: String = str(
			previous_snapshot[entity_name]["state_name"]
		)
		var current_state_name: String = str(
			current_snapshot[entity_name]["state_name"]
		)
		if _is_neutral_state_name(previous_state_name) \
				and not _is_neutral_state_name(current_state_name):
			return true
	return false

func _are_player_and_opponent_neutral(snapshot: Dictionary) -> bool:
	return (
		_is_neutral_state_name(str(snapshot["player"]["state_name"]))
		and _is_neutral_state_name(str(snapshot["opponent"]["state_name"]))
	)

func _is_neutral_state_name(state_name: String) -> bool:
	return state_name.to_lower() in [
		"neutral",
		"stand",
		"crouch",
		"angelstand",
		"angelcrouch",
	]

func _is_landing_recovery_state(state_name: String) -> bool:
	return (
		state_name.ends_with("LandingRecovery")
		or state_name.ends_with("LandAttackRecovery")
	)

func _get_current_state(entity: BasePlayer) -> State:
	if entity.fighterState == null:
		return null
	return entity.fighterState.state

func _get_action_delay(entity: BasePlayer) -> int:
	if entity.fighterState == null:
		return 0
	var state: State = entity.fighterState.state
	if entity.currentState.get(Enums.StKey.hitstun, 0) > 0:
		return (
			int(entity.currentState[Enums.StKey.hitstun])
			+ _get_remaining_hitstop_delay(entity)
		)
	if state is AttackState or state is AirAttackState:
		return maxi(
			state.endFrame - int(entity.currentState.get(Enums.StKey.frame, 0)) + 1,
			0
		) + _get_remaining_hitstop_delay(entity)
	return 0

func _get_earliest_action_delay(entity: BasePlayer) -> int:
	var delay := _get_action_delay(entity)
	if entity.fighterState != null \
			and entity.fighterState.state_factory is SuiseiStateFactory:
		delay = mini(delay, _get_suisei_switch_start_delay(entity))
	for move_name in [
		"KanataWingStanceA", "KanataAirWingStanceA", "GatoKick", "GatoDive",
		"Flight5A", "Flight5BEarly", "Flight5CEarly", "Flight2CEarly",
	]:
		var stance_delay := _get_active_stance_delay(entity, move_name)
		if stance_delay >= 0:
			delay = mini(delay, stance_delay)
	return delay

func _get_active_stance_delay(entity: BasePlayer, move_name: String) -> int:
	if entity.fighterState == null:
		return -1
	var current_name := str(entity.currentState.get(Enums.StKey.stateName, ""))
	var current_frame := int(entity.currentState.get(Enums.StKey.frame, 0))
	var threshold := -1
	if entity.fighterState.state_factory is KanataStateFactory:
		if (
			(current_name == "KanataWingStance" and move_name.begins_with("KanataWingStance"))
			or (current_name == "AirKanataWingStance" and move_name.begins_with("KanataAirWingStance"))
		):
			threshold = Util.INPUT_BUFFER_LENIANCY
	elif entity.fighterState.state_factory is SuiseiStateFactory \
			and move_name in ["GatoKick", "GatoDive", "Pendulum"]:
		if current_name in ["YoruMatsuyo", "LightYoruMatsuyo"]:
			threshold = SuiseiYoruMatsuyoState.GATO_CANCEL_FRAME
		elif move_name == "GatoDive" and current_name == "Pendulum":
			threshold = SuiseiPendulumState.FOLLOWUP_CANCEL_FRAME
		elif move_name in ["GatoDive", "Pendulum"] and current_name == "GatoKick":
			threshold = SuiseiGatoKickState.FOLLOWUP_CANCEL_FRAME
	elif entity.fighterState.state_factory is FlayonStateFactory \
			and move_name.begins_with("Flight"):
		if current_name == "Flight":
			threshold = current_frame
		elif current_name in ["FlightEnter", "AirFlightEnter"]:
			# Flight itself must receive input on the tick after entry finishes.
			threshold = entity.fighterState.state.endFrame
		else:
			var charge_state := ""
			if move_name.begins_with("Flight5B"):
				charge_state = "Flight5B"
			elif move_name.begins_with("Flight5C"):
				charge_state = "Flight5C"
			elif move_name.begins_with("Flight2C"):
				charge_state = "Flight2C"
			if current_name == charge_state:
				if move_name.ends_with("Early") \
						and current_frame < FlayonFlightBaseState.FULL_CHARGE_FRAME:
					threshold = FlayonFlightBaseState.EARLY_RELEASE_FRAME
				elif move_name.ends_with("Increase"):
					threshold = FlayonFlightBaseState.FULL_CHARGE_FRAME
	if threshold < 0:
		return -1
	return maxi(threshold - current_frame, 0) + _get_remaining_hitstop_delay(entity)

func _get_move_action_delay(
	entity: BasePlayer,
	move_name: String,
	move_state: State,
	is_assist: bool,
	air_move_startup_delay: int
) -> int:
	var delay := 0 if is_assist else _get_action_delay(entity)
	var factory: StateFactory = entity.fighterState.state_factory
	var entry_name := ""
	var entry_delay := 0
	var is_air_entry := false
	if not is_assist and factory is KanataStateFactory:
		if move_name.begins_with("KanataAirWingStance"):
			entry_name = "AirKanataWingStance"
			is_air_entry = true
		elif move_name.begins_with("KanataWingStance"):
			entry_name = "KanataWingStance"
		entry_delay = Util.INPUT_BUFFER_LENIANCY + 1
	elif not is_assist and factory is SuiseiStateFactory \
			and move_name in ["GatoKick", "GatoDive", "Pendulum"]:
		entry_name = "YoruMatsuyo"
		entry_delay = SuiseiYoruMatsuyoState.GATO_CANCEL_FRAME + 1
	elif not is_assist and factory is FlayonStateFactory \
			and move_name.begins_with("Flight"):
		entry_name = (
			"AirFlightEnter" if entity.has_property(Enums.StateProperty.AirThrowOK)
			else "FlightEnter"
		)
		var entry_state: State = factory.states_instance.get(entry_name)
		if entry_state == null:
			push_error("Missing stance entry state: " + entry_name)
			return -1
		entry_delay = entry_state.endFrame + 1

	if entry_name.is_empty():
		if move_state is AirAttackState and not (
			factory is SuiseiStateFactory
			and move_name in ["YoruMatsuyo", "LightYoruMatsuyo"]
		):
			delay += air_move_startup_delay
		return delay

	if factory.states_instance.get(entry_name) == null:
		push_error("Missing stance entry state: " + entry_name)
		return -1
	var stance_delay := _get_active_stance_delay(entity, move_name)
	if stance_delay >= 0:
		delay = stance_delay
	elif factory is FlayonStateFactory and entity.fighterState.state is FlayonFlightBaseState:
		pass
	else:
		delay += entry_delay
		if is_air_entry:
			delay += air_move_startup_delay

	if factory is FlayonStateFactory:
		var current_name := str(entity.currentState.get(Enums.StKey.stateName, ""))
		var charge_state := move_name.trim_suffix("Early").trim_suffix("Increase")
		if current_name == charge_state and move_name.ends_with("Early") \
				and stance_delay < 0:
			var charged_state: State = factory.states_instance.get(charge_state + "Increase")
			if charged_state == null:
				push_error("Missing flight charge state: " + charge_state + "Increase")
				return -1
			delay = charged_state.endFrame + 2 + _get_remaining_hitstop_delay(entity)
		if current_name != charge_state or stance_delay < 0:
			if move_name.ends_with("Early"):
				delay += FlayonFlightBaseState.EARLY_RELEASE_FRAME + 1
			elif move_name.ends_with("Increase"):
				delay += FlayonFlightBaseState.FULL_CHARGE_FRAME + 1
	return delay

func _get_suisei_switch_start_delay(entity: BasePlayer) -> int:
	var delay := _get_action_delay(entity)
	var current_name := str(entity.currentState.get(Enums.StKey.stateName, ""))
	var threshold := -1
	match current_name:
		"YoruMatsuyo", "LightYoruMatsuyo":
			threshold = SuiseiYoruMatsuyoState.FORM_CHANGE_FRAME
		"GatoKick":
			threshold = SuiseiGatoKickState.FOLLOWUP_CANCEL_FRAME
		"GatoDive":
			threshold = SuiseiGatoDiveState.FORM_CHANGE_FRAME
		"Pendulum":
			threshold = SuiseiPendulumState.FOLLOWUP_CANCEL_FRAME
	if threshold < 0:
		return delay
	var hitstop := int(entity.currentState.get(Enums.StKey.hitStopFrame, -1))
	if hitstop >= 0:
		return mini(delay, maxi(hitstop - 1, 1))
	var current_frame := int(entity.currentState.get(Enums.StKey.frame, 0))
	return mini(delay, maxi(threshold - current_frame, 0))

func _get_suisei_form_switch_delay(
	entity: BasePlayer, move_name: String, move_state: State
) -> int:
	var airborne := entity.has_property(Enums.StateProperty.AirThrowOK)
	var air_only_move := _is_suisei_air_only_move(move_name, move_state)
	if airborne and not (move_state is AirAttackState):
		return -1
	var air_switch := airborne or (not _suisei_suicopath_stance and air_only_move)
	var switch_name: String
	if _suisei_suicopath_stance:
		switch_name = "AirSuicopathToSuisei" if air_switch else "AngelUninstall"
	else:
		switch_name = "AirSuiseiToSuicopath" if air_switch else "AngelInstall"
	var factory: StateFactory = entity.fighterState.state_factory
	var switch_state: State = factory.states_instance.get(switch_name)
	if switch_state == null:
		push_error("Missing Suisei form change state: " + switch_name)
		return -1
	return _get_suisei_switch_start_delay(entity) + switch_state.endFrame + 1

func _is_suisei_air_only_move(move_name: String, move_state: State) -> bool:
	return move_state is AirAttackState and move_name not in [
		"YoruMatsuyo", "LightYoruMatsuyo", "GatoKick", "GatoDive", "Pendulum",
	]

func _get_remaining_hitstop_delay(entity: BasePlayer) -> int:
	return maxi(
		int(entity.currentState.get(Enums.StKey.hitStopFrame, 0)) - 1,
		0
	)

func _get_air_move_startup_delay(entity: BasePlayer) -> int:
	if entity.fighterState == null or entity.has_property(Enums.StateProperty.AirThrowOK):
		return 0

	var current_state_name: String = str(
		entity.currentState.get(Enums.StKey.stateName, "")
	)
	if current_state_name.to_lower().contains("prejump"):
		var current_state := _get_current_state(entity)
		if current_state != null:
			return maxi(
				current_state.endFrame
					- int(entity.currentState.get(Enums.StKey.frame, 0))
					+ 1,
				0
			)

	var state_factory: StateFactory = entity.fighterState.state_factory
	if state_factory == null:
		return 0
	var pre_jump_frames := 0
	for move_name in state_factory.states_instance:
		var normalized_state_name := str(move_name).to_lower()
		if not normalized_state_name.contains("prejump") \
				or normalized_state_name.contains("midair") \
				or normalized_state_name.contains("super"):
			continue
		var jump_state: State = state_factory.states_instance[move_name]
		pre_jump_frames = maxi(pre_jump_frames, jump_state.endFrame + 1)
	return pre_jump_frames

func _format_move_list(moves: Array[Dictionary]) -> String:
	if moves.is_empty():
		return tr("None").to_lower()

	var move_labels: PackedStringArray = []
	for index in range(mini(moves.size(), MAX_DISPLAYED_MOVES)):
		var move: Dictionary = moves[index]
		var move_name := str(move["name"])
		var display_name := str(move.get("display_name", move_name))
		move_labels.append(
			"\n %s (%df)" % [_format_display_text(display_name), move["startup"]]
		)
	if moves.size() > MAX_DISPLAYED_MOVES:
		move_labels.append("...")
	return ", ".join(move_labels)

func _format_display_text(text: String) -> String:
	text = _translate_combo_prose(text)
	var tokens = text.split(" ")
	var parts: Array[String] = []

	for token in tokens:
		if icon_paths.has(token):
			parts.append(_bbcode_icon(token))
		else:
			parts.append(token)

	return " ".join(parts)

func _translate_combo_prose(text: String) -> String:
	var matches = combo_prose_regex.search_all(text)
	if matches.is_empty():
		return text

	var translated_text := ""
	var previous_end := 0
	for regex_match in matches:
		translated_text += text.substr(
			previous_end,
			regex_match.get_start() - previous_end
		)
		translated_text += tr(regex_match.get_string())
		previous_end = regex_match.get_end()
	translated_text += text.substr(previous_end)
	return translated_text

func _bbcode_icon(name: String) -> String:
	var path: String = icon_paths.get(name, "")
	if path == "":
		return name
	return "[img width=%d height=%d]%s[/img]" % [
		button_icon_size,
		button_icon_size,
		path,
	]
