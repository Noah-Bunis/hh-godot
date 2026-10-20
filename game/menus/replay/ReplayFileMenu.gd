extends Node2D

const REPLAY_LOG_FILE_DIRECTORY := 'user://replay_logs'
var most_recent_focus
var delete_mode: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents()
	get_viewport().connect("gui_focus_changed", Callable(self, "_on_focus_changed"))
	$Earthbound2.modulate = Color("#0f4252")
	Global.IS_REPLAY = true

func _on_focus_changed(control:Control) -> void:
	if control != null:
		most_recent_focus = control

func make_replay_item(file_name):
	var newButton = Button.new()
	newButton.text = file_name
	$CanvasLayer/GridContainer/GridContainer.add_child(newButton, InternalMode.INTERNAL_MODE_BACK)
	if (most_recent_focus == null):
		most_recent_focus = newButton
		newButton.grab_focus()

func delete_replay(button: Button):
	if (button == $CanvasLayer/GridContainer/GridContainer/DeleteModeButton):
		return
	create_replay_dir_if_empty()
	var dir = DirAccess.open(REPLAY_LOG_FILE_DIRECTORY)
	if dir:
		if (len(button.text) <= 50):
			if dir.remove(REPLAY_LOG_FILE_DIRECTORY+"/"+str(button.text)) == OK:
				most_recent_focus = $CanvasLayer/GridContainer/GridContainer/DeleteModeButton
				most_recent_focus.grab_focus()
				button.queue_free()
				$CanvasLayer/GridContainer/GridContainer.remove_child(button)
			else:
				$CanvasLayer/MessageLabel.text = tr("UI_STATUS_COULD_NOT_DELETE")

func create_replay_dir_if_empty():
	if not DirAccess.dir_exists_absolute(REPLAY_LOG_FILE_DIRECTORY):
		DirAccess.make_dir_absolute(REPLAY_LOG_FILE_DIRECTORY)

func dir_contents():
	create_replay_dir_if_empty()
	var dir = DirAccess.open(REPLAY_LOG_FILE_DIRECTORY)
	if dir:
		dir.list_dir_begin() # TODO: Converter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file_name = dir.get_next()
		var files_list = []
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				files_list.push_front(file_name)
			file_name = dir.get_next()
		for file in files_list:
			make_replay_item(file)
	else:
		print("An error occurred when trying to access the path.")
		$CanvasLayer/ErrorLabel.text = tr("UI_STATUS_CANNOT_OPEN_REPLAY_DIR")

func _input(event):
	input_help(event)

func input_help(event):
	if event.is_action_pressed("ui_cancel"):
		prev_scene()
	if (event.is_action_pressed("ui_accept")):
		if (delete_mode):
			delete_replay(most_recent_focus)
		else:
			next_scene()

func next_scene():
	MainMenuMusicControl.play_cursor_select()
	if (most_recent_focus != null and most_recent_focus != $CanvasLayer/GridContainer/GridContainer/DeleteModeButton):
		Global.REPLAY_FILE_NAME = most_recent_focus.text
		get_tree().change_scene_to_file("res://game/menus/replay/ReplayMain.tscn")
	else:
		$CanvasLayer/ErrorLabel.text = tr("UI_STATUS_NO_REPLAY_SELECTED")

func prev_scene():
	MainMenuMusicControl.play_cursor_deselect()
	get_tree().change_scene_to_file("res://game/menus/buttonmap/ReplayControllerPickMenuScreen.tscn")

func _on_DeleteModeButton_pressed():
	delete_mode = !delete_mode
	if (delete_mode):
		$CanvasLayer/MessageLabel.text = tr("UI_STATUS_SELECT_REPLAY_DELETE")
		$Earthbound2.modulate = Color("#f00033")
	else:
		$CanvasLayer/MessageLabel.text = ""
		$Earthbound2.modulate = Color("#0f4252")
