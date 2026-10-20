extends Node2D

signal combo_loaded(reset_position: String)

const COMBO_DUMMY_TEXT_KEYS := {
	"Hint: Use Jump5C as you are falling.": "UI_COMBO_HINT_FALLING_5C",
	"Hint: Use Jump5B as you are falling.": "UI_COMBO_HINT_FALLING_5B",
	"Hint: Quickly move the directions first and then press the attack button!": "UI_COMBO_HINT_DIRECTIONS",
	"Hint: You can start preparing the directions for the special move as Crouch2B is happening.": "UI_COMBO_HINT_SUBARU_SPECIAL",
	"Hint: You can start preparing the directions for the special move as Stand6C is happening.": "UI_COMBO_HINT_MIO_SPECIAL",
	"Hint: Hit up as soon as you hit the opponent!": "UI_COMBO_HINT_PRESS_UP",
	"during throw hit": "UI_COMBO_HINT_THROW_HIT",
	"Corner Only": "UI_COMBO_HINT_CORNER_ONLY",
	"Hint: try and air dash as fast as possible!": "UI_COMBO_HINT_AIR_DASH_FAST",
	"Hint: The first Jump6C requires a": "UI_COMBO_HINT_CLEAN_HIT",
	"Hint: Hatotaurus attacks when you": "UI_COMBO_HINT_HATOTAURUS_RELEASE",
	"Hint: Hit Stance D and Scissors in very quick succession": "UI_COMBO_HINT_HIT_STANCE_SCISSORS",
	"Hint: Start combo in suisei mode": "UI_COMBO_HINT_START_SUISEI",
	"Hint: AssistAttack2 when Fubuki is behind the opponent": "UI_COMBO_HINT_ASSIST_BEHIND",
	"Hint: Air throw the opponent before they groundbounce": "UI_COMBO_HINT_AIR_THROW_BOUNCE",
	"Bonus: SummonHato": "UI_COMBO_BONUS_HATO",
	"SetOllieRook then Hold A": "UI_COMBO_OLLIE_SET_HOLD",
	"AssistAttack2 Hold and Steer Right": "UI_COMBO_ASSIST_STEER_RIGHT",
	"Hold GroundThrowHit": "UI_COMBO_HOLD_GROUND_THROW",
	"Hold D": "UI_COMBO_HOLD_D",
	"Hold C": "UI_COMBO_HOLD_C",
	"Hold B": "UI_COMBO_HOLD_B",
	"hold A": "UI_COMBO_HOLD_A",
	"hold Left": "UI_COMBO_HOLD_LEFT",
	"ground bounce after each air move": "UI_COMBO_GROUND_BOUNCE",
	"delay jump": "UI_COMBO_DELAY_JUMP",
	"instant air dash": "UI_COMBO_INSTANT_AIR_DASH",
	"landing cancel": "UI_COMBO_LANDING_CANCEL",
	"double jump": "UI_COMBO_DOUBLE_JUMP",
	"airdash": "UI_COMBO_AIRDASH",
	"air dash": "UI_COMBO_AIR_DASH",
	"jump": "UI_COMBO_JUMP",
	"delay": "UI_COMBO_DELAY",
}

var ComboDatabase = load("res://game/ui/ComboTrials.gd")
var display_names: Dictionary = load("res://game/ui/ComboTrialDisplayNames.gd").DISPLAY_NAMES
var icon_paths: Dictionary = load("res://game/ui/IconPaths.gd").ICON_PATHS
var combo_trial: Dictionary = {}
var current_combo_index = 0
var current_reset_position: String = "CENTER"

var processed_combo: Array = []
var current_combo_position: int = 0
var current_step_progress: int = 0
var showing_complete_message: bool = false
var is_paused: bool = false
var auto_advance_on_complete: bool = true
var hold_completion_for_demo: bool = false

var success_bg_color: String = "#0aaa80"
var pending_bg_color: String = "#eedd22"
var pending_text_color: String = "#555555"

@onready var combo_list_label: RichTextLabel = $ComboTrialList
var button_icon_size: int = 20
var combo_prose_regex := RegEx.new()


func _ready() -> void:
	combo_prose_regex.compile("UI_COMBO_WORD_[A-Z_]+")
	combo_list_label.bbcode_enabled = true
	combo_list_label.scroll_active = false
	combo_list_label.scroll_following = false
	load_combo(0)

func load_combo(index: int) -> void:
	var trials_size = 0
	var combo_database = ComboDatabase.COMBOS
	var character_index = Global.PLAYER_2_CHARACTER[0]
	if Global.TRAINING_P1:
		character_index = Global.PLAYER_1_CHARACTER[0]
	if Global.ASSIST_COMBO_TRIAL:
		combo_database = ComboDatabase.ASSIST_COMBOS
		character_index = Global.PLAYER_2_CHARACTER[1]
		if Global.TRAINING_P1:
			character_index = Global.PLAYER_1_CHARACTER[1]
	
	
	trials_size = combo_database[character_index].size()

	if (index < 0):
		index = trials_size - 1
	elif (index >= trials_size):
		index = 0

	current_combo_index = index
	if index == trials_size:
		print("All combo trials complete!")
		return
	combo_trial = combo_database[character_index][index].duplicate()
	current_reset_position = combo_trial.get("reset_position", "CENTER")
	combo_trial.erase("reset_position")

	current_combo_position = 0
	current_step_progress = 0
	showing_complete_message = false

	refresh_combo_ui()
	combo_loaded.emit(current_reset_position)


func _process_combo() -> void:
	processed_combo.clear()

	if combo_trial.is_empty():
		return

	var keys = combo_trial.keys()
	keys.sort()

	var i := 0

	while i < keys.size():
		var current_move = combo_trial[keys[i]]
		var count := 1

		while i + count < keys.size() and combo_trial[keys[i + count]] == current_move:
			count += 1

		processed_combo.append({
			"move": current_move,
			"count": count
		})

		i += count


func _skip_dummy_steps() -> void:
	while (
		current_combo_position < processed_combo.size()
		and _is_dummy_step(str(processed_combo[current_combo_position]["move"]))
	):
		current_combo_position += 1
		current_step_progress = 0


func refresh_combo_ui() -> void:
	var is_completion_state := current_combo_position >= processed_combo.size()
	if showing_complete_message and not is_completion_state:
		return

	_process_combo()
	_skip_dummy_steps()

	var lines: Array[String] = []
	lines.append("[color=white]" + tr("UI_COMBO_INPUTS_FACING_RIGHT") + "[/color]")

	for idx in range(processed_combo.size()):
		var item = processed_combo[idx]

		var display: String

		if _is_dummy_step(item["move"]):
			display = _dummy_text(item["move"])
		else:
			display = _format_display_text(
				display_names.get(item["move"], item["move"])
			)

		if _is_dummy_step(item["move"]):
			lines.append(display)

		elif idx < current_combo_position:
			if item["count"] > 1:
				var progress_text = "%d/%d" % [item["count"], item["count"]]
				lines.append("[bgcolor="+success_bg_color+"]" + display + " (" + progress_text + ") [/bgcolor]")
			else:
				lines.append("[bgcolor="+success_bg_color+"]" + display + "[/bgcolor]")

		elif idx == current_combo_position:
			if item["count"] > 1:
				var progress_text = "%d/%d" % [
					current_step_progress,
					item["count"]
				]

				lines.append("[color="+pending_text_color+"][bgcolor="+pending_bg_color+"] " + display + " (" + progress_text + ")[/bgcolor][/color]")
			else:
				lines.append("[color="+pending_text_color+"][bgcolor="+pending_bg_color+"] " + display + "[/bgcolor][/color]")

		else:
			if item["count"] > 1:
				lines.append(
					display + " (0/" + str(item["count"]) + ")"
				)
			else:
				lines.append(display)

	combo_list_label.text = "\n".join(lines)
	var sb := combo_list_label.get_v_scroll_bar()
	await get_tree().process_frame  # let layout update first
	var target_value := sb.max_value * float(current_combo_position) / float(max(1, combo_list_label.get_line_count() - 1))
	if current_combo_position == 0 or current_combo_position == 1:
		target_value = 0
	create_tween().tween_property(sb, "value", target_value, 0.1)

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
		translated_text += text.substr(previous_end, regex_match.get_start() - previous_end)
		translated_text += tr(regex_match.get_string())
		previous_end = regex_match.get_end()
	translated_text += text.substr(previous_end)
	return translated_text


func _bbcode_icon(name: String) -> String:
	var path = icon_paths.get(name, "")

	if path == "":
		return name

	return "[img width=%d height=%d]%s[/img]"% [button_icon_size, button_icon_size, path]


func _dummy_text(step: String) -> String:
	var idx := step.find(":")

	var tail := ""
	var translated_tail := ""

	if idx >= 0:
		tail = step.substr(idx + 1).strip_edges()
	if tail.begins_with("UI_COMBO_"):
		translated_tail = tr(tail)
	else:
		for phrase in COMBO_DUMMY_TEXT_KEYS:
			if step.contains(phrase):
				translated_tail = tr(COMBO_DUMMY_TEXT_KEYS[phrase])
				break
	if not translated_tail.is_empty():
		tail = translated_tail

	var tokens = tail.split(" ")

	var parts: Array[String] = []

	for token in tokens:
		if icon_paths.has(token):
			parts.append(_bbcode_icon(token))
		elif display_names.has(token):
			parts.append(_format_display_text(display_names.get(token, token)))
		else:
			parts.append(token)

	return " ".join(parts)


func _is_dummy_step(step: String) -> bool:
	return step.begins_with("DUMMY:")


func set_paused(paused: bool) -> void:
	is_paused = paused
	if not is_paused:
		refresh_combo_ui()

func set_auto_advance_on_complete(enabled: bool) -> void:
	auto_advance_on_complete = enabled

func set_hold_completion_for_demo(hold: bool) -> void:
	hold_completion_for_demo = hold

func attack_hurt(hitbox_name: String) -> void:
	if is_paused or showing_complete_message:
		return

	print(hitbox_name)

	_skip_dummy_steps()

	if current_combo_position < processed_combo.size():
		var current_item = processed_combo[current_combo_position]

		if current_item["move"] == hitbox_name:
			current_step_progress += 1

			if current_step_progress >= current_item["count"]:
				current_combo_position += 1
				current_step_progress = 0

				_skip_dummy_steps()

				if current_combo_position >= processed_combo.size():
					showing_complete_message = true
					refresh_combo_ui()

					if auto_advance_on_complete:
						combo_list_label.text = combo_list_label.text + "\n [font_size=48] [rainbow] [wave] [b] [center]" + tr("UI_COMBO_SUCCESS")

					await get_tree().create_timer(1.5).timeout

					showing_complete_message = false

					current_combo_position = 0
					current_step_progress = 0

					var should_auto_advance := auto_advance_on_complete and not hold_completion_for_demo
					if should_auto_advance:
						load_combo(current_combo_index + 1)
					else:
						load_combo(current_combo_index)

					hold_completion_for_demo = false
					return

	refresh_combo_ui()


func drop_combo() -> void:
	if is_paused:
		return
	if current_combo_position > 0 or current_step_progress > 0:

		current_combo_position = 0
		current_step_progress = 0

	refresh_combo_ui()

func prev_trial() -> void:
	load_combo(current_combo_index - 1)

func next_trial() -> void:
	load_combo(current_combo_index + 1)
