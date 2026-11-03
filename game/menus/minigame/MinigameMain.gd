extends OfflineVersusMain

class_name MinigameMain

var dummy_input: InputInterpreter
var minigame_run_started: bool = false
var dummy_is_p1: bool
var original_dummy_point_character: int
var original_dummy_point_scene: PackedScene

@onready var minigame_director = $CanvasLayer/MinigameDirector


func _ready() -> void:
	super._ready()

	game_mode_root = "/root/MinigameMain/FighterGame"
	dummy_is_p1 = not Global.TRAINING_P1
	var dummy_nodes = Global.PLAYER_1_NODE if dummy_is_p1 else Global.PLAYER_2_NODE
	var dummy_characters = Global.PLAYER_1_CHARACTER if dummy_is_p1 else Global.PLAYER_2_CHARACTER
	var dummy_paths = Global.PLAYER_1_NODE_PATH if dummy_is_p1 else Global.PLAYER_2_NODE_PATH
	original_dummy_point_character = dummy_characters[0]
	original_dummy_point_scene = dummy_nodes[0] as PackedScene
	if original_dummy_point_scene == null:
		original_dummy_point_scene = load(dummy_paths[0]) as PackedScene

	setup_training()

	minigame_director.instruction_changed.connect(
		_on_minigame_instruction_changed
	)
	minigame_director.result_changed.connect(
		_on_minigame_result_changed
	)
	minigame_director.run_finished.connect(
		_on_minigame_run_finished
	)

	fighter_game.get_node(
		"Camera3D/BattleUI/NowLoadingText/NetworkAnimationPlayer"
	).animation_finished.connect(
		_on_round_start_popup_finished
	)


func start_minigame_run() -> void:
	minigame_director.start_run()


func _on_round_start_popup_finished(animation_name: StringName) -> void:
	if animation_name != &"LOADING" or minigame_run_started:
		return

	minigame_run_started = true
	start_minigame_run()


func _on_minigame_instruction_changed(minigame: Minigame) -> void:
	load_minigame_state(minigame)

	$CanvasLayer/MessageLabel.text = minigame.get_instruction()
	$CanvasLayer/MessageLabel.visible = true


func _on_minigame_result_changed(success: bool) -> void:
	$CanvasLayer/MessageLabel.text = (
		tr("UI_COMBO_SUCCESS") if success else "FAILED!"
	)


func _on_minigame_run_finished(
	final_score: int,
	total_games: int
) -> void:
	var player_won := total_games > 0 and final_score * 2 >= total_games
	Global.P1_WON_MATCH = (
		Global.TRAINING_P1 if player_won else not Global.TRAINING_P1
	)

	$CanvasLayer/MessageLabel.hide()
	fighter_game.RoundTimer.stop_time()
	fighter_game.permaFreeze()
	var win_screen_manager = fighter_game.get_node(
		"Camera3D/BattleUI/WinScreenManager"
	)
	win_screen_manager.frame = win_screen_manager.post_round_frames - 1
	win_screen_manager.start_win_process()
	fighter_game.get_node("Camera3D/BattleUI/ServerHPBar").disable_hp()
	fighter_game.get_node("Camera3D/BattleUI/ClientHPBar").disable_hp()


func exit():
	get_tree().change_scene_to_file(
		"res://game/menus/minigame/MinigameCharacterSelect.tscn"
	)
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()


func rematch() -> void:
	minigame_run_started = false
	super.rematch()


func return_control_to_player() -> void:
	if Global.TRAINING_P1:
		var player_input = fighter_game.get_node(
			"ServerInputInterpreter"
		)

		fighter_game.ServerPlayer.input_interpreter = player_input
		fighter_game.ClientPlayer.input_interpreter = dummy_input
		fighter_game.AssistPlayer1.input_interpreter = player_input
		fighter_game.AssistPlayer2.input_interpreter = dummy_input

		if fighter_game.Hato1 != null:
			fighter_game.Hato1.input_interpreter = player_input

		if fighter_game.Hato2 != null:
			fighter_game.Hato2.input_interpreter = dummy_input

		dummy_input.player = fighter_game.ClientPlayer
	else:
		var player_input = fighter_game.get_node(
			"ClientInputInterpreter"
		)

		fighter_game.ServerPlayer.input_interpreter = dummy_input
		fighter_game.ClientPlayer.input_interpreter = player_input
		fighter_game.AssistPlayer1.input_interpreter = dummy_input
		fighter_game.AssistPlayer2.input_interpreter = player_input

		if fighter_game.Hato1 != null:
			fighter_game.Hato1.input_interpreter = dummy_input

		if fighter_game.Hato2 != null:
			fighter_game.Hato2.input_interpreter = player_input

		dummy_input.player = fighter_game.ServerPlayer


func setup_training() -> void:
	if Global.TRAINING_P1:
		fighter_game.get_node("ClientInputInterpreter").set_script(
			DummyInputInterpreter
		)

		dummy_input = fighter_game.get_node(
			"ClientInputInterpreter"
		)
		dummy_input.input_prefix = "player2_"

		$CanvasLayer/WinStreakLabel.text = tr(
			"UI_LABEL_WINS"
		).format({"count": Global.P1_WIN_STREAK})
	else:
		fighter_game.get_node("ServerInputInterpreter").set_script(
			DummyInputInterpreter
		)

		dummy_input = fighter_game.get_node(
			"ServerInputInterpreter"
		)
		dummy_input.input_prefix = "player1_"

		$CanvasLayer/WinStreakLabel.text = tr(
			"UI_LABEL_WINS"
		).format({"count": Global.P2_WIN_STREAK})

	fighter_game.menu = load(
		"res://game/menus/rematchmenu/SinglePlayerRematchControl.tscn"
	)

	return_control_to_player()


func chara_select() -> void:
	if not match_disconnected:
		free_main()
		get_tree().change_scene_to_file(
			"res://game/menus/minigame/MinigameCharacterSelect.tscn"
		)


func _on_ExitButton_pressed() -> void:
	sync_clear()
	free_main()
	MainMenuMusicControl.stop_music()
	get_tree().paused = false

	get_tree().change_scene_to_file(
		"res://game/menus/minigame/MinigameCharacterSelect.tscn"
	)


func load_minigame_state(minigame: Minigame) -> void:
	if minigame.savestate.is_empty():
		push_error(
			"MinigameMain: Minigame '%s' has an empty savestate."
			% minigame.display_name
		)
		return

	var point_character: int = minigame.dummy_point_character
	var point_scene: PackedScene = minigame.dummy_point_scene
	if point_character < 0:
		point_character = original_dummy_point_character
		point_scene = original_dummy_point_scene
	elif point_scene == null:
		push_error(
			"MinigameMain: Minigame '%s' sets a dummy character without a scene."
			% minigame.display_name
		)
		return

	if point_scene == null:
		push_error("MinigameMain: Could not resolve the dummy point character scene.")
		return

	fighter_game.set_point_character(dummy_is_p1, point_character, point_scene)
	return_control_to_player()
	SyncManager._call_load_state(minigame.savestate)

	fighter_game.un_freeze_game_sim()
	fighter_game.RoundTimer.display_time()
	dummy_input.clear_input()


func input_start() -> void:
	if not $CanvasLayer/CommandList.is_enabled():
		if hold_start >= 20:
			toggle_pause_menu()
			hold_start = 0
			$CanvasLayer/HoldStartLabel.visible = false
		else:
			close_pause_menu()
	else:
		$CanvasLayer/CommandList.set_close_delay()