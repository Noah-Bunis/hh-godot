extends SGFixedNode2D

class_name FighterGame

signal rematch_ok()
signal rematch()
signal chara_select()
signal main_menu()
signal update_win_counts()

@onready var menu = preload("res://game/menus/rematchmenu/RematchControl.tscn")

@onready var BattleCamera = $BattleCamera
@onready var RoundTimer = $Camera3D/BattleUI/RoundTimer

@onready var ServerAssistBar = $Camera3D/BattleUI/ServerAssistBar
@onready var ClientAssistBar = $Camera3D/BattleUI/ClientAssistBar
@onready var ServerSuperBar = $Camera3D/BattleUI/ServerSuperBar
@onready var ClientSuperBar = $Camera3D/BattleUI/ClientSuperBar
@onready var ServerSyncRateBar = $Camera3D/BattleUI/ServerSyncRateBar
@onready var ClientSyncRateBar = $Camera3D/BattleUI/ClientSyncRateBar

var ServerPlayer
var ClientPlayer
var AssistPlayer1:AssistPlayer
var AssistPlayer2:AssistPlayer
var Hato1: PuppetPlayer
var Hato2: PuppetPlayer

var frozen:bool
var preround:bool
var frozenFrame:int
var koDelay:int
var hpDelay:int
var ko_enabled:bool = true

enum GameState {
	frozen,
	preround,
	frozenFrame,
	koDelay,
	hpDelay,
}

var rematch_control

const pivotOffset = SGFixed.ONE

const SuperFlashVFX = preload("res://game/fighter/effects/SuperFlash.tscn")

func _save_state() -> Dictionary:
	var state : Dictionary = {
		GameState.frozen : frozen,
		GameState.preround : preround,
		GameState.frozenFrame : frozenFrame,
		GameState.koDelay : koDelay,
		GameState.hpDelay: hpDelay,
	}
	return state

func _load_state(state: Dictionary) -> void:
	var prev_frozen = frozen
	frozen = state[GameState.frozen]
	preround = state[GameState.preround]
	frozenFrame = state[GameState.frozenFrame]
	koDelay = state[GameState.koDelay]
	hpDelay = state[GameState.hpDelay]
	if (prev_frozen != frozen):
		if (frozen):
			freeze_game_sim()
		else:
			un_freeze_game_sim()

func _init():
	add_to_group("network_sync")
	
	frozen = false
	preround = true
	frozenFrame = 0

func ko_disable():
	ko_enabled = false

func reset_to_game_start():
	preround = true
	
	Global.server_input_interpreter = get_node("ServerInputInterpreter")
	Global.client_input_interpreter = get_node("ClientInputInterpreter")
	
	$StageBackgroundArt.load_stage()
	
	$Camera3D/BattleUI/ClientHPBar.reset_to_game_start()
	$Camera3D/BattleUI/ServerHPBar.reset_to_game_start()
	RoundTimer.reset_to_game_start()
	$Camera3D/BattleUI/RoundTracker.reset_to_game_start()
	$Camera3D.reset_to_game_start()

	$Camera3D/BattleUI/ClientComboCounter.reset_to_game_start()
	$Camera3D/BattleUI/ServerComboCounter.reset_to_game_start()
	
	ServerPlayer = Global.PLAYER_1_NODE_INSTANCE[0]
	ServerPlayer.reset_to_game_start()
	ServerPlayer.name = "Player1"
	ServerPlayer.fixed_position.x = -23292288
	ServerPlayer.fixed_position.y = 29949952
	ServerPlayer.sync_to_physics_engine()
	
	ClientPlayer = Global.PLAYER_2_NODE_INSTANCE[0]
	ClientPlayer.reset_to_game_start()
	ClientPlayer.name = "Player2"
	ClientPlayer.fixed_position.x = 23292288
	ClientPlayer.fixed_position.y = 29949952
	ClientPlayer.fixed_scale.x *= -1
	ClientPlayer.sync_to_physics_engine()

	AssistPlayer1 = Global.PLAYER_1_NODE_INSTANCE[1]
	AssistPlayer1.reset_to_game_start()
	AssistPlayer1.name = "AssistPlayer1"
	AssistPlayer1.fixed_position.x = -40239104
	AssistPlayer1.fixed_position.y = 29949952
	AssistPlayer1.sync_to_physics_engine()

	AssistPlayer2 = Global.PLAYER_2_NODE_INSTANCE[1]
	AssistPlayer2.reset_to_game_start()
	AssistPlayer2.name = "AssistPlayer2"
	AssistPlayer2.fixed_position.x = 40239104
	AssistPlayer2.fixed_position.y = 29949952
	AssistPlayer2.fixed_scale.x *= -1
	AssistPlayer2.sync_to_physics_engine()
	
	if (Global.PLAYER_1_NODE[2] != null and Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Hato1 = Global.PLAYER_1_NODE_INSTANCE[2]
		Hato1.reset_to_game_start()
		Hato1.name = "Hato1"
		Hato1.fixed_position.x = -15292288
		Hato1.fixed_position.y = 29949952
		Hato1.sync_to_physics_engine()
		Hato1.setup(
			PlayerSetup.new(false, false, Enums.PuppetCharacters.Hato, Global.PLAYER_1_COLOR_INSTANCE[0], $ServerInputInterpreter))
		Hato1.pilot = ServerPlayer
	
	if (Global.PLAYER_2_NODE[2] != null and Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Hato2 = Global.PLAYER_2_NODE_INSTANCE[2]
		Hato2.reset_to_game_start()
		Hato2.name = "Hato2"
		Hato2.fixed_position.x = 15292288
		Hato2.fixed_position.y = 29949952
		Hato2.fixed_scale.x *= -1
		Hato2.sync_to_physics_engine()
		Hato2.setup(
			PlayerSetup.new(true, true, Enums.PuppetCharacters.Hato,  Global.PLAYER_2_COLOR_INSTANCE[0], $ClientInputInterpreter))
		Hato2.pilot = ClientPlayer
		
	ServerPlayer.setup(
		PlayerSetup.new(false, false, Global.PLAYER_1_CHARACTER[0], Global.PLAYER_1_COLOR[0], $ServerInputInterpreter))
	ClientPlayer.setup(
		PlayerSetup.new(true, true, Global.PLAYER_2_CHARACTER[0], Global.PLAYER_2_COLOR[0], $ClientInputInterpreter))
	AssistPlayer1.setup(
		PlayerSetup.new(false, false, Global.PLAYER_1_CHARACTER[1], Global.PLAYER_1_COLOR[1], $ServerInputInterpreter))
	AssistPlayer2.setup(
		PlayerSetup.new(true, true, Global.PLAYER_2_CHARACTER[1], Global.PLAYER_2_COLOR[1], $ClientInputInterpreter))

	AssistPlayer1.pilot = ServerPlayer
	AssistPlayer2.pilot = ClientPlayer
	ServerPlayer.hp_bar = $Camera3D/BattleUI/ServerHPBar
	ClientPlayer.hp_bar = $Camera3D/BattleUI/ClientHPBar
	
	ServerPlayer.round_counter = $Camera3D/BattleUI/RoundTracker
	ClientPlayer.round_counter = $Camera3D/BattleUI/RoundTracker
	
	ServerPlayer.update_opponent_anchor(ClientPlayer)
	ClientPlayer.update_opponent_anchor(ServerPlayer)

	$Camera3D/BattleUI/ServerPortrait.load_portrait(Global.PLAYER_1_CHARACTER[0], Global.PLAYER_1_COLOR_INSTANCE[0], Global.PLAYER_1_CHARACTER[1], Global.PLAYER_1_COLOR_INSTANCE[1])
	$Camera3D/BattleUI/ClientPortrait.load_portrait(Global.PLAYER_2_CHARACTER[0], Global.PLAYER_2_COLOR_INSTANCE[0], Global.PLAYER_2_CHARACTER[1], Global.PLAYER_2_COLOR_INSTANCE[1])
	$Camera3D/BattleUI/BattleVersionLabel.text = Global.BATTLE_ENGINE_VERSION
	
	BattleCamera.set_players(ServerPlayer, ClientPlayer)
	$Camera3D.set_players(ServerPlayer, ClientPlayer)
	SyncManager._spawn_manager._alphabetize_children(self)
	
	un_freeze_game_sim()

func setup():
	if (Global.PLAYER_1_NODE[0] == null):
		Global.PLAYER_1_NODE[0] = load(Global.PLAYER_1_NODE_PATH[0])
		Global.PLAYER_1_NODE_INSTANCE[0] = Global.PLAYER_1_NODE[0].instantiate()
	if (Global.PLAYER_2_NODE[0] == null):
		Global.PLAYER_2_NODE[0] = load(Global.PLAYER_2_NODE_PATH[0])
		Global.PLAYER_2_NODE_INSTANCE[0] = Global.PLAYER_2_NODE[0].instantiate()
	if (Global.PLAYER_1_NODE[1] == null):
		Global.PLAYER_1_NODE[1] = load(Global.PLAYER_1_NODE_PATH[1])
		Global.PLAYER_1_NODE_INSTANCE[1] = Global.PLAYER_1_NODE[1].instantiate()
	if (Global.PLAYER_2_NODE[1] == null):
		Global.PLAYER_2_NODE[1] = load(Global.PLAYER_2_NODE_PATH[1])
		Global.PLAYER_2_NODE_INSTANCE[1] = Global.PLAYER_2_NODE[1].instantiate()
		
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio and Global.PLAYER_1_NODE[2] == null):
		Global.PLAYER_1_NODE[2] = load(Global.PLAYER_1_NODE_PATH[2])
		Global.PLAYER_1_NODE_INSTANCE[2] = Global.PLAYER_1_NODE[2].instantiate()
	elif (Global.PLAYER_1_CHARACTER[0] != Enums.PointCharacters.Mio and Global.PLAYER_1_NODE[2] != null):
		Global.PLAYER_1_NODE[2] = null
		Global.PLAYER_1_NODE_INSTANCE[2] = null
		
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio and Global.PLAYER_2_NODE[2] == null):
		Global.PLAYER_2_NODE[2] = load(Global.PLAYER_2_NODE_PATH[2])
		Global.PLAYER_2_NODE_INSTANCE[2] = Global.PLAYER_2_NODE[2].instantiate()
	elif (Global.PLAYER_2_CHARACTER[0] != Enums.PointCharacters.Mio and Global.PLAYER_2_NODE[2] != null):
		Global.PLAYER_2_NODE[2] = null
		Global.PLAYER_2_NODE_INSTANCE[2] = null
	
	add_child(Global.PLAYER_1_NODE_INSTANCE[0])
	add_child(Global.PLAYER_1_NODE_INSTANCE[1])
	add_child(Global.PLAYER_2_NODE_INSTANCE[0])
	add_child(Global.PLAYER_2_NODE_INSTANCE[1])
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		add_child(Global.PLAYER_1_NODE_INSTANCE[2])
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		add_child(Global.PLAYER_2_NODE_INSTANCE[2])
	
	SyncManager.scene_spawned.connect(self._on_SyncManager_scene_spawned)
	SyncManager.scene_despawned.connect(self._on_SyncManager_scene_despawned)
	
	reset_to_game_start()
	
	signal_connect()

func free_game():
	if (ServerPlayer != null):
		ServerPlayer.queue_free()
		ServerPlayer = null
	if (ClientPlayer != null):
		ClientPlayer.queue_free()
		ClientPlayer = null
	if (AssistPlayer1 != null):
		AssistPlayer1.queue_free()
		AssistPlayer1 = null
	if (AssistPlayer2 != null):
		AssistPlayer2.queue_free()
		AssistPlayer2 = null
	if (Hato1 != null):
		Hato1.queue_free()
		Hato1 = null
	if (Hato2 != null):
		Hato2.queue_free()
		Hato2 = null

func start_game() -> void:
	start_pre_round()
	MainMenuMusicControl.start_music()
	MainMenuMusicControl.fade_in_music()
	Global.server_input_interpreter.clear_history()
	Global.client_input_interpreter.clear_history()
	Global.server_input_interpreter.get_node("InputSource").countdown = 60
	Global.client_input_interpreter.get_node("InputSource").countdown = 60
	$Camera3D/BattleUI/IntroShutters.slide_away()

func intro_shutters_set_visible(p_visible: bool):
	$Camera3D/BattleUI/IntroShutters.visible = p_visible

func start_pre_round() -> void:
	$Camera3D/BattleUI/NowLoadingText.start()
	preround = true

func end_pre_round() -> void:
	preround = false
	ServerPlayer.currentState[Enums.StKey.sync_rate] = Util.BASE_SYNC_RATE
	ClientPlayer.currentState[Enums.StKey.sync_rate] = Util.BASE_SYNC_RATE

func spawn(
		x:int,
		y:int,
		node_to_spawn:PackedScene,
		node_name:String,
		playerData: PlayerSetup) -> void:
	var input_interpreter: int
	if (playerData.team): # this is null on spawn records?
		input_interpreter = 1
	else:
		input_interpreter = 0
	var spawned_node: Node = SyncManager.spawn(node_name, self, node_to_spawn,
	{
		"position_x" : x,
		"position_y" : y,
		"left_face" : playerData.left_face,
		"team" : playerData.team,
		"point_chara" : playerData.point_chara,
		"color_scheme" : playerData.point_color,
		"input_interpreter" : input_interpreter
	})

func _on_SyncManager_scene_spawned(name, spawned_node, scene, data) -> void:
	# whether through rollback respawning or spawn method called
	if (spawned_node is BaseProjectilePlayer):
		if (data.get("team", false)):
			spawned_node.battery_player.connect(ClientPlayer.support_battery)
			ClientPlayer.strike_hurt.connect(spawned_node.point_hurt)
		else:
			spawned_node.battery_player.connect(ServerPlayer.support_battery)
			ServerPlayer.strike_hurt.connect(spawned_node.point_hurt)

func _on_SyncManager_scene_despawned(name, despawned_node) -> void:
	# whether through rollback re-despawning or despawn method called?
	if (despawned_node is BaseProjectilePlayer):
		if (despawned_node.team):
			despawned_node.battery_player.disconnect(ClientPlayer.support_battery)
			ClientPlayer.strike_hurt.disconnect(despawned_node.point_hurt)
		else:
			despawned_node.battery_player.disconnect(ServerPlayer.support_battery)
			ServerPlayer.strike_hurt.disconnect(despawned_node.point_hurt)

func signal_connect():
	ServerPlayer.connect("summon", Callable(AssistPlayer1, "tag_in"))
	ClientPlayer.connect("summon", Callable(AssistPlayer2, "tag_in"))
	
	if (Hato1 != null):
		ServerPlayer.connect("summonPuppet", Callable(Hato1, "summon"))
		ServerPlayer.connect("unsummonPuppet", Callable(Hato1, "unsummon"))
		Hato1.connect("strike_hurt", Callable(ServerPlayer, "puppet_hurt"))
		Hato1.connect("battery_player", Callable(ServerPlayer, "support_battery"))
		ServerPlayer.connect("strike_hurt", Callable(Hato1, "point_hurt"))
		Hato1.connect("super_freeze", Callable(self, "super_flash"))
	
	if (Hato2 != null):
		ClientPlayer.connect("summonPuppet", Callable(Hato2, "summon"))
		ClientPlayer.connect("unsummonPuppet", Callable(Hato2, "unsummon"))
		Hato2.connect("strike_hurt", Callable(ClientPlayer, "puppet_hurt"))
		Hato2.connect("battery_player", Callable(ClientPlayer, "support_battery"))
		ClientPlayer.connect("strike_hurt", Callable(Hato2, "point_hurt"))
		Hato2.connect("super_freeze", Callable(self, "super_flash"))
	
	AssistPlayer1.connect("strike_hurt", Callable(ServerPlayer, "assist_hurt"))
	AssistPlayer2.connect("strike_hurt", Callable(ClientPlayer, "assist_hurt"))
	AssistPlayer1.connect("battery_player", Callable(ServerPlayer, "support_battery"))
	AssistPlayer2.connect("battery_player", Callable(ClientPlayer, "support_battery"))
	AssistPlayer1.connect("move_pilot", Callable(ServerPlayer, "move_from_assist_character"))
	AssistPlayer2.connect("move_pilot", Callable(ClientPlayer, "move_from_assist_character"))
	
	ServerPlayer.connect("strike_hurt", Callable(AssistPlayer1, "point_hurt"))
	ClientPlayer.connect("strike_hurt", Callable(AssistPlayer2, "point_hurt"))
	
	ServerPlayer.connect("projectilespawn", Callable(self, "spawn"))
	ClientPlayer.connect("projectilespawn", Callable(self, "spawn"))
	
	AssistPlayer1.connect("projectilespawn", Callable(self, "spawn"))
	AssistPlayer2.connect("projectilespawn", Callable(self, "spawn"))
	
	ServerPlayer.connect("strike_hurt", Callable($Camera3D/BattleUI/ClientComboCounter, "count_up"))
	ClientPlayer.connect("strike_hurt", Callable($Camera3D/BattleUI/ServerComboCounter, "count_up"))
	
	ServerPlayer.connect("combo_exit", Callable($Camera3D/BattleUI/ClientComboCounter, "drop_combo"))
	ClientPlayer.connect("combo_exit", Callable($Camera3D/BattleUI/ServerComboCounter, "drop_combo"))
	ServerPlayer.connect("strike_hurt", Callable($Camera3D/BattleUI/ServerHPBar, "register_attack"))
	ClientPlayer.connect("strike_hurt", Callable($Camera3D/BattleUI/ClientHPBar, "register_attack"))
	ServerPlayer.connect("combo_exit", Callable($Camera3D/BattleUI/ServerHPBar, "drop_combo"))
	ClientPlayer.connect("combo_exit", Callable($Camera3D/BattleUI/ClientHPBar, "drop_combo"))

	RoundTimer.connect("round_timeout", Callable($Camera3D/BattleUI/ServerHPBar, "disable_hp"))
	RoundTimer.connect("round_timeout", Callable($Camera3D/BattleUI/ClientHPBar, "disable_hp"))
	RoundTimer.connect("round_timeout", Callable(self, "timeOutFlash"))

	$Camera3D/BattleUI/RoundTracker.connect("win", Callable($Camera3D/BattleUI/WinScreenManager, "start_win_process"))
	$Camera3D/BattleUI/RoundTracker.connect("win", Callable(MainMenuMusicControl, "fade_out_music"))
	$Camera3D/BattleUI/RoundTracker.connect("win", Callable($Camera3D/BattleUI/ServerHPBar, "disable_hp"))
	$Camera3D/BattleUI/RoundTracker.connect("win", Callable($Camera3D/BattleUI/ClientHPBar, "disable_hp"))

	$Camera3D/BattleUI/DownText.connect("end_down", Callable(self, "start_pre_round"))
	$Camera3D/BattleUI/DownText.connect("end_down", Callable($Camera3D/BattleUI/ClientHPBar, "reset_hp"))
	$Camera3D/BattleUI/DownText.connect("end_down", Callable($Camera3D/BattleUI/ServerHPBar, "reset_hp"))

	$Camera3D/BattleUI/NowLoadingText.connect("end_pre_round", Callable(RoundTimer, "reset_time"))
	$Camera3D/BattleUI/NowLoadingText.connect("end_pre_round", Callable(self, "end_pre_round"))
	$Camera3D/BattleUI/WinScreenManager.connect("rematch_ok", Callable(self, "rematch_ok_run"))

	$Camera3D/BattleUI/WinScreenManager.connect("freeze_game", Callable(self, "permaFreeze"))
	$Camera3D/BattleUI/WinScreenManager.connect("freeze_game", Callable(self, "stop_glowing_characters"))
	$Camera3D/BattleUI/WinScreenManager.connect("freeze_game", Callable(MainMenuMusicControl, "play_win_song"))
	
	ServerPlayer.connect("super_freeze", Callable(self, "super_flash"))
	ClientPlayer.connect("super_freeze", Callable(self, "super_flash"))
	AssistPlayer1.connect("super_freeze", Callable(self, "super_flash"))
	AssistPlayer2.connect("super_freeze", Callable(self, "super_flash"))
	
	ko_signal_connect()
	connect_dependencies()

func ko_signal_connect():
	if (ko_enabled):
		$Camera3D/BattleUI/ServerHPBar.connect("ko", Callable(ServerPlayer, "ko"))
		$Camera3D/BattleUI/ClientHPBar.connect("ko", Callable(ClientPlayer, "ko"))
		$Camera3D/BattleUI/ServerHPBar.connect("ko", Callable(self, "koStart"))
		$Camera3D/BattleUI/ClientHPBar.connect("ko", Callable(self, "koStart"))

func connect_dependencies() -> void:
	$Camera3D/BattleUI/DownText.round_tracker = $Camera3D/BattleUI/RoundTracker
	$Camera3D/BattleUI/NowLoadingText.round_tracker = $Camera3D/BattleUI/RoundTracker
	$Camera3D/BattleUI/ServerRoundCounter.round_tracker = $Camera3D/BattleUI/RoundTracker
	$Camera3D/BattleUI/ClientRoundCounter.round_tracker = $Camera3D/BattleUI/RoundTracker
	$Camera3D/BattleUI/ServerRoundCounter.setup_signal()
	$Camera3D/BattleUI/ClientRoundCounter.setup_signal()

func freeze_game_sim() -> void:
	frozen = true
	ServerPlayer.freeze_player_sim()
	ClientPlayer.freeze_player_sim()
	AssistPlayer1.freeze_player_sim()
	AssistPlayer2.freeze_player_sim()
	if (Hato1 != null):
		Hato1.freeze_player_sim()
	if (Hato2 != null):
		Hato2.freeze_player_sim()
	$StageBackgroundArt.freeze()

func un_freeze_game_sim() -> void:
	frozen = false
	frozenFrame = 0
	
	ServerPlayer.un_freeze_player_sim()
	ClientPlayer.un_freeze_player_sim()
	AssistPlayer1.un_freeze_player_sim()
	AssistPlayer2.un_freeze_player_sim()
	if (Hato1 != null):
		Hato1.un_freeze_player_sim()
	if (Hato2 != null):
		Hato2.un_freeze_player_sim()
	$StageBackgroundArt.unfreeze()
	$Camera3D/BattleUI/SuperFlashDim.visible = false
	
func super_flash(x:int, y:int, leftface:bool) -> void:
	SyncManager.spawn("SuperFlashVFX", self, SuperFlashVFX,
		{
			position_x = x,
			position_y = y,
			leftface = leftface,
		})
	frozenFrame = 24
	freeze_game_sim()
	$Camera3D/BattleUI/SuperFlashDim.visible = true

func koStart() -> void:
	koDelay = 5
	hpDelay = 1
	RoundTimer.stop_time()

func hp_freeze() -> void:
	$Camera3D/BattleUI/ServerHPBar.disable_hp()
	$Camera3D/BattleUI/ClientHPBar.disable_hp()

func koFlash() -> void:
	round_freeze()
	if (ServerPlayer.hp_bar.currentHP <= 0 and ClientPlayer.hp_bar.currentHP <= 0):
		if ($Camera3D/BattleUI/RoundTracker.read_rounds_won(true) < 1):
			$Camera3D/BattleUI/RoundTracker.register_ko(true)
		if ($Camera3D/BattleUI/RoundTracker.read_rounds_won(false) < 1):
			$Camera3D/BattleUI/RoundTracker.register_ko(false)
		$Camera3D/BattleUI/DownText.play_double_ko_text()
	elif (ServerPlayer.hp_bar.currentHP <= 0):
		$Camera3D/BattleUI/RoundTracker.register_ko(false)
		$Camera3D/BattleUI/DownText.play_down_text()
	elif (ClientPlayer.hp_bar.currentHP <= 0):
		$Camera3D/BattleUI/RoundTracker.register_ko(true)
		$Camera3D/BattleUI/DownText.play_down_text()
	else:
		print("no one ko'd???")

func timeOutFlash() -> void:
	round_freeze()
	if (ServerPlayer.hp_bar.currentHP > ClientPlayer.hp_bar.currentHP):
		$Camera3D/BattleUI/RoundTracker.register_ko(true)
		$Camera3D/BattleUI/DownText.play_time_over_text()
	elif (ServerPlayer.hp_bar.currentHP < ClientPlayer.hp_bar.currentHP):
		$Camera3D/BattleUI/RoundTracker.register_ko(false)
		$Camera3D/BattleUI/DownText.play_time_over_text()
	else:
		if ($Camera3D/BattleUI/RoundTracker.read_rounds_won(true) < 1):
			$Camera3D/BattleUI/RoundTracker.register_ko(true)
		if ($Camera3D/BattleUI/RoundTracker.read_rounds_won(false) < 1):
			$Camera3D/BattleUI/RoundTracker.register_ko(false)
		$Camera3D/BattleUI/DownText.play_draw_text()

func round_freeze() -> void:
	frozenFrame = 60
	ServerPlayer.remove_cancel_option()
	ClientPlayer.remove_cancel_option()
	if (Hato1 != null):
		Hato1.remove_cancel_option()
	if (Hato2 != null):
		Hato2.remove_cancel_option()
	freeze_game_sim()

func stop_glowing_characters():
	ServerPlayer.stop_glowing()
	ClientPlayer.stop_glowing()

func permaFreeze() -> void:
	frozen = true
	frozenFrame = -1
	freeze_game_sim()

func play_win_song() -> void:
	MainMenuMusicControl.play_win_song()

func rematch_ok_run():
	emit_signal("rematch_ok")

func rematch_on_sync_stopped():
	if ($Camera3D/BattleUI/WinScreenManager.frame > 0):
		emit_signal("update_win_counts")

		rematch_control = menu.instantiate()
		if (Global.NETPLAY_MODE == Global.NETPLAY_MODES.OFFLINE):
			rematch_control.deselect_ok()
		rematch_control.connect("rematch", Callable(self, "rematch_signal"))
		rematch_control.connect("chara_select", Callable(self, "chara_select_signal"))
		rematch_control.connect("main_menu", Callable(self, "main_menu_signal"))
		$CanvasLayer.add_child(rematch_control)
		$ServerInputInterpreter.clear_history()
		$ClientInputInterpreter.clear_history()

func reset_game():
	frozen = false
	preround = true
	$Camera3D/BattleUI/WinScreenManager.reset()
	$Camera3D/BattleUI/DownText.reset()
	rematch_control.disconnect("rematch", Callable(self, "rematch_signal"))
	rematch_control.disconnect("chara_select", Callable(self, "chara_select_signal"))
	rematch_control.disconnect("main_menu", Callable(self, "main_menu_signal"))
	rematch_control.queue_free()
	$Camera3D/BattleUI/IntroShutters.reset()
	$ServerInputInterpreter.clear_history()
	$ClientInputInterpreter.clear_history()
	
func rematch_signal():
	reset_game()
	emit_signal("rematch")

func chara_select_signal():
	reset_game()
	emit_signal("chara_select")

func main_menu_signal():
	reset_game()
	emit_signal("main_menu")

func tick_box_collisions(fight_entities):
	var allFirstFrameCollide: Dictionary = {}
	var react_type_categories: Dictionary = {}
	react_type_categories[Enums.ReactTypeCategory.Strike] = {}
	react_type_categories[Enums.ReactTypeCategory.Throw] = {}
	react_type_categories[Enums.ReactTypeCategory.BurstLock] = {}
	for fight_entity in fight_entities:
		fight_entity.tick_box_collisions()
		var name: String = fight_entity.get_name()
		var collide_data: Dictionary = fight_entity.getFirstFrameCollide()
		if (not collide_data.is_empty()):
			allFirstFrameCollide[name] = collide_data
			var react_type
			match fight_entity.attackData[Enums.StKey.attack_type]:
				Enums.AttackType.Strike:
					react_type = Enums.Reaction.StrikeHurt
				Enums.AttackType.Launcher:
					react_type = Enums.Reaction.LaunchHurt
				Enums.AttackType.GroundBouncer:
					react_type = Enums.Reaction.GroundBounceHurt
				Enums.AttackType.WallBouncer:
					react_type = Enums.Reaction.WallBounceHurt
				Enums.AttackType.Throw:
					react_type = Enums.Reaction.ThrowHurt
				Enums.AttackType.AirThrow:
					react_type = Enums.Reaction.AirThrowHurt
				Enums.AttackType.BurstLock:
					react_type = Enums.Reaction.BurstLockHurt
				_:
					printerr("invalid attack type given")
			allFirstFrameCollide[name]["_react_type"] = react_type
			react_type_categories[evaluate_react_type_category(react_type)][name] = 1
	# filter out based on strike beating throw. Maybe we can start this process earlier too
	# maybe even filter throw on throw for now, simulate throw clash
	# Also, only do all this work IF there is a throw on screen on this frame
	if (not react_type_categories[Enums.ReactTypeCategory.Throw].is_empty()):
		for name in allFirstFrameCollide.keys():
			if not allFirstFrameCollide[name].is_empty():
				var react_type_category: int = evaluate_react_type_category(allFirstFrameCollide[name]["_react_type"])
				if (react_type_category == Enums.ReactTypeCategory.Throw):
					# try filtering out
					for hurt_name in allFirstFrameCollide[name].keys():
						if (react_type_categories[Enums.ReactTypeCategory.Throw].has(hurt_name)):
							allFirstFrameCollide[name] = {}
							allFirstFrameCollide[hurt_name] = {}
							SyncManager.play_sound("parry", Global.ParrySound, {"bus": "Sound"})
							print("Throw Clash!")
		for name in allFirstFrameCollide.keys():
			if not allFirstFrameCollide[name].is_empty():
				var react_type_category: int = evaluate_react_type_category(allFirstFrameCollide[name]["_react_type"])
				if (react_type_category == Enums.ReactTypeCategory.Strike):
					# try filtering out
					for hurt_name in allFirstFrameCollide[name].keys():
						if (react_type_categories[Enums.ReactTypeCategory.Throw].has(hurt_name)):
							allFirstFrameCollide[hurt_name] = {}
							print("Strike Throw Clash!")
	return allFirstFrameCollide

func evaluate_react_type_category(react_type: int):
	var react_category = Enums.ReactTypeCategory.Strike
	match react_type:
		Enums.Reaction.StrikeHurt:
			react_category = Enums.ReactTypeCategory.Strike
		Enums.Reaction.LaunchHurt:
			react_category = Enums.ReactTypeCategory.Strike
		Enums.Reaction.GroundBounceHurt:
			react_category = Enums.ReactTypeCategory.Strike
		Enums.Reaction.WallBounceHurt:
			react_category = Enums.ReactTypeCategory.Strike
		Enums.Reaction.ThrowHurt:
			react_category = Enums.ReactTypeCategory.Throw
		Enums.Reaction.AirThrowHurt:
			react_category = Enums.ReactTypeCategory.Throw
		Enums.Reaction.BurstLockHurt:
			react_category = Enums.ReactTypeCategory.BurstLock
		_:
			printerr("invalid attack type given")
	return react_category

func resolve_collision_interactions(fight_entities, allFirstFrameCollide):
	for fight_entity in fight_entities:
		var name:String = fight_entity.get_name()
		if (allFirstFrameCollide.has(name) and not allFirstFrameCollide[name].is_empty()):
			var react_type: int = allFirstFrameCollide[name]["_react_type"]
			var hitNode : BasePlayer = get_node(name)
			for boxName in allFirstFrameCollide[name]:
				if (boxName == "_react_type"):
					continue #ignore react type data
				var hurtNode : BasePlayer = get_node(boxName)
				var teamLeadHitNode : BasePlayer
				if (hitNode.team):
					teamLeadHitNode = ClientPlayer
				else:
					teamLeadHitNode = ServerPlayer
				if ((react_type == Enums.Reaction.StrikeHurt or react_type == Enums.Reaction.LaunchHurt or react_type == Enums.Reaction.GroundBounceHurt or react_type == Enums.Reaction.WallBounceHurt)
						and hurtNode.has_property(Enums.StateProperty.StrikeInvul)):
					# ignore collision
					pass
				else:
					var hurt_left_face = left_face_calculation(teamLeadHitNode.fixed_position.x, hurtNode.fixed_position.x, teamLeadHitNode.currentState[Enums.StKey.leftface], hurtNode.currentState[Enums.StKey.leftface])
					var hitData : Dictionary
					if hitNode.currentState[Enums.StKey.stateName] == "Active" or hitNode.currentState[Enums.StKey.stateName] == "EnhancedActive" or hitNode.currentState[Enums.StKey.stateName] == "Travel":
						hitData = hurtNode.on_attack_hurt(react_type, hitNode.attackData, hurt_left_face, hitNode.currentState[Enums.StKey.leftface], hitNode.name.rstrip("0123456789"))
					else:
						hitData = hurtNode.on_attack_hurt(react_type, hitNode.attackData, hurt_left_face, hitNode.currentState[Enums.StKey.leftface], hitNode.currentState[Enums.StKey.stateName])
					hitNode.on_attack_hit(fight_entity.attackData[Enums.StKey.attack_type], hitData)
					if (react_type == Enums.Reaction.ThrowHurt or react_type == Enums.Reaction.AirThrowHurt):
						hurtNode.update_opponent_anchor(hitNode)
	
func left_face_calculation(pos1:int, pos2:int, left1:bool, left2:bool) -> bool:
	var pivot1:int
	var pivot2:int
	
	if (left1):
		pivot1 = pos1 + pivotOffset
	else:
		pivot1 = pos1 - pivotOffset
	if (left2):
		pivot2 = pos2 + pivotOffset
	else:
		pivot2 = pos2 - pivotOffset
	return pivot1 - pivot2 <= 0

func is_pushboxes_colliding():
	var width = (Util.PUSHBOX_SIZE*2) + 65536
	var height = (6847360*2) + 65536
	if (ServerPlayer.fixed_position.x < ClientPlayer.fixed_position.x + width and
			ServerPlayer.fixed_position.x + width > ClientPlayer.fixed_position.x and
			ServerPlayer.fixed_position.y < ClientPlayer.fixed_position.y + height and
			ServerPlayer.fixed_position.y + height > ClientPlayer.fixed_position.y):
		return true
	return false

func pushbox_collision():
	# Pushbox on pushbox collision
	if (is_pushboxes_colliding()):
		var leftSide = Util.fixed_max(-Util.PUSHBOX_SIZE+ClientPlayer.fixed_position.x, -Util.PUSHBOX_SIZE+ServerPlayer.fixed_position.x)
		var rightSide = Util.fixed_min(Util.PUSHBOX_SIZE+ClientPlayer.fixed_position.x, Util.PUSHBOX_SIZE+ServerPlayer.fixed_position.x)
		var overlap = SGFixed.mul(rightSide - leftSide, 32968) #32768
		var server_dist = overlap
		var client_dist = overlap
		
		if (ServerPlayer.on_corner()):
			client_dist += overlap
		if (ClientPlayer.on_corner()):
			server_dist += overlap
			
		if (left_face_calculation(ServerPlayer.fixed_position.x, ClientPlayer.fixed_position.x,
			ServerPlayer.currentState[Enums.StKey.leftface], ClientPlayer.currentState[Enums.StKey.leftface])):
			ServerPlayer.set_velocity(SGFixed.vector2(-server_dist, 0))
			ServerPlayer.move_and_slide()
			ClientPlayer.set_velocity(SGFixed.vector2(client_dist, 0))
			ClientPlayer.move_and_slide()
		else:
			ServerPlayer.set_velocity(SGFixed.vector2(server_dist, 0))
			ServerPlayer.move_and_slide()
			ClientPlayer.set_velocity(SGFixed.vector2(-client_dist, 0))
			ClientPlayer.move_and_slide()
	
	ServerPlayer.anchor_move()
	ClientPlayer.anchor_move()
	
	ServerPlayer.move_y()
	ClientPlayer.move_y()
	
	if (ClientPlayer.on_ground()):
		ClientPlayer.ground_land()
	if (ServerPlayer.on_ground()):
		ServerPlayer.ground_land()
	if (AssistPlayer1.on_ground()):
		AssistPlayer1.ground_land()
	if (AssistPlayer2.on_ground()):
		AssistPlayer2.ground_land()

	ServerPlayer.move_x()
	ClientPlayer.move_x()

	if (ClientPlayer.on_wall()):
		ClientPlayer.wall_land()
	if (ServerPlayer.on_wall()):
		ServerPlayer.wall_land()
	if (AssistPlayer1.on_wall()):
		AssistPlayer1.wall_land()
	if (AssistPlayer2.on_wall()):
		AssistPlayer2.wall_land()
	
	AssistPlayer1.set_global_fixed_position(
		SGFixed.vector2(BattleCamera.assist_force_in_bounds(AssistPlayer1.fixed_position.x), AssistPlayer1.fixed_position.y))
	AssistPlayer2.set_global_fixed_position(
		SGFixed.vector2(BattleCamera.assist_force_in_bounds(AssistPlayer2.fixed_position.x), AssistPlayer2.fixed_position.y))
	ServerPlayer.sync_to_physics_engine()
	ClientPlayer.sync_to_physics_engine()
	AssistPlayer1.sync_to_physics_engine()
	AssistPlayer2.sync_to_physics_engine()

func tick_fight_entities_state_action(fight_entities):
	for fight_entity in fight_entities:
		fight_entity.tick()

func _network_process(input: Dictionary) -> void:
	if ((not frozen) and (frozenFrame <= 0)):
		var node_tree = get_tree()
		var fight_entities = node_tree.get_nodes_in_group('fight_entity')
		RoundTimer.tick()
		BattleCamera.tick()
		ServerAssistBar.set_frame(RoundTimer.get_time())
		ClientAssistBar.set_frame(RoundTimer.get_time())
		ServerSuperBar.set_frame(RoundTimer.get_time())
		ClientSuperBar.set_frame(RoundTimer.get_time())

		# Left Face updates
		if (Hato1 != null):
			if (left_face_calculation(Hato1.fixed_position.x, ClientPlayer.fixed_position.x,
					Hato1.currentState[Enums.StKey.leftface], ClientPlayer.currentState[Enums.StKey.leftface])):
				Hato1.update_left_face(false)
			else:
				Hato1.update_left_face(true)
		
		if (Hato2 != null):
			if (left_face_calculation(Hato2.fixed_position.x, ServerPlayer.fixed_position.x,
					Hato2.currentState[Enums.StKey.leftface], ServerPlayer.currentState[Enums.StKey.leftface])):
				Hato2.update_left_face(false)
			else:
				Hato2.update_left_face(true)
		
		if (left_face_calculation(AssistPlayer1.fixed_position.x, ClientPlayer.fixed_position.x,
				AssistPlayer1.currentState[Enums.StKey.leftface], ClientPlayer.currentState[Enums.StKey.leftface])):
			AssistPlayer1.update_left_face(false)
		else:
			AssistPlayer1.update_left_face(true)
	
		if (left_face_calculation(AssistPlayer2.fixed_position.x, ServerPlayer.fixed_position.x,
				AssistPlayer2.currentState[Enums.StKey.leftface], ServerPlayer.currentState[Enums.StKey.leftface])):
			AssistPlayer2.update_left_face(false)
		else:
			AssistPlayer2.update_left_face(true)
		
		if (left_face_calculation(ServerPlayer.fixed_position.x, ClientPlayer.fixed_position.x,
			ServerPlayer.currentState[Enums.StKey.leftface], ClientPlayer.currentState[Enums.StKey.leftface])):
			ServerPlayer.update_left_face(false)
			ClientPlayer.update_left_face(true)
		else:
			ServerPlayer.update_left_face(true)
			ClientPlayer.update_left_face(false)
		var distance =  Util.fixed_abs(ServerPlayer.fixed_position.x - ClientPlayer.fixed_position.x)
		ServerPlayer.currentState[Enums.StKey.opponent_pos_x] = ClientPlayer.get_global_fixed_position().x
		ClientPlayer.currentState[Enums.StKey.opponent_pos_x] = ServerPlayer.get_global_fixed_position().x
		ServerPlayer.currentState[Enums.StKey.distance_to_opponent] = distance
		ClientPlayer.currentState[Enums.StKey.distance_to_opponent] = distance
		tick_fight_entities_state_action(fight_entities)
		
		if (not preround):
			# Hitbox Collision checks
			var allFirstFrameCollide = tick_box_collisions(fight_entities)
			# Hitbox Interaction Resolving
			resolve_collision_interactions(fight_entities, allFirstFrameCollide)
		else:
			#stop meter fluctuation
			ServerPlayer.currentState[Enums.StKey.sync_rate] = Util.BASE_SYNC_RATE
			ClientPlayer.currentState[Enums.StKey.sync_rate] = Util.BASE_SYNC_RATE
			if (ServerPlayer.currentState[Enums.StKey.super_meter] > ServerPlayer.old_super_meter):
				ServerPlayer.currentState[Enums.StKey.super_meter] = ServerPlayer.old_super_meter
			if (ClientPlayer.currentState[Enums.StKey.super_meter] > ClientPlayer.old_super_meter):
				ClientPlayer.currentState[Enums.StKey.super_meter] = ClientPlayer.old_super_meter
		
		ServerPlayer.delay_summon()
		ClientPlayer.delay_summon()
		AssistPlayer1.delay_summon()
		AssistPlayer2.delay_summon()

		# Pushbox collision updates
		pushbox_collision()
		ServerAssistBar.updateUI(ServerPlayer.getAssistMeter())
		ClientAssistBar.updateUI(ClientPlayer.getAssistMeter())
		ServerSuperBar.updateUI(ServerPlayer.getSuperMeter(), ServerPlayer.getBurstOK(), ServerPlayer.getBurstCost())
		ClientSuperBar.updateUI(ClientPlayer.getSuperMeter(), ClientPlayer.getBurstOK(), ClientPlayer.getBurstCost())
		ServerSyncRateBar.updateUI(ServerPlayer.getSyncRate())
		ClientSyncRateBar.updateUI(ClientPlayer.getSyncRate())
		
		if (koDelay > 0):
			koDelay -= 1
			hpDelay -= 1
			if (hpDelay == 0):
				hp_freeze()
			if (koDelay == 0):
				koFlash()
	else:
		if (frozenFrame > 0):
			frozenFrame -= 1
			freeze_game_sim()
		elif (frozenFrame == 0):
			un_freeze_game_sim()
		else:
			pass # permafreeze

func point_left_face_calculation(is_server_player: bool) -> bool: 
	# confusingly, true is Serverplayer.leftface = true
	if (is_server_player):
		return not left_face_calculation(ServerPlayer.fixed_position.x, ClientPlayer.fixed_position.x,
			ServerPlayer.currentState[Enums.StKey.leftface], ClientPlayer.currentState[Enums.StKey.leftface])
	else:
		return left_face_calculation(ServerPlayer.fixed_position.x, ClientPlayer.fixed_position.x,
			ServerPlayer.currentState[Enums.StKey.leftface], ClientPlayer.currentState[Enums.StKey.leftface])
