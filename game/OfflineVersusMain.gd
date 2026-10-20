extends DemoMain

class_name OfflineVersusMain

var hold_start:int = 0

func _ready() -> void:
	super._ready()
	Global.IS_TRAINING = false
	if (not $CanvasLayer/CommandList.is_connected("close_menu", Callable(self, "command_list_closed"))):
		$CanvasLayer/CommandList.connect("close_menu", Callable(self, "command_list_closed"))
		$CanvasLayer/PauseMenu.connect("close_menu", Callable(self, "_on_CloseButton_pressed"))
		$CanvasLayer/PauseMenu.connect("exit", Callable(self, "_on_ExitButton_pressed"))
		$CanvasLayer/PauseMenu.connect("command_list", Callable(self, "_on_CommandListButton_pressed"))
	game_mode_root = "/root/OfflineVersusMain/FighterGame"
	logging_enabled = false

func toggle_pause_menu():
	if ($CanvasLayer/PauseMenu.visible):
		get_tree().paused = false
		$CanvasLayer/PauseMenu.visible = false
	else:
		$CanvasLayer/PauseMenu.visible = true
		open_pause_menu()

func close_pause_menu():
	if ($CanvasLayer/PauseMenu.visible):
		get_tree().paused = false
		$CanvasLayer/PauseMenu.visible = false

func _physics_process(delta):
	if (not $CanvasLayer/PauseMenu.visible):
		if (
				Input.get_action_raw_strength("player1_start") >= 0.5 or 
				Input.get_action_raw_strength("player2_start") >= 0.5):
			hold_start += 1
			$CanvasLayer/HoldStartLabel.visible = true
			input_start()
			$CanvasLayer/HoldStartLabel.text = tr("UI_STATUS_HOLD_START")
			if (Input.get_action_raw_strength("player1_start") >= 0.5):
				$CanvasLayer/HoldStartLabel.text += "P1 "
			if (Input.get_action_raw_strength("player2_start") >= 0.5):
				$CanvasLayer/HoldStartLabel.text += "P2 "
		else:
			hold_start = 0
			$CanvasLayer/HoldStartLabel.visible = false

func _on_CloseButton_pressed():
	toggle_pause_menu()

func _on_CommandListButton_pressed():
	$CanvasLayer/CommandList.open_command_list()

func _on_ExitButton_pressed():
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/menus/characterselect/CharacterSelect.tscn")

func open_pause_menu():
	get_tree().paused = true
	$CanvasLayer/PauseMenu/CloseButton.grab_focus()

func command_list_closed():
	$CanvasLayer/CommandList.set_close_delay()
	$CanvasLayer/PauseMenu/CommandListButton.grab_focus()

func input_helper(event):
	if event.is_action_pressed("player1_start"):
		$CanvasLayer/PauseMenu/PlayerLabel.text = "P1"
		input_start()
	elif event.is_action_pressed("player2_start"):
		$CanvasLayer/PauseMenu/PlayerLabel.text = "P2"
		input_start()
	elif event.is_action_pressed("player1_cancel") or event.is_action_pressed("player2_cancel"):
		if ($CanvasLayer/CommandList.is_enabled()):
			command_list_closed()
		elif($CanvasLayer/PauseMenu.visible):
			toggle_pause_menu()

func input_start():
	if (not $CanvasLayer/CommandList.is_enabled()):
		if (hold_start >= 50):
			toggle_pause_menu()
			hold_start = 0
			$CanvasLayer/HoldStartLabel.visible = false
		else:
			close_pause_menu()
	else:
		$CanvasLayer/CommandList.set_close_delay()
