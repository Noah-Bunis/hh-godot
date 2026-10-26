extends TrainingStageMusicSelect

class_name MinigameStageMusicSelect

func evaluate_p1_side_bgm():
	return not Global.TRAINING_P1

func go_to_prev_scene():
	MainMenuMusicControl.play_cursor_deselect()
	get_tree().change_scene_to_file("res://game/menus/minigame/MinigameCharacterSelect.tscn")

func go_to_next_scene():
	MainMenuMusicControl.play_cursor_select()
	MainMenuMusicControl.reset_seek()
	get_tree().change_scene_to_file("res://game/menus/combo_trial/ComboTrialMain.tscn")
