extends Node2D

# Called when the node enters the scene tree for the first time.

# holoheavenbugreport@gmail.com

var Main_volume = 0
var BGM_volume = -10
var Sound_volume = -10
var Voice_volume = -10
var DebugRollbackLogsEnabled: bool = false

func _ready():
	load_startup_config()
	$CanvasLayer/Options/FullScreenButton.grab_focus()
	$CanvasLayer/Options/VsyncEmpty.text = bool_to_on_off_string(DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED)
	$CanvasLayer/Options/MainVolumeMeter.value = db_conversion(Main_volume, $CanvasLayer/Options/MainVolumeMeter.max_value)
	$CanvasLayer/Options/MusicVolumeMeter.value = db_conversion(BGM_volume, $CanvasLayer/Options/MusicVolumeMeter.max_value)
	$CanvasLayer/Options/SoundVolumeMeter.value = db_conversion(Sound_volume, $CanvasLayer/Options/SoundVolumeMeter.max_value)
	$CanvasLayer/Options/VoiceVolumeMeter.value = db_conversion(Voice_volume, $CanvasLayer/Options/VoiceVolumeMeter.max_value)
	$CanvasLayer/Options/VersionLabelReadout.text = Global.BATTLE_ENGINE_VERSION
	update_debug_rollback_log()
	replay_text_update()

func db_conversion(internal_volume, meter_max):
	return (internal_volume * 2) + meter_max

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_GoBackButton_pressed()

func _on_FullScreenButton_pressed():
	print (DisplayServer.window_get_mode())
	if (DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	ProjectSettings.save_custom("override.cfg")

func _on_VsyncButton_pressed():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (not (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED)) else DisplayServer.VSYNC_DISABLED)
	ProjectSettings.set_setting(
		"display/window/vsync/vsync_mode", (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED))
	$CanvasLayer/Options/VsyncEmpty.text = bool_to_on_off_string(DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED)
	ProjectSettings.save_custom("override.cfg")

func bool_to_on_off_string(input_bool: bool):
	if (input_bool):
		return "ON"
	else:
		return "OFF"

func _on_ResetButton_pressed():
	_on_MainVolumeMeter_value_changed(0 + $CanvasLayer/Options/MainVolumeMeter.max_value)
	_on_MusicVolumeMeter_value_changed(-10 + $CanvasLayer/Options/MusicVolumeMeter.max_value)
	_on_SoundVolumeMeter_value_changed(-10 + $CanvasLayer/Options/SoundVolumeMeter.max_value)
	_on_VoiceVolumeMeter_value_changed(-10 + $CanvasLayer/Options/VoiceVolumeMeter.max_value)
	
	if (((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))):
		_on_FullScreenButton_pressed()
	if (not (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED)):
		_on_VsyncButton_pressed()
	if (Global.ROLLBACK_LOGS_ENABLED):
		_on_DebugRollbackLogsButton_pressed()
	if (not Global.replay_logging_enabled):
		_on_ReplayLogsButton_pressed()

func _on_ReplayLogsButton_pressed():
	Global.replay_logging_enabled = not Global.replay_logging_enabled
	replay_text_update()

func replay_text_update():
	if (Global.replay_logging_enabled):
		$CanvasLayer/Options/ReplayLogsEmpty.text = "ON"
	else:
		$CanvasLayer/Options/ReplayLogsEmpty.text = "OFF"

func _on_GoBackButton_pressed():
	get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")
	Util.write_to_config_file("SoundOptions", "MainVolume", Main_volume)
	Util.write_to_config_file("SoundOptions", "MusicVolume", BGM_volume)
	Util.write_to_config_file("SoundOptions", "SoundVolume", Sound_volume)
	Util.write_to_config_file("SoundOptions", "VoiceVolume", Voice_volume)
	Util.write_to_config_file("Debug", "DebugRollbackLogsEnabled", DebugRollbackLogsEnabled)
	Util.write_to_config_file("Visual", "Vsync", (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED))
	#Util.write_to_config_file("Visual", "FullScreenMode", (ProjectSettings.get_setting("display/window/size/fullscreen")))
	Util.write_to_config_file("Visual", "FullScreenMode", (DisplayServer.window_get_mode()))
	Util.write_to_config_file("Replay", "ReplayLogsEnabled", Global.replay_logging_enabled)

func _on_MainVolumeMeter_value_changed(value):
	$CanvasLayer/Options/MainVolumeMeter.value = value
	Main_volume = volume_meter_change("Master", $CanvasLayer/Options/MainVolumeMeter)
func _on_MusicVolumeMeter_value_changed(value):
	$CanvasLayer/Options/MusicVolumeMeter.value = value
	BGM_volume = volume_meter_change("Music", $CanvasLayer/Options/MusicVolumeMeter)
func _on_SoundVolumeMeter_value_changed(value):
	$CanvasLayer/Options/SoundVolumeMeter.value = value
	Sound_volume = volume_meter_change("Sound", $CanvasLayer/Options/SoundVolumeMeter)
func _on_VoiceVolumeMeter_value_changed(value):
	$CanvasLayer/Options/VoiceVolumeMeter.value = value
	Voice_volume = volume_meter_change("Voice", $CanvasLayer/Options/VoiceVolumeMeter, -5)
	Voice_volume = volume_meter_change("ReverbVoice", $CanvasLayer/Options/VoiceVolumeMeter, -5)

func volume_meter_change(bus, meter, modify=0):
	var volume = (meter.value - meter.max_value) / 2
	if meter.value <= meter.min_value + 0.1:
		volume = -100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), volume + modify)
	return volume

func _on_DebugRollbackLogsButton_pressed():
	DebugRollbackLogsEnabled = not DebugRollbackLogsEnabled
	Global.ROLLBACK_LOGS_ENABLED = DebugRollbackLogsEnabled
	update_debug_rollback_log()

func update_debug_rollback_log():
	if (DebugRollbackLogsEnabled):
		$CanvasLayer/Options/DebugRollbackLogsEmpty.text = "ON, Warning: log files take up lots of storage space!"
	else:
		$CanvasLayer/Options/DebugRollbackLogsEmpty.text = "OFF, if you want to help catch rollback desyncs, enable this"

func _on_GetLogsDirButton_pressed():
	DisplayServer.clipboard_set(ProjectSettings.globalize_path("user://"))
	$CanvasLayer/Options/GetLogDirEmpty.text = "Copied file path"

func _on_ClearControlsButton_pressed() -> void:
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://controllersettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Load: Controller Config File Error: " + str(err))
		return
	
	config.clear()
	config.save("user://controllersettings.cfg")
	$CanvasLayer/Options/ClearControlsEmpty.text = "Cleared controllersettings.cfg"
	
	Util.try_create_new_controller_file()
	Util.set_input_map_ui_controls()
	Util.init_global_input_map()

func load_startup_config():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://gamesettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Config File Error: " + str(err))
		return
	
	Main_volume = config.get_value("SoundOptions", "MainVolume", 0)
	BGM_volume = config.get_value("SoundOptions", "MusicVolume", -10)
	Sound_volume = config.get_value("SoundOptions", "SoundVolume", -10)
	Voice_volume = config.get_value("SoundOptions", "VoiceVolume", -10)
	DebugRollbackLogsEnabled = config.get_value("Debug", "DebugRollbackLogsEnabled", false)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (config.get_value("Visual", "Vsync", true)) else DisplayServer.VSYNC_DISABLED)
	Global.replay_logging_enabled = config.get_value("Replay", "ReplayLogsEnabled", true)
	ProjectSettings.set_setting(
		"display/window/vsync/vsync_mode", (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED))
