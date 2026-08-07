extends Node2D

const ICON_PATHS: Dictionary = {
	"A": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0000.png",
	"B": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0001.png",
	"C": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0002.png",
	"D": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0003.png",

	"Up": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0005.png",
	"Right": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0007.png",
	"Down": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0009.png",
	"Left": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0011.png",

	"UpRight": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0006.png",
	"DownRight": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0008.png",
	"UpLeft": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0012.png",
	"DownLeft": "res://game/assets/sprites/UI/MainMenus/MenuTutorials/Input_0010.png",
}

var ComboDatabase = load("res://game/ui/ComboTrials.gd")
var display_names: Dictionary = load("res://game/ui/ComboTrialDisplayNames.gd").DISPLAY_NAMES
var combo_trial: Dictionary = {}
var current_combo_index = 0

var processed_combo: Array = []
var current_combo_position: int = 0
var current_step_progress: int = 0
var showing_complete_message: bool = false

var success_bg_color: String = "#0aaa80"
var pending_bg_color: String = "#eedd22"
var pending_text_color: String = "#555555"

@onready var combo_list_label: RichTextLabel = $ComboTrialList
var button_icon_size: int = 20


func _ready() -> void:
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

	current_combo_position = 0
	current_step_progress = 0
	showing_complete_message = false

	refresh_combo_ui()


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
	if showing_complete_message:
		return

	_process_combo()
	_skip_dummy_steps()

	var lines: Array[String] = []
	lines.append("[color=white]Inputs are performed while facing right[/color]")

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
	var tokens = text.split(" ")
	var parts: Array[String] = []

	for token in tokens:
		if ICON_PATHS.has(token):
			parts.append(_bbcode_icon(token))
		else:
			parts.append(token)

	return " ".join(parts)


func _bbcode_icon(name: String) -> String:
	var path = ICON_PATHS.get(name, "")

	if path == "":
		return name

	return "[img width=%d height=%d]%s[/img]"% [button_icon_size, button_icon_size, path]


func _dummy_text(step: String) -> String:
	var idx := step.find(":")

	var tail := ""

	if idx >= 0:
		tail = step.substr(idx + 1).strip_edges()

	var tokens = tail.split(" ")

	var parts: Array[String] = []

	for token in tokens:
		if ICON_PATHS.has(token):
			parts.append(_bbcode_icon(token))
		elif display_names.has(token):
			parts.append(_format_display_text(display_names.get(token, token)))
		else:
			parts.append(token)

	return " ".join(parts)


func _is_dummy_step(step: String) -> bool:
	return step.begins_with("DUMMY:")


func attack_hurt(hitbox_name: String) -> void:
	if showing_complete_message:
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

					combo_list_label.text = "[color=green] [b] COMPLETE! [/b] [/color]"

					await get_tree().create_timer(1.5).timeout

					showing_complete_message = false

					current_combo_position = 0
					current_step_progress = 0

					load_combo(current_combo_index + 1)

					return

	refresh_combo_ui()


func drop_combo() -> void:
	if current_combo_position > 0 or current_step_progress > 0:

		current_combo_position = 0
		current_step_progress = 0

	refresh_combo_ui()

func prev_trial() -> void:
	load_combo(current_combo_index - 1)

func next_trial() -> void:
	load_combo(current_combo_index + 1)
