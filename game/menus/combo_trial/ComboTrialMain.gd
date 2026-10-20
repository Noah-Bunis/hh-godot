extends TrainingMain

class_name ComboTrialMain

signal next_trial
signal prev_trial

func _ready() -> void:
	super._ready()
	var dummy_player = fighter_game.ClientPlayer if Global.TRAINING_P1 else fighter_game.ServerPlayer
	dummy_player.connect("attack_hurt", Callable($CanvasLayer/ComboTrialListener, "attack_hurt"))
	dummy_player.connect("combo_exit", Callable($CanvasLayer/ComboTrialListener, "drop_combo"))

	self.connect("prev_trial", Callable($CanvasLayer/ComboTrialListener, "prev_trial"))
	self.connect("next_trial", Callable($CanvasLayer/ComboTrialListener, "next_trial"))
	$CanvasLayer/ComboTrialListener.connect("combo_loaded", Callable(self, "_on_combo_loaded"))
	_on_combo_loaded($CanvasLayer/ComboTrialListener.current_reset_position)

func _on_combo_loaded(reset_position_name: String) -> void:
	var reset_position: int = TrainingResetPosition.get(reset_position_name, TrainingResetPosition.CENTER)
	_apply_training_reset_position(reset_position)

func prepare_for_demo_playback() -> void:
	_on_combo_loaded($CanvasLayer/ComboTrialListener.current_reset_position)

func exit():
	get_tree().change_scene_to_file("res://game/menus/combo_trial/ComboTrialCharacterSelect.tscn")
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()

func _on_prev_trial_button_button_down() -> void:
	prev_trial.emit()

func _on_next_trial_button_button_down() -> void:
	next_trial.emit()
