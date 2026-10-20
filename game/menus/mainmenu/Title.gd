extends Node2D

func load_startup_config():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://gamesettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Config File Error: " + str(err))
		TranslationServer.set_locale(Global.resolve_locale(config))
		return

	TranslationServer.set_locale(Global.resolve_locale(config))

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),
		config.get_value("SoundOptions", "MainVolume", 0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),
		config.get_value("SoundOptions", "MusicVolume", -10))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),
		config.get_value("SoundOptions", "SoundVolume", -10))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		config.get_value("SoundOptions", "VoiceVolume", -10) - 5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ReverbVoice"),
		config.get_value("SoundOptions", "VoiceVolume", -10) - 5)
	Global.user_display_name = config.get_value("AccountOptions", "UserDisplayName", "HH Player")
	Global.ROLLBACK_LOGS_ENABLED = config.get_value("Debug", "DebugRollbackLogsEnabled", false)
	Global.replay_logging_enabled = config.get_value("Replay", "ReplayLogsEnabled", true)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (config.get_value("Visual", "Vsync", true)) else DisplayServer.VSYNC_DISABLED)
	ProjectSettings.set_setting(
		"display/window/vsync/vsync_mode", (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED))
	if (config.get_value("Visual", "FullScreenMode", DisplayServer.WINDOW_MODE_WINDOWED) == DisplayServer.WINDOW_MODE_FULLSCREEN):
		call_deferred("full_screen_toggle", DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		call_deferred("full_screen_toggle", DisplayServer.WINDOW_MODE_WINDOWED)

func full_screen_toggle(mode):
	if (mode == DisplayServer.WINDOW_MODE_FULLSCREEN):
		if (DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func try_write_new_config_file():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://gamesettings.cfg")

	# If the file DID load, ignore it.
	if err == OK:
		return

	config = ConfigFile.new()
	print("Title: New config file")
	# Store some values.
	# param order:   section          key             value
	config.set_value("SoundOptions", "MainVolume", 0)
	config.set_value("SoundOptions", "MusicVolume", -10)
	config.set_value("SoundOptions", "SoundVolume", -10)
	config.set_value("SoundOptions", "VoiceVolume", -10)
	config.set_value("Debug", "DebugRollbackLogsEnabled", false)
	config.set_value("AccountOptions", "UserDisplayName", "HH Player")
	config.set_value("Replay", "ReplayLogsEnabled", true)
	config.set_value("Visual", "Vsync", true)
	config.set_value("Visual", "FullScreenMode", DisplayServer.WINDOW_MODE_WINDOWED)
	# Save it to a file (overwrite if already exists).
	config.save("user://gamesettings.cfg")

func _ready() -> void:
	try_write_new_config_file()
	load_startup_config()
	Util.try_create_new_controller_file()
	Util.set_input_map_ui_controls()
	#Util.print_controller_data()
	MainMenuMusicControl.stop_music()
	MainMenuMusicControl.play_title_screen_music()
	Util.init_global_input_map()
	Util.set_input_map_ui_controls()
	#Util.print_controls()
	DirAccess.make_dir_absolute(Global.LOG_FILE_DIRECTORY)
	DirAccess.make_dir_absolute(Global.REPLAY_LOG_FILE_DIRECTORY)
	
func exit():
	#print_orphan_nodes() # stops working in custom export build
	get_tree().quit()

func _input(event):
	if (event.is_action_pressed("ui_exit")):
		exit()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_pause"):
		MainMenuMusicControl.play_cursor_select()
		get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")
	
