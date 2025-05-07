extends TrainingStageMusicSelect

class_name VersusCPUStageMusicSelect

func evaluate_p1_side_bgm():
	return not Global.TRAINING_P1

func go_to_prev_scene():
	MainMenuMusicControl.play_cursor_deselect()
	get_tree().change_scene_to_file("res://game/menus/versus/VersusCPUCharacterSelect.tscn")

func go_to_next_scene():
	MainMenuMusicControl.play_cursor_select()
	MainMenuMusicControl.reset_seek()
	get_tree().change_scene_to_file("res://game/menus/versus/VersusCPUMain.tscn")
