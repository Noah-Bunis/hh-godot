extends OfflineVersusMain

class_name MinigameMain

const MINIGAME_ROUND_TIMER_SCENE = preload(
	"res://game/menus/minigame/MinigameRoundTimer.tscn"
)

var dummy_input: InputInterpreter
var minigame_run_started: bool = false
var dummy_is_p1: bool
var original_dummy_point_character: int
var original_dummy_assist_character: int
var original_dummy_point_scene: PackedScene
var original_dummy_assist_scene: PackedScene
var active_minigame_instruction: MinigameInstruction

@onready var minigame_director = $CanvasLayer/MinigameDirector
@onready var objective_progress_label: Label = $CanvasLayer/ObjectiveProgressLabel


func _ready() -> void:
	super._ready()
	var round_timer = fighter_game.RoundTimer
	var minigame_round_timer: MinigameRoundTimer = (
		MINIGAME_ROUND_TIMER_SCENE.instantiate()
	)
	minigame_round_timer.name = "MinigameRoundTimer"
	minigame_round_timer.minigame_director = minigame_director
	minigame_round_timer.position = round_timer.position
	minigame_round_timer.scale = round_timer.scale
	minigame_round_timer.hide()
	round_timer.get_parent().add_child(minigame_round_timer)
	round_timer.hide()
	round_timer.stop_time()

	game_mode_root = "/root/MinigameMain/FighterGame"
	dummy_is_p1 = not Global.TRAINING_P1
	var dummy_nodes = Global.PLAYER_1_NODE if dummy_is_p1 else Global.PLAYER_2_NODE
	var dummy_characters = Global.PLAYER_1_CHARACTER if dummy_is_p1 else Global.PLAYER_2_CHARACTER
	var dummy_paths = Global.PLAYER_1_NODE_PATH if dummy_is_p1 else Global.PLAYER_2_NODE_PATH
	original_dummy_point_character = dummy_characters[0]
	original_dummy_assist_character = dummy_characters[1]
	original_dummy_point_scene = dummy_nodes[0] as PackedScene
	original_dummy_assist_scene = dummy_nodes[1] as PackedScene
	if original_dummy_point_scene == null:
		original_dummy_point_scene = load(dummy_paths[0]) as PackedScene
	if original_dummy_assist_scene == null:
		original_dummy_assist_scene = load(dummy_paths[1]) as PackedScene

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
	fighter_game.RoundTimer.hide()
	fighter_game.RoundTimer.stop_time()
	minigame_director.target_player = (
		fighter_game.ServerPlayer if dummy_is_p1 else fighter_game.ClientPlayer
	)

	if active_minigame_instruction != null:
		if active_minigame_instruction.progress_changed.is_connected(
			_on_minigame_progress_changed
		):
			active_minigame_instruction.progress_changed.disconnect(
				_on_minigame_progress_changed
			)

	active_minigame_instruction = minigame.objective
	message_label.text = minigame.get_instruction()
	message_label.show()
	objective_progress_label.hide()
	if active_minigame_instruction != null:
		active_minigame_instruction.progress_changed.connect(
			_on_minigame_progress_changed
		)
		_on_minigame_progress_changed(
			active_minigame_instruction.get_progress_text()
		)


func _on_minigame_progress_changed(progress_text: String) -> void:
	objective_progress_label.text = progress_text
	objective_progress_label.visible = not progress_text.is_empty()


func _on_minigame_result_changed(success: bool) -> void:
	message_label.text = (
		tr("UI_COMBO_SUCCESS") if success else "FAILED!"
	)
	objective_progress_label.hide()


func _on_minigame_run_finished(
	final_score: int,
	total_games: int
) -> void:
	var player_won := total_games > 0 and final_score * 2 >= total_games
	Global.P1_WON_MATCH = (
		Global.TRAINING_P1 if player_won else not Global.TRAINING_P1
	)

	message_label.hide()
	objective_progress_label.hide()
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
	var assist_character: int = minigame.dummy_assist_character
	var point_scene: PackedScene = minigame.dummy_point_scene
	var assist_scene: PackedScene = minigame.dummy_assist_scene
	if point_character < 0:
		point_character = original_dummy_point_character
		point_scene = original_dummy_point_scene
	if assist_character < 0:
		assist_character = original_dummy_assist_character
		assist_scene = original_dummy_assist_scene
	elif point_scene == null:
		push_error(
			"MinigameMain: Minigame '%s' sets a dummy character without a scene."
			% minigame.display_name
		)
		return
	elif assist_scene == null:
		push_error(
			"MinigameMain: Minigame '%s' sets a dummy assist without a scene."
			% minigame.display_name
		)
		return

	if point_scene == null:
		push_error("MinigameMain: Could not resolve the dummy point character scene.")
		return
	if assist_scene == null:
		push_error("MinigameMain: Could not resolve the dummy assist character scene.")
		return

	var point_color_path: String = _get_minigame_palette_path(
		point_character,
		false
	)
	var assist_color_path: String = _get_minigame_palette_path(
		assist_character,
		true
	)
	if point_color_path.is_empty() or assist_color_path.is_empty():
		return

	var dummy_colors = Global.PLAYER_1_COLOR if dummy_is_p1 else Global.PLAYER_2_COLOR
	if dummy_colors[0] != point_color_path:
		dummy_colors[0] = point_color_path
		Global.load_new_color(dummy_is_p1, false)
	if dummy_colors[1] != assist_color_path:
		dummy_colors[1] = assist_color_path
		Global.load_new_color(dummy_is_p1, true)

	fighter_game.set_point_character(dummy_is_p1, point_character, point_scene)
	fighter_game.set_assist_character(dummy_is_p1, assist_character, assist_scene)
	return_control_to_player()
	SyncManager._call_load_state(minigame.savestate)
	fighter_game.un_freeze_game_sim()
	fighter_game.RoundTimer.display_time()
	dummy_input.clear_input()


func _get_minigame_palette_path(character: int, is_assist: bool) -> String:
	var slot: int = 1 if is_assist else 0
	var characters = (
		Global.PLAYER_1_CHARACTER if dummy_is_p1 else Global.PLAYER_2_CHARACTER
	)
	var colors = Global.PLAYER_1_COLOR if dummy_is_p1 else Global.PLAYER_2_COLOR
	if characters[slot] == character:
		return colors[slot]

	var new_palette_directory: String = _get_minigame_palette_directory(
		character,
		is_assist
	)
	if new_palette_directory.is_empty():
		push_error(
			"MinigameMain: No palette directory for character %s."
			% character
		)
		return ""

	var old_palette_directory: String = _get_minigame_palette_directory(
		characters[slot],
		is_assist
	)
	var current_palette_number: int = (
		colors[slot].get_file().get_basename().to_int()
	)
	if (
		current_palette_number > 0
		and ResourceLoader.exists(
			old_palette_directory + str(current_palette_number) + ".png"
		)
		and ResourceLoader.exists(
			new_palette_directory + str(current_palette_number) + ".png"
		)
	):
		return new_palette_directory + str(current_palette_number) + ".png"

	for candidate in range(1, Util.MAX_COLOR_PALETTE_NUMBER + 1):
		var palette_path: String = new_palette_directory + str(candidate) + ".png"
		if ResourceLoader.exists(palette_path):
			return palette_path

	push_error(
		"MinigameMain: No color palettes found for character %s."
		% character
	)
	return ""


func _get_minigame_palette_directory(
	character: int,
	is_assist: bool
) -> String:
	if is_assist:
		match character:
			Enums.AssistCharacters.Fubuki:
				return "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
			Enums.AssistCharacters.Sora:
				return "res://game/assets/sprites/assists/sora/ColorPalettes/"
			Enums.AssistCharacters.Sana:
				return "res://game/assets/sprites/assists/sana/ColorPalettes/"
			Enums.AssistCharacters.OkaKoro:
				return "res://game/assets/sprites/assists/okakoro/ColorPalettes/"
			Enums.AssistCharacters.Hakka:
				return "res://game/assets/sprites/assists/hakka/ColorPalettes/"
			Enums.AssistCharacters.Rikka:
				return "res://game/assets/sprites/assists/rikka/ColorPalettes/"
			Enums.AssistCharacters.Subaru:
				return "res://game/assets/sprites/subaru/ColorPalettes/"
			Enums.AssistCharacters.Mio:
				return "res://game/assets/sprites/mio/ColorPalettes/"
			Enums.AssistCharacters.Oga:
				return "res://game/assets/sprites/oga/ColorPalettes/"
			Enums.AssistCharacters.Ollie:
				return "res://game/assets/sprites/ollie/ColorPalettes/"
			Enums.AssistCharacters.Suisei:
				return "res://game/assets/sprites/suisei/ColorPalettes/"
			Enums.AssistCharacters.Kanata:
				return "res://game/assets/sprites/kanata/ColorPalettes/"
			Enums.AssistCharacters.Flayon:
				return "res://game/assets/sprites/flayon/ColorPalettes/"
	else:
		match character:
			Enums.PointCharacters.Subaru:
				return "res://game/assets/sprites/subaru/ColorPalettes/"
			Enums.PointCharacters.Mio:
				return "res://game/assets/sprites/mio/ColorPalettes/"
			Enums.PointCharacters.Oga:
				return "res://game/assets/sprites/oga/ColorPalettes/"
			Enums.PointCharacters.Ollie:
				return "res://game/assets/sprites/ollie/ColorPalettes/"
			Enums.PointCharacters.Suisei:
				return "res://game/assets/sprites/suisei/ColorPalettes/"
			Enums.PointCharacters.Kanata:
				return "res://game/assets/sprites/kanata/ColorPalettes/"
			Enums.PointCharacters.Flayon:
				return "res://game/assets/sprites/flayon/ColorPalettes/"
	return ""


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