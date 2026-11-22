extends PanelContainer

class_name PunishAnalysis

const MAX_DISPLAYED_MOVES := 25
const COMBO_TRIAL_DISPLAY_NAMES = preload("res://game/ui/ComboTrialDisplayNames.gd")
const ASSIST_CALL_STATES := [
	"AssistAttack",
	"AssistAttack2",
	"AssistAirAttack",
	"AssistAirAttack2",
	"AssistSuper",
	"AssistAirSuper"
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
	"FiftyKGHit",
	"FiftyKGAirHit",
	"SuperFiftyKGHit",
	"SuperfiftyKGRekkaA",
	"GroundThrowHit",
	"GroundBackThrowHit",
	"AirThrowHit",
	"AirBackThrowHit",
	"AngelGroundThrowHit",
	"AngelGroundBackThrowHit",
	"AngelAirThrowHit",
	"AngelAirBackThrowHit",

]

@onready var _output: RichTextLabel = $Output

var icon_paths: Dictionary = load("res://game/ui/IconPaths.gd").ICON_PATHS
var button_icon_size := 20
var combo_prose_regex := RegEx.new()

var _enabled := false
var _last_state_property_snapshot: Dictionary = {}
var _has_last_state_property_snapshot := false
var _best_punish_window := -1
var _neutral_hold_active := false
var _neutral_hold_reached_both := false
var _tracked_suisei_instance_id := 0
var _suisei_suicopath_stance := false

func _ready() -> void:
	combo_prose_regex.compile("UI_COMBO_WORD_[A-Z_]+")
	visible = false

func set_enabled(is_enabled: bool) -> void:
	if _enabled == is_enabled:
		return
	_enabled = is_enabled
	reset_analysis()

func update_analysis(player: BasePlayer, assist: BasePlayer, opponent: BasePlayer) -> void:
	if (
		not is_instance_valid(player)
		or not is_instance_valid(assist)
		or not is_instance_valid(opponent)
	):
		reset_analysis()
		return

	_update_suisei_stance(player)
	var state_property_snapshot := {
		"player": _get_entity_snapshot(player),
		"assist": _get_entity_snapshot(assist),
		"opponent": _get_entity_snapshot(opponent),
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
	var left_neutral_after_hold := (
		_neutral_hold_active
		and _neutral_hold_reached_both
		and was_both_neutral
		and not are_both_neutral
	)
	if left_neutral_after_hold:
		_neutral_hold_active = false
		_neutral_hold_reached_both = false
	elif visible and entered_neutral:
		_neutral_hold_active = true
	if _neutral_hold_active and are_both_neutral:
		_neutral_hold_reached_both = true

	_last_state_property_snapshot = state_property_snapshot
	_has_last_state_property_snapshot = true
	if left_neutral_after_hold:
		_best_punish_window = -1
		visible = false
	elif state_or_property_changed and not _neutral_hold_active:
		_best_punish_window = -1
		visible = false

	if _neutral_hold_active and _neutral_hold_reached_both:
		return

	var opponent_state := _get_current_state(opponent)
	if opponent_state == null or _has_projectile_summon(opponent_state):
		return

	var recovery_frames := _get_recovery_frames(opponent, opponent_state)
	if recovery_frames <= 0:
		return

	var player_delay := _get_action_delay(player)
	var punish_window := maxi(recovery_frames - player_delay, 0)
	if punish_window <= _best_punish_window:
		return
	_best_punish_window = punish_window

	var air_move_startup_delay := _get_air_move_startup_delay(player)
	var player_moves := _get_punish_moves(
		player,
		punish_window,
		false,
		air_move_startup_delay
	)
	var assist_available := (
		assist.fighterState != null
		and assist.has_property(Enums.StateProperty.DormantAssist)
	)
	var assist_moves: Array[Dictionary] = []
	if assist_available:
		assist_moves = _get_punish_moves(
			assist,
			punish_window,
			true,
			air_move_startup_delay
		)

	if player_moves.is_empty() and assist_moves.is_empty():
		_output.text = ""
		visible = false
		return

	var lines: Array[String] = [
		"[b]Best punish window - %d Frames[/b]" % punish_window,
		"[b]Player[/b]: %s" % _format_move_list(player_moves),
	]
	if assist_available:
		lines.append("[b]Assist[/b]: %s" % _format_move_list(assist_moves))
	else:
		lines.append("[b]Assist[/b]: unavailable")
	lines.append("Only startup speed is checked; effective range may vary.")

	_output.text = "\n".join(lines)
	visible = _enabled

func reset_analysis() -> void:
	_last_state_property_snapshot.clear()
	_has_last_state_property_snapshot = false
	_best_punish_window = -1
	_neutral_hold_active = false
	_neutral_hold_reached_both = false
	visible = false

func _get_punish_moves(
	entity: BasePlayer,
	startup_budget: int,
	is_assist: bool = false,
	air_move_startup_delay: int = 0
) -> Array[Dictionary]:
	var moves: Array[Dictionary] = []
	if startup_budget <= 0 or entity.fighterState == null:
		return moves

	var state_factory: StateFactory = entity.fighterState.state_factory
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
		if is_suisei:
			if _suisei_suicopath_stance:
				if not is_angel_move and not is_suicopath_only_move:
					continue
			elif is_angel_move or is_suicopath_only_move:
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
		if _has_projectile_summon(move_state):
			continue
		var timing := _get_attack_timing(move_state)
		if timing.is_empty():
			continue
		var startup: int = timing["startup"]
		if move_state is AirAttackState:
			startup += air_move_startup_delay
		if startup > startup_budget:
			continue
		moves.append({
			"name": move_name_string,
			"display_name": COMBO_TRIAL_DISPLAY_NAMES.get_display_name(
				display_character_name,
				move_name_string
			),
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
	if (
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

func _get_recovery_frames(entity: BasePlayer, state: State) -> int:
	var current_frame: int = entity.currentState.get(Enums.StKey.frame, 0)
	if current_frame > state.endFrame:
		return 0
	if _is_landing_recovery_state(
		str(entity.currentState.get(Enums.StKey.stateName, ""))
	):
		return maxi(state.endFrame - current_frame + 1, 0)
	if not (state is AttackState or state is AirAttackState):
		return 0

	var timing := _get_attack_timing(state)
	if timing.is_empty() or current_frame <= timing["last_active_frame"]:
		return 0
	return maxi(state.endFrame - current_frame + 1, 0)

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

func _get_attack_timing(move_state: State) -> Dictionary:
	if move_state.anim_data == null or move_state.anim_data.is_empty():
		return {}

	var animation_frames: Array = move_state.anim_data.keys()
	animation_frames.sort()
	var first_active_frame := -1
	var last_active_frame := -1

	for index in range(animation_frames.size()):
		var frame: int = int(animation_frames[index])
		if frame > move_state.endFrame:
			break
		var frame_data: Dictionary = move_state.anim_data[frame]
		var hitbox_active: bool = (
			not frame_data.get(Enums.StKey.Hit1Disable, true)
			or not frame_data.get(Enums.StKey.Hit2Disable, true)
		)
		if not hitbox_active:
			continue

		var active_frame := maxi(frame, 0)
		if first_active_frame < 0:
			first_active_frame = active_frame
		var active_until := active_frame
		if hitbox_active:
			active_until = move_state.endFrame
			if index + 1 < animation_frames.size():
				active_until = mini(
					active_until,
					int(animation_frames[index + 1]) - 1
				)
		last_active_frame = maxi(last_active_frame, active_until)

	if first_active_frame < 0:
		return {}
	return {
		"startup": first_active_frame + 1,
		"last_active_frame": last_active_frame,
	}

func _get_current_state(entity: BasePlayer) -> State:
	if entity.fighterState == null:
		return null
	return entity.fighterState.state

func _get_action_delay(entity: BasePlayer) -> int:
	if entity.fighterState == null:
		return 0
	var state: State = entity.fighterState.state
	if entity.currentState.get(Enums.StKey.hitstun, 0) > 0:
		return int(entity.currentState[Enums.StKey.hitstun])
	if state is AttackState or state is AirAttackState:
		return maxi(
			state.endFrame - int(entity.currentState.get(Enums.StKey.frame, 0)) + 1,
			0
		)
	return 0

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
		return "none"

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
