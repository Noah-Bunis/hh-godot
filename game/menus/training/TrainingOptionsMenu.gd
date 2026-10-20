extends GridContainer

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

var menu_close_delay: int
var most_recent_focus:Control

var command_list

var assist_build_option: bool = false
var meter_reset_option: bool = true

func _on_focus_changed(control:Control) -> void:
	#if control is PopupMenu:
		#return
	if control != null:
		most_recent_focus = control

func _ready():
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
	
	$SyncRate.value = Util.BASE_SYNC_RATE / SGFixed.ONE

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
