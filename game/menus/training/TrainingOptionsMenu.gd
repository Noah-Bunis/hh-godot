extends GridContainer

const VIEWPORT_MARGIN := 32.0

@onready var BUTTON_MAP_MENU = preload("res://game/menus/buttonmap/ButtonMapMenuScreen.tscn")
var button_menu
var button_map_paused_before_open: bool
var last_input_event: InputEvent
var command_list_input_was_enabled: bool
var command_list_physics_was_enabled: bool

signal close_menu()
signal exit()
signal reset()
signal savestate()
signal loadstate()
signal play_demo()
signal move_data_toggled(is_visible: bool)

var menu_close_delay: int
var most_recent_focus:Control

var command_list

var assist_build_option: bool = false
var meter_reset_option: bool = true
var move_data_visible: bool = false

var _base_position: Vector2
var _base_scale: Vector2
var _base_size: Vector2
var _character_settings_popup_preferred_size: Vector2i
var _layout_ready := false
var _closing_training_options_menu := false

@onready var character_settings_popup: PopupPanel = get_node(
	"../CharacterSettingsPopup"
)

func _on_focus_changed(control:Control) -> void:
	#if control is PopupMenu:
		#return
	if control != null:
		most_recent_focus = control

func _ready():
	_base_position = position
	_base_scale = scale
	_base_size = size
	_character_settings_popup_preferred_size = character_settings_popup.size
	_layout_ready = true
	get_viewport().size_changed.connect(_fit_to_viewport)
	get_viewport().connect("gui_focus_changed", Callable(self, "_on_focus_changed"))
	most_recent_focus = get_default_focus()
	
	$BlockOptions.add_item(tr("UI_TRAINING_NONE"), Enums.TrainingBlock.NONE)
	$BlockOptions.add_item(tr("UI_TRAINING_ALL"), Enums.TrainingBlock.ALL)
	
	$BlockSwitchOptions.add_item(tr("UI_TRAINING_ENABLED"), Enums.TrainingBlockSwitch.ENABLED)
	$BlockSwitchOptions.add_item(tr("UI_TRAINING_DISABLED"), Enums.TrainingBlockSwitch.DISABLED)
	
	$BlockTypeOptions.add_item(tr("UI_TRAINING_NONE"), Enums.TrainingBlockType.NONE)
	$BlockTypeOptions.add_item(tr("UI_TRAINING_NORMAL_BLOCK"), Enums.TrainingBlockType.NORMAL)
	$BlockTypeOptions.add_item(tr("UI_TRAINING_INSTANT_BLOCK"), Enums.TrainingBlockType.IB)
	$BlockTypeOptions.add_item(tr("UI_TRAINING_PUSH_BLOCK"), Enums.TrainingBlockType.FD)
	$BlockTypeOptions.add_item(tr("UI_TRAINING_INSTANT_PUSH_BLOCK"), Enums.TrainingBlockType.IFD)
	$BlockTypeOptions.add_item(tr("UI_TRAINING_PARRY"), Enums.TrainingBlockType.PARRY)
	
	$RecoveryOptions.add_item(tr("UI_TRAINING_NEUTRAL"), Enums.TrainingRecovery.NEUTRAL)
	$RecoveryOptions.add_item(tr("UI_TRAINING_FORWARD"), Enums.TrainingRecovery.FORWARD)
	$RecoveryOptions.add_item(tr("UI_TRAINING_BACKWARD"), Enums.TrainingRecovery.BACKWARD)
	$RecoveryOptions.add_item(tr("UI_TRAINING_OFF"), Enums.TrainingRecovery.OFF)
	
	$CounterHitOptions.add_item(tr("UI_TRAINING_OFF"), Enums.TrainingCounterHit.OFF)
	$CounterHitOptions.add_item(tr("UI_TRAINING_ON"), Enums.TrainingCounterHit.ON)
	$CounterHitOptions.add_item(tr("UI_TRAINING_HAPPY_BIRTHDAY"), Enums.TrainingCounterHit.ASSIST_DANGER)
	
	$StanceOptions.add_item(tr("UI_TRAINING_STAND"), Enums.TrainingStance.STAND)
	$StanceOptions.add_item(tr("UI_TRAINING_CROUCH"), Enums.TrainingStance.CROUCH)
	$StanceOptions.add_item(tr("UI_TRAINING_JUMP"), Enums.TrainingStance.JUMP)

	for options in [
		$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/PlayerCharacterOptions",
		$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/OpponentCharacterOptions",
	]:
		options.add_item("Oozora Subaru", Enums.PointCharacters.Subaru)
		options.add_item("Ookami Mio", Enums.PointCharacters.Mio)
		options.add_item("Aragami Oga", Enums.PointCharacters.Oga)
		options.add_item("Kureiji Ollie", Enums.PointCharacters.Ollie)
		options.add_item("Hoshimachi Suisei", Enums.PointCharacters.Suisei)
		options.add_item("Amane Kanata", Enums.PointCharacters.Kanata)
		options.add_item("Machina X Flayon", Enums.PointCharacters.Flayon)

	for options in [
		$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/PlayerAssistOptions",
		$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/OpponentAssistOptions",
	]:
		options.add_item("Shirakami Fubuki", Enums.AssistCharacters.Fubuki)
		options.add_item("Tokino Sora", Enums.AssistCharacters.Sora)
		options.add_item("Tsukumo Sana", Enums.AssistCharacters.Sana)
		options.add_item("OkaKoro", Enums.AssistCharacters.OkaKoro)
		options.add_item("Banzoin Hakka", Enums.AssistCharacters.Hakka)
		options.add_item("Rikka", Enums.AssistCharacters.Rikka)
		options.add_item("Oozora Subaru", Enums.AssistCharacters.Subaru)
		options.add_item("Ookami Mio", Enums.AssistCharacters.Mio)
		options.add_item("Aragami Oga", Enums.AssistCharacters.Oga)
		options.add_item("Kureiji Ollie", Enums.AssistCharacters.Ollie)
		options.add_item("Hoshimachi Suisei", Enums.AssistCharacters.Suisei)
		options.add_item("Amane Kanata", Enums.AssistCharacters.Kanata)
		options.add_item("Machina X Flayon", Enums.AssistCharacters.Flayon)

	$CharacterSettingsButton.pressed.connect(open_character_settings_popup)
	$"../CharacterSettingsPopup/Layout/CloseButton".pressed.connect(
		Callable(character_settings_popup, "hide")
	)
	character_settings_popup.popup_hide.connect(
		_on_character_settings_popup_hidden
	)
	
	$SyncRate.value = Util.BASE_SYNC_RATE / SGFixed.ONE
	call_deferred("_fit_to_viewport")

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and _layout_ready:
		call_deferred("_fit_to_viewport")

func _fit_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var margin := minf(VIEWPORT_MARGIN, minf(viewport_size.x, viewport_size.y) * 0.05)
	var available_size := viewport_size - Vector2.ONE * margin * 2.0
	var content_size := _base_size.max(get_combined_minimum_size())
	var base_display_size := content_size * _base_scale
	var fit_scale := minf(
		1.0,
		minf(available_size.x / base_display_size.x, available_size.y / base_display_size.y)
	)

	size = content_size
	scale = _base_scale * fit_scale
	var displayed_size := content_size * scale
	position = Vector2(
		clampf(_base_position.x, margin, viewport_size.x - displayed_size.x - margin),
		clampf(_base_position.y, margin, viewport_size.y - displayed_size.y - margin)
	)

func _physics_process(delta):
	if menu_close_delay > 0:
		menu_close_delay -= 1
		if (menu_close_delay == 0):
			close_training_options_menu()

func open_training_options_menu():
	if (not is_enabled()):
		self.visible = true
		if (most_recent_focus == null):
			most_recent_focus = get_default_focus()
		most_recent_focus.grab_focus()

func get_default_focus() -> Control:
	var save_state_button = get_node_or_null("SaveStateButton") as Control
	if (save_state_button != null):
		return save_state_button
	return get_node_or_null("PlayDemoButton") as Control
	
func set_close_delay():
	if (is_enabled()):
		menu_close_delay = 2
	
func close_training_options_menu():
	if (is_enabled()):
		_closing_training_options_menu = true
		character_settings_popup.hide()
		_closing_training_options_menu = false
		self.visible = false
		emit_signal("close_menu")

func is_enabled() -> bool:
	return self.visible

func get_super_meter() -> int:
	var meter: int = SGFixed.mul(SGFixed.from_float($SuperMeter.get_value() / 100.0), Util.LEVEL_ONE_SUPER)
	return meter

func get_assist_meter() -> int:
	var meter: int = SGFixed.mul(SGFixed.from_float($AssistMeter.get_value() / 100.0), Util.ASSIST_STOCK)
	return meter

func get_sync_rate() -> int:
	var meter: int = SGFixed.mul(SGFixed.from_float($SyncRate.get_value()), 65536)
	return meter

func get_stance() -> int:
	return $StanceOptions.selected

func open_character_settings_popup() -> void:
	var viewport_rect := get_viewport().get_visible_rect()
	var margin := minf(48.0, minf(viewport_rect.size.x, viewport_rect.size.y) * 0.05)
	var available_size := Vector2i(
		viewport_rect.size - Vector2(margin, margin * 2.0)
	)
	var popup_scale := minf(
		scale.y,
		minf(
			float(available_size.x) / _character_settings_popup_preferred_size.x,
			float(available_size.y) / _character_settings_popup_preferred_size.y
		)
	)
	var popup_size := Vector2i(
		_character_settings_popup_preferred_size.x * popup_scale,
		_character_settings_popup_preferred_size.y * popup_scale
	)
	var layout := character_settings_popup.get_node("Layout") as Control
	layout.set_anchors_preset(Control.PRESET_TOP_LEFT)
	layout.position = Vector2(4.0, 4.0)
	layout.size = Vector2(
		_character_settings_popup_preferred_size.x - 8.0,
		_character_settings_popup_preferred_size.y - 8.0
	)
	layout.scale = Vector2.ONE * popup_scale

	var popup_position := Vector2i(
		roundi(viewport_rect.position.x + viewport_rect.size.x - popup_size.x),
		roundi(viewport_rect.position.y + (viewport_rect.size.y - popup_size.y) * 0.5)
	)
	character_settings_popup.popup(Rect2i(popup_position, popup_size))
	$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/PlayerCharacterOptions".call_deferred(
		"grab_focus"
	)

func _on_character_settings_popup_hidden() -> void:
	most_recent_focus = $CharacterSettingsButton
	if not _closing_training_options_menu:
		emit_signal("close_menu")
		emit_signal("reset")
	call_deferred("_restore_character_settings_focus")

func _restore_character_settings_focus() -> void:
	if is_enabled() and not character_settings_popup.visible:
		$CharacterSettingsButton.grab_focus()

func get_training_character(is_p1: bool, is_assist: bool) -> int:
	var side_name := "Player" if is_p1 else "Opponent"
	var slot_name := "Assist" if is_assist else "Character"
	var options := character_settings_popup.get_node(
		"Layout/CharacterSettingsGrid/%s%sOptions" % [side_name, slot_name]
	) as OptionButton
	return options.get_selected_id()

func set_training_character(is_p1: bool, is_assist: bool, character: int) -> void:
	var side_name := "Player" if is_p1 else "Opponent"
	var slot_name := "Assist" if is_assist else "Character"
	var options := character_settings_popup.get_node(
		"Layout/CharacterSettingsGrid/%s%sOptions" % [side_name, slot_name]
	) as OptionButton
	for index in range(options.item_count):
		if options.get_item_id(index) == character:
			options.select(index)
			return

func get_counter_hit() -> int:
	return $CounterHitOptions.selected

func get_blocking() -> int:
	if ($BlockTypeOptions.selected == 0):
		return Enums.TrainingBlock.NONE
	else:
		return Enums.TrainingBlock.ALL

func get_block_switch() -> int:
	return $BlockSwitchOptions.selected

func get_block_type() -> int:
	return $BlockTypeOptions.selected

func get_air_recovery() -> int:
	return $RecoveryOptions.selected

func _on_ExitButton_pressed():
	emit_signal("exit")

func _on_ResetButton_pressed():
	emit_signal("reset")

func _on_SaveStateButton_pressed():
	emit_signal("savestate")

func _on_LoadStateButton_pressed():
	emit_signal("loadstate")

func _on_PlayDemoButton_pressed():
	emit_signal("play_demo")

func _on_CloseButton_pressed():
	set_close_delay()

func _on_CommandListButton_pressed():
	command_list.open_command_list()

func _on_ChangeControlsButton_pressed() -> void:
	button_map_paused_before_open = get_tree().paused
	button_menu = BUTTON_MAP_MENU.instantiate()
	button_menu.configure_single_player(last_input_event, Global.TRAINING_P1)
	set_process_input(false)
	command_list_input_was_enabled = command_list.is_processing_input()
	command_list_physics_was_enabled = command_list.is_physics_processing()
	command_list.set_process_input(false)
	command_list.set_physics_process(false)
	var focus_owner = get_viewport().gui_get_focus_owner()
	if (focus_owner != null):
		focus_owner.release_focus()
	get_parent().add_child(button_menu)
	button_menu.connect("complete", Callable(self, "button_set_complete"))

func button_set_complete() -> void:
	get_tree().paused = button_map_paused_before_open
	button_menu.disconnect("complete", Callable(self, "button_set_complete"))
	button_menu.queue_free()
	button_menu = null
	set_process_input(true)
	command_list.set_process_input(command_list_input_was_enabled)
	command_list.set_physics_process(command_list_physics_was_enabled)
	$ChangeControlsButton.call_deferred("grab_focus")

func command_list_closed():
	$CommandListButton.grab_focus()

func _input(event):
	last_input_event = event
	input_helper(event)

func input_helper(event):
	if character_settings_popup.visible:
		if (
			event.is_action_pressed("player1_start")
			or event.is_action_pressed("player2_start")
			or event.is_action_pressed("player1_cancel")
			or event.is_action_pressed("player2_cancel")
			or event.is_action_pressed("menu_back_b")
		):
			for options in [
				$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/PlayerCharacterOptions",
				$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/PlayerAssistOptions",
				$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/OpponentCharacterOptions",
				$"../CharacterSettingsPopup/Layout/CharacterSettingsGrid/OpponentAssistOptions",
			]:
				if options.get_popup().visible:
					return
			character_settings_popup.hide()
		return

	if event.is_action_pressed("player1_start") or event.is_action_pressed("player2_start"):
		if (not command_list.is_enabled()):
			_on_CloseButton_pressed()
	elif event.is_action_pressed("player1_cancel") or event.is_action_pressed("player2_cancel") or event.is_action_pressed("menu_back_b"):
		if (not command_list.is_enabled()):
			_on_CloseButton_pressed()

func _on_hide_hitboxes_button_pressed() -> void:
	Global.TRAINING_HITBOX_ON = not Global.TRAINING_HITBOX_ON

func get_assist_build_option() -> bool:
	return assist_build_option

func _on_AssistBuildButton_pressed() -> void:
	assist_build_option = not assist_build_option
	if (assist_build_option):
		$AssistBuildButton.text = tr("UI_TRAINING_ON")
	else:
		$AssistBuildButton.text = tr("UI_TRAINING_OFF")

func get_meter_reset_option() -> bool:
	return meter_reset_option

func _on_MeterResetButton_pressed() -> void:
	meter_reset_option = not meter_reset_option
	if (meter_reset_option):
		$MeterResetButton.text = tr("UI_TRAINING_ON")
	else:
		$MeterResetButton.text = tr("UI_TRAINING_OFF")

func _on_MoveDataButton_pressed() -> void:
	move_data_visible = not move_data_visible
	$MoveDataButton.text = tr("UI_TRAINING_ON") if move_data_visible else tr("UI_TRAINING_OFF")
	move_data_toggled.emit(move_data_visible)
