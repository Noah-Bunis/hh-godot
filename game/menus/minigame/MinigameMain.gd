extends OfflineVersusMain

class_name MinigameMain

var dummy_input: InputInterpreter

@onready var minigame_director = $CanvasLayer/MinigameDirector

func _ready() -> void:
	super._ready()
	game_mode_root = "/root/MinigameMain/FighterGame"
	setup_training()

	minigame_director.instruction_changed.connect(_on_minigame_instruction_changed)
	minigame_director.result_changed.connect(_on_minigame_result_changed)
	minigame_director.run_finished.connect(_on_minigame_run_finished)
	start_minigame_run()
	
func start_minigame_run() -> void:
	minigame_director.start_run()

func _on_minigame_instruction_changed(text: String) -> void:
	$CanvasLayer/MessageLabel.text = text
	$CanvasLayer/MessageLabel.visible = true
	
func _on_minigame_result_changed(success: bool) -> void:
	$CanvasLayer/MessageLabel.text = (tr("UI_COMBO_SUCCESS") if success else "FAILED!")

func _on_minigame_run_finished(
	final_score: int,
	total_games: int) -> void:
	$CanvasLayer/MessageLabel.text = (
		"RUN COMPLETE!\nSCORE: %d/%d"
		% [final_score, total_games])

func exit():
	get_tree().change_scene_to_file("res://game/menus/minigame/MinigameCharacterSelect.tscn")
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()

func return_control_to_player():
	if (Global.TRAINING_P1):
		var player_input = fighter_game.get_node("ServerInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = player_input
		fighter_game.ClientPlayer.input_interpreter = dummy_input
		fighter_game.AssistPlayer1.input_interpreter = player_input
		fighter_game.AssistPlayer2.input_interpreter = dummy_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = player_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = dummy_input
		dummy_input.player = fighter_game.ClientPlayer
	else:
		var player_input = fighter_game.get_node("ClientInputInterpreter")
		fighter_game.ServerPlayer.input_interpreter = dummy_input
		fighter_game.ClientPlayer.input_interpreter = player_input
		fighter_game.AssistPlayer1.input_interpreter = dummy_input
		fighter_game.AssistPlayer2.input_interpreter = player_input
		if (fighter_game.Hato1 != null):
			fighter_game.Hato1.input_interpreter = dummy_input
		if (fighter_game.Hato2 != null):
			fighter_game.Hato2.input_interpreter = player_input
		dummy_input.player = fighter_game.ServerPlayer

func setup_training():
	if (Global.TRAINING_P1):
		fighter_game.get_node("ClientInputInterpreter").set_script(DummyInputInterpreter)
		dummy_input = fighter_game.get_node("ClientInputInterpreter")
		dummy_input.input_prefix = "player2_"
		$CanvasLayer/WinStreakLabel.text = tr("UI_LABEL_WINS").format({"count": Global.P1_WIN_STREAK})
	else:
		fighter_game.get_node("ServerInputInterpreter").set_script(DummyInputInterpreter)
		dummy_input = fighter_game.get_node("ServerInputInterpreter")
		dummy_input.input_prefix = "player1_"
		$CanvasLayer/WinStreakLabel.text = tr("UI_LABEL_WINS").format({"count": Global.P2_WIN_STREAK})
	fighter_game.menu = load("res://game/menus/rematchmenu/SinglePlayerRematchControl.tscn")
	return_control_to_player()

func chara_select():
	if (not match_disconnected):
		free_main()
		get_tree().change_scene_to_file("res://game/menus/minigame/MinigameCharacterSelect.tscn")

func _on_ExitButton_pressed():
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/menus/minigame/MinigameCharacterSelect.tscn")

func input_start():
	if (not $CanvasLayer/CommandList.is_enabled()):
		if (hold_start >= 20):
			toggle_pause_menu()
			hold_start = 0
			$CanvasLayer/HoldStartLabel.visible = false
		else:
			close_pause_menu()
	else:
		$CanvasLayer/CommandList.set_close_delay()
