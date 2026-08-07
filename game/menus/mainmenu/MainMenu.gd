extends Node2D

func _ready() -> void:
	MainMenuMusicControl.play_main_menu_music()
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		$CanvasLayer/MainMenuButtons/Online.grab_focus()
	else:
		$CanvasLayer/MainMenuButtons/Offline.grab_focus()
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.OFFLINE
	Global.IS_TRAINING = false
	Global.IS_REPLAY = false
	SyncManager.mechanized = false
	Global.HITBOX_DISPLAY = false
	Global.MATCH_TOTAL = 0
	Global.P1_WIN_TOTAL = 0
	Global.P1_WIN_STREAK = 0
	Global.P2_WIN_STREAK = 0
	SyncManager.set_input_delay(2)
	OnlineMatch.client_version = Global.get_battle_version()
	load_startup_config()
	$AruDJAnimator.play("Idle")

func _on_Offline_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/versus/VersusModeSelect.tscn")

func _on_Training_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/buttonmap/TrainingControllerPickMenuScreen.tscn")

func _on_Online_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/buttonmap/OnlineControllerPickMenuScreen.tscn")

func _on_Options_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/optionsmenu/Options.tscn")

func _on_Replay_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/buttonmap/ReplayControllerPickMenuScreen.tscn")

func _on_Trials_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/buttonmap/ComboTrialControllerPickMenuScreen.tscn")

func _on_Credits_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/optionsmenu/Credits.tscn")

func _on_DebugRollback_button_down():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/PortForwardIPMenu.tscn")

func _on_discord_button_down() -> void:
	OS.shell_open("https://discord.com/invite/CawzRWCNjz")

func exit():
	try_write_new_config_file()
	get_tree().change_scene_to_file("res://game/menus/mainmenu/Title.tscn")

func load_startup_config():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://gamesettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Config File Error: " + str(err))
		return
	
	Global.user_display_name = config.get_value("AccountOptions", "UserDisplayName", "HH Player")
	$CanvasLayer/YourNameEdit.text = Global.user_display_name

func try_write_new_config_file():
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	
	# Load data from a file.
	var err = config.load("user://gamesettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Config File Error: " + str(err))
		return

	var user_display_name = $CanvasLayer/YourNameEdit.text
	if (user_display_name.length() > 20):
		user_display_name = user_display_name.substr(0, 20)
	Global.user_display_name = user_display_name
	
	# Store some values.
	# param order:   section          key             value
	config.set_value("AccountOptions", "UserDisplayName", user_display_name)
	
	# Save it to a file (overwrite if already exists).
	config.save("user://gamesettings.cfg")

func _input(event):
	if (not $CanvasLayer/YourNameEdit.has_focus()):
		if event.is_action_pressed("ui_cancel"):
			exit()
