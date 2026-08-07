extends GridContainer

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
	most_recent_focus = $SaveStateButton
	
	$BlockOptions.add_item("NONE", Enums.TrainingBlock.NONE)
	$BlockOptions.add_item("ALL", Enums.TrainingBlock.ALL)
	
	$BlockSwitchOptions.add_item("ENABLED", Enums.TrainingBlockSwitch.ENABLED)
	$BlockSwitchOptions.add_item("DISABLED", Enums.TrainingBlockSwitch.DISABLED)
	
	$BlockTypeOptions.add_item("NONE", Enums.TrainingBlockType.NONE)
	$BlockTypeOptions.add_item("NORMAL BLOCK", Enums.TrainingBlockType.NORMAL)
	$BlockTypeOptions.add_item("INSTANT BLOCK", Enums.TrainingBlockType.IB)
	$BlockTypeOptions.add_item("PUSH BLOCK", Enums.TrainingBlockType.FD)
	$BlockTypeOptions.add_item("INSTANT PUSH BLOCK", Enums.TrainingBlockType.IFD)
	$BlockTypeOptions.add_item("PARRY", Enums.TrainingBlockType.PARRY)
	
	$RecoveryOptions.add_item("NEUTRAL", Enums.TrainingRecovery.NEUTRAL)
	$RecoveryOptions.add_item("FORWARD", Enums.TrainingRecovery.FORWARD)
	$RecoveryOptions.add_item("BACKWARD", Enums.TrainingRecovery.BACKWARD)
	$RecoveryOptions.add_item("OFF", Enums.TrainingRecovery.OFF)
	
	$CounterHitOptions.add_item("OFF", Enums.TrainingCounterHit.OFF)
	$CounterHitOptions.add_item("ON", Enums.TrainingCounterHit.ON)
	$CounterHitOptions.add_item("HAPPY BIRTHDAY", Enums.TrainingCounterHit.ASSIST_DANGER)
	
	$StanceOptions.add_item("STAND", Enums.TrainingStance.STAND)
	$StanceOptions.add_item("CROUCH", Enums.TrainingStance.CROUCH)
	$StanceOptions.add_item("JUMP", Enums.TrainingStance.JUMP)
	
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
			most_recent_focus = $SaveStateButton
		most_recent_focus.grab_focus()
	
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

func command_list_closed():
	$CommandListButton.grab_focus()

func _input(event):
	input_helper(event)

func input_helper(event):
	if event.is_action_pressed("player1_start") or event.is_action_pressed("player2_start"):
		if (not command_list.is_enabled()):
			_on_CloseButton_pressed()
	elif event.is_action_pressed("player1_cancel") or event.is_action_pressed("player2_cancel"):
		if (not command_list.is_enabled()):
			_on_CloseButton_pressed()

func _on_hide_hitboxes_button_pressed() -> void:
	Global.TRAINING_HITBOX_ON = not Global.TRAINING_HITBOX_ON

func get_assist_build_option() -> bool:
	return assist_build_option

func _on_AssistBuildButton_pressed() -> void:
	assist_build_option = not assist_build_option
	if (assist_build_option):
		$AssistBuildButton.text = "ON"
	else:
		$AssistBuildButton.text = "OFF"

func get_meter_reset_option() -> bool:
	return meter_reset_option

func _on_MeterResetButton_pressed() -> void:
	meter_reset_option = not meter_reset_option
	if (meter_reset_option):
		$MeterResetButton.text = "ON"
	else:
		$MeterResetButton.text = "OFF"
