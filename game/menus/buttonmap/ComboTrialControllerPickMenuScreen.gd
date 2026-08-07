extends TrainingControllerPickMenu

class_name ComboTrialControllerPickMenu

func next_scene():
	MainMenuMusicControl.play_cursor_select()
	Global.IS_TRAINING = true
	get_tree().change_scene_to_file("res://game/menus/combo_trial/ComboTrialCharacterSelect.tscn")

func prev_scene():
	MainMenuMusicControl.play_cursor_deselect()
	get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")
