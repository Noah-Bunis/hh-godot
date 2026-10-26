extends ComboTrialCharacterSelect

class_name MinigameCharacterSelect

func _init():
	all_characters = [
		[Enums.AllCharacters.Ollie, Enums.AllCharacters.Suisei, Enums.AllCharacters.Kanata],
		[Enums.AllCharacters.Mio, Enums.AllCharacters.Subaru, Enums.AllCharacters.Oga],
		[Enums.AllCharacters.Random, Enums.AllCharacters.Flayon, Enums.AllCharacters.Random]
	]

func go_to_prev_scene():
	get_tree().change_scene_to_file("res://game/menus/buttonmap/MinigameControllerPickMenuScreen.tscn")

func go_to_next_scene():
	get_tree().change_scene_to_file("res://game/menus/training/TrainingMain.tscn")
