
extends Node2D

class_name DemoMain

const DummyNetworkAdaptor = preload("res://addons/godot-rollback-netcode/DummyNetworkAdaptor.gd")
const ReplayLogger = preload("res://game/menus/replay/ReplayLogger.gd")
var replay_logger
const MatchConnector = preload("res://game/components/netplay_manager/MatchStartConnector.gd")
var match_connector

@onready var message_label = $CanvasLayer/MessageLabel
@onready var sync_lost_label = $CanvasLayer/SyncLostLabel

const LOG_FILE_DIRECTORY = Global.LOG_FILE_DIRECTORY
const REPLAY_LOG_FILE_DIRECTORY = Global.REPLAY_LOG_FILE_DIRECTORY

var logging_enabled := true
var replay_logging_enabled := true

var set_match_total: int = 0
var p1_win_total: int = 0

var match_disconnected: bool = false
var peer_ready:Dictionary = {}

var fighter_game: FighterGame
var game_mode_root: String
var load_complete: bool

func _init() -> void:
	load_complete = false
	replay_logging_enabled = Global.replay_logging_enabled
	fighter_game = Global.FIGHTER_GAME.instantiate()
	game_mode_root = "/root/Main/FighterGame"
	add_child(fighter_game, true)
	if is_replay():
		replay_logging_enabled = false
		logging_enabled = false

func free_main() -> void:
	fighter_game.free_game()
	fighter_game = null

func _on_SyncManager_peer_pinged_back(peer: SyncManager.Peer) -> void:
	$CanvasLayer/PingLabel.set_text("Ping: " + str((int)(peer.rtt/2.0)) +" ms")
	#var rollback_frame:int = SyncManager.rollback_ticks
	var rollback_frame:int = int(peer.rtt/(33.3333)) - SyncManager.input_delay
	if (rollback_frame < 0):
		rollback_frame = 0
	$CanvasLayer/RollbackFrameLabel.set_text("RollbackFrame: " + str(rollback_frame) +"F")
#	print ("-----")
#	print ("Peer %s: RTT %s ms | local lag %s | remote lag %s | advantage %s" % [peer.peer_id, peer.rtt, peer.local_lag, peer.remote_lag, peer.calculated_advantage])

func _ready() -> void:
	first_time_setup()

func signal_connect() -> void:
	if (not multiplayer.peer_connected.is_connected(_on_network_peer_connected)):
		multiplayer.peer_connected.connect(_on_network_peer_connected)
		multiplayer.peer_disconnected.connect(_on_network_peer_disconnected)
		multiplayer.connected_to_server.connect(_on_server_connected)
		multiplayer.connection_failed.connect(_on_network_peer_disconnected)
		multiplayer.server_disconnected.connect(_on_server_disconnected)
		SyncManager.connect("sync_started", Callable(self, "_on_SyncManager_sync_started"))
		SyncManager.connect("sync_stopped", Callable(self, "_on_SyncManager_sync_stopped"))
		SyncManager.connect("sync_lost", Callable(self, "_on_SyncManager_sync_lost"))
		SyncManager.connect("sync_regained", Callable(self, "_on_SyncManager_sync_regained"))
		SyncManager.connect("sync_error", Callable(self, "_on_SyncManager_sync_error"))
		SyncManager.connect("peer_pinged_back", Callable(self, "_on_SyncManager_peer_pinged_back"))
		$FighterGame.connect("rematch_ok", Callable(self, "game_ended"))
		$FighterGame.connect("rematch", Callable(self, "rematch"))
		$FighterGame.connect("chara_select", Callable(self, "chara_select"))
		$FighterGame.connect("main_menu", Callable(self, "main_menu"))
		$FighterGame.connect("update_win_counts", Callable(self, "update_win_counts"))
	$CanvasLayer/WinCounterP1.update_win_count(true)
	$CanvasLayer/WinCounterP2.update_win_count(false)

func first_time_setup() -> void:
	match_connector = MatchConnector.new()
	match_connector.connected.connect(start_game)
	if (not Global.ROLLBACK_LOGS_ENABLED):
		logging_enabled = false
	if (not is_replay()):
		$FighterGame.setup()
	signal_connect()
	setup_main()

func setup_main() -> void:
	match_disconnected = false
	peer_ready = {}
	
	$FighterGame/ServerInputInterpreter.set_multiplayer_authority(1)
	load_complete = true
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		_on_OnlineButton_pressed()
		if not multiplayer.is_server():
			rpc_id(1, "connect_peer_ready")
		else:
			peer_ready[1] = true
			if (all_peers_ready()):
				start_game()
	else:
		$CanvasLayer/PingLabel.hide()
		$CanvasLayer/RollbackFrameLabel.hide()
		_on_LocalButton_pressed()

func all_peers_ready():
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE and not Global.DEBUG):
		return load_complete and peer_ready.size() >= SyncManager.peers.size() + 1
	else:
		return load_complete and true

func manual_disconnect():
	print("Manual disconnect")
	quit_online_hard()
	main_menu()

@rpc("any_peer", "call_local", "reliable") func connect_peer_ready() -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	if multiplayer.is_server():
		peer_ready[peer_id] = true
		message_label.text = "# of Peers loaded: " + str(len(peer_ready))
		if (all_peers_ready()):
			match_connector.send_start_signal()

@rpc("any_peer", "call_local", "reliable") func start_game() -> void:
	if multiplayer.is_server():
		multiplayer.multiplayer_peer.refuse_new_connections = true
		
		message_label.text = ""
		await get_tree().create_timer(1.0).timeout
		SyncManager.start()

func _on_ServerButton_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(9999), 1)
	multiplayer.multiplayer_peer = peer

func _on_ClientButton_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", int(9999))
	multiplayer.multiplayer_peer = peer
	message_label.text = ""

func update_win_counts():
	Global.MATCH_TOTAL += 1
	Global.SET_TOTAL += 1
	if (Global.P1_WON_MATCH):
		Global.P1_WIN_TOTAL += 1
		Global.P1_SET_WIN_TOTAL += 1
		
		Global.P2_WIN_STREAK = 0
		Global.P1_WIN_STREAK += 1
	else:
		Global.P2_WIN_STREAK += 1
		Global.P1_WIN_STREAK = 0
	$CanvasLayer/WinCounterP1.update_win_count(true)
	$CanvasLayer/WinCounterP2.update_win_count(false)

func game_ended():
	SyncManager.stop()

func chara_select():
	if (not match_disconnected):
		free_main()
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			SyncManager.stop()
			get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineCharacterSelect.tscn")
		else:
			get_tree().change_scene_to_file("res://game/menus/characterselect/CharacterSelect.tscn")

func main_menu():
	free_main()
	sync_clear()
	if (Global.NETPLAY_MODE == Global.NETPLAY_MODES.PRIVATE_ROOM):
		quit_online_hard()
		if (OnlineLobby.match_id == ""):
			get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")
		else:
			# jank, but should avoid crash (might have to re login to server tho)
			OnlineLobby.send_status_update(OnlineLobby.CHALLENGE_STATE.IDLE)
			get_tree().change_scene_to_file("res://game/menus/onlinemenu/PrivateRoom.tscn")
	elif (Global.NETPLAY_MODE == Global.NETPLAY_MODES.PUBLIC_QUEUE):
		quit_online_hard()
		get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")
	else:
		sync_clear()
		get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")

func rematch():
	if (not match_disconnected):
		reload_scene()

func reload_scene():
	#free_main()
	load_complete = false
	match_connector.clear_received_message()
	fighter_game.reset_to_game_start()
	setup_main()

func get_opponent_peer_id() -> int:
	if (SyncManager.get_player_peer_count() >= 1):
		if (SyncManager.get_player_peer_ids()[0] != SyncManager.network_adaptor.get_unique_id()):
			return SyncManager.get_player_peer_ids()[0]
		else:
			return SyncManager.get_player_peer_ids()[1]
	printerr ("Main: unable to find opponent peer id")
	message_label.text = "unable to find opponent's peer id"
	quit_online_hard()
	return 1

func get_client_player_peer_id() -> int:
	if (SyncManager.get_player_peer_count() >= 1):
		if (SyncManager.get_player_peer_ids()[0] != 1):
			return SyncManager.get_player_peer_ids()[0]
		else:
			return SyncManager.get_player_peer_ids()[1]
	printerr ("Main: unable to find client peer id")
	message_label.text = "unable to find client peer id"
	quit_online_hard()
	return 1

func _on_network_peer_connected(peer_id: int):
	print("Connected to peer")
	# Tell sibling peers about ourselves.
	if not multiplayer.is_server() and peer_id != 1:
		rpc_id(peer_id, "register_player", {spectator = SyncManager.spectating})

func _on_network_peer_disconnected(peer_id: int):
	if (SyncManager.peers.has(peer_id)):
		var peer = SyncManager.peers[peer_id]
		SyncManager.remove_peer(peer_id)
		
		if not peer.spectator:
			message_label.text = "Disconnected, Press Back button to exit to lobby"
			quit_online_hard()
		
		if (peer_ready.has(peer_id)):
			peer_ready.erase(peer_id)
			if (all_peers_ready() and not match_disconnected and not SyncManager.started):
				await get_tree().create_timer(1.0).timeout
				match_connector.send_start_signal()
	else:
		print("SyncManager disconnected doesn't have this peer id")

func _on_server_connected() -> void:
	if not SyncManager.spectating:
		$FighterGame/ClientInputInterpreter.set_multiplayer_authority(multiplayer.get_unique_id())

func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)

func _on_SyncManager_sync_started() -> void:
	message_label.text = ""
	var match_info: Dictionary = {
			"point_1" : Global.PLAYER_1_CHARACTER[0],
			"point_node_1" : Global.PLAYER_1_NODE_PATH[0],
			"point_2" : Global.PLAYER_2_CHARACTER[0],
			"point_node_2" : Global.PLAYER_2_NODE_PATH[0],
			"assist_1" : Global.PLAYER_1_CHARACTER[1],
			"assist_node_1" : Global.PLAYER_1_NODE_PATH[1],
			"assist_2" : Global.PLAYER_2_CHARACTER[1],
			"assist_node_2" : Global.PLAYER_2_NODE_PATH[1],
			"point_1_color" : Global.PLAYER_1_COLOR[0],
			"assist_1_color" : Global.PLAYER_1_COLOR[1],
			"point_2_color" : Global.PLAYER_2_COLOR[0],
			"assist_2_color" : Global.PLAYER_2_COLOR[1],
		}
	if logging_enabled and not SyncReplay.active:
		var dir = DirAccess.open(LOG_FILE_DIRECTORY)
		if not dir.dir_exists(LOG_FILE_DIRECTORY):
			dir.make_dir(LOG_FILE_DIRECTORY)
		
		var datetime = Time.get_datetime_dict_from_system(true)
		var matchup_name = get_match_up_name(
				Global.PLAYER_1_CHARACTER[0],
				Global.PLAYER_1_CHARACTER[1],
				Global.PLAYER_2_CHARACTER[0],
				Global.PLAYER_2_CHARACTER[1])
		var log_file_name = "%04d%02d%02d-%02d%02d%02d-peer-%d" % [
			datetime['year'],
			datetime['month'],
			datetime['day'],
			datetime['hour'],
			datetime['minute'],
			datetime['second'],
			SyncManager.network_adaptor.get_unique_id(),
		]
		log_file_name = log_file_name+matchup_name+".log"
		SyncManager.start_logging(LOG_FILE_DIRECTORY + '/' + log_file_name, match_info)
	if (replay_logging_enabled):
		var dir = DirAccess.open(REPLAY_LOG_FILE_DIRECTORY)
		if not dir.dir_exists(REPLAY_LOG_FILE_DIRECTORY):
			dir.make_dir(REPLAY_LOG_FILE_DIRECTORY)
		
		var datetime = Time.get_datetime_dict_from_system(true)
		var matchup_name = get_match_up_name(
				Global.PLAYER_1_CHARACTER[0],
				Global.PLAYER_1_CHARACTER[1],
				Global.PLAYER_2_CHARACTER[0],
				Global.PLAYER_2_CHARACTER[1])
		var log_file_name = "%04d%02d%02d-%02d%02d%02d" % [
			datetime['year'],
			datetime['month'],
			datetime['day'],
			datetime['hour'],
			datetime['minute'],
			datetime['second'],
		]
		log_file_name = log_file_name+matchup_name+".log"
		replay_logger = ReplayLogger.new(SyncManager, game_mode_root)
		if replay_logger.start(REPLAY_LOG_FILE_DIRECTORY + '/' + log_file_name, match_info) != OK:
			print("Failed to start replay logger")
			message_label.text = "Failed to start replay logger"
			replay_logger.stop()
	$FighterGame.start_game()

func point_name_abbrev(point) -> String:
	match point:
		Enums.PointCharacters.Subaru:
			return "SUB"
		Enums.PointCharacters.Mio:
			return "MIO"
		Enums.PointCharacters.Oga:
			return "OGA"
		Enums.PointCharacters.Ollie:
			return "OLL"
		Enums.PointCharacters.Kanata:
			return "KAN"
		Enums.PointCharacters.Suisei:
			return "SUI"
		Enums.PointCharacters.Flayon:
			return "FLA"
		Enums.PointCharacters.Kurokami:
			return "KUR"
		_:
			printerr("invalid point character given")
			return "???"

func assist_name_abbrev(assist) -> String:
	match assist:
		Enums.AssistCharacters.Fubuki:
			return "FUB"
		Enums.AssistCharacters.Sora:
			return "SOR"
		Enums.AssistCharacters.OkaKoro:
			return "OKO"
		Enums.AssistCharacters.Sana:
			return "SNA"
		Enums.AssistCharacters.Hakka:
			return "HAK"
		Enums.AssistCharacters.Subaru:
			return "SUB"
		Enums.AssistCharacters.Mio:
			return "MIO"
		Enums.AssistCharacters.Oga: 
			return "OGA"
		Enums.AssistCharacters.Ollie: 
			return "OLL"
		Enums.AssistCharacters.Kanata: 
			return "KAN"
		Enums.AssistCharacters.Suisei: 
			return "SUI"
		Enums.AssistCharacters.Flayon: 
			return "FLA"
		_:
			printerr("invalid assist character given")
			return "???"

func get_match_up_name(point1, assist1, point2, assist2) -> String:
	return point_name_abbrev(point1) + assist_name_abbrev(assist1) + "v" + point_name_abbrev(point2) + assist_name_abbrev(assist2)

func _on_SyncManager_sync_stopped() -> void:
	if logging_enabled:
		SyncManager.stop_logging()
	if replay_logging_enabled:
		replay_logger.stop()
	$FighterGame.rematch_on_sync_stopped()

func _on_SyncManager_sync_lost() -> void:
	sync_lost_label.visible = true

func _on_SyncManager_sync_regained() -> void:
	sync_lost_label.visible = false

func _on_SyncManager_sync_error(msg: String) -> void:
	message_label.text = "Fatal sync error: " + msg + " , Press Back button to exit to lobby"
	sync_lost_label.visible = false
	
	sync_clear()
	quit_online_hard()

func sync_clear() -> void:
	SyncManager.stop()
	SyncManager.clear_peers()

func quit_online_hard() -> void:
	match_disconnected = true
	OnlineMatch.leave()
	sync_clear()

func setup_match_for_replay(my_peer_id: int, peer_ids: Array, match_info: Dictionary) -> void:
	var client_peer_id: int
	if my_peer_id == 1:
		client_peer_id = peer_ids[0]
	else:
		client_peer_id = my_peer_id
	$FighterGame/ClientInputInterpreter.set_multiplayer_authority(client_peer_id)
	
	Global.PLAYER_1_CHARACTER[0] = match_info["point_1"]
	Global.PLAYER_1_NODE_PATH[0] = match_info["point_node_1"]
	Global.PLAYER_2_CHARACTER[0] = match_info["point_2"]
	Global.PLAYER_2_NODE_PATH[0] = match_info["point_node_2"]
	Global.PLAYER_1_CHARACTER[1] = match_info["assist_1"]
	Global.PLAYER_1_NODE_PATH[1] = match_info["assist_node_1"]
	Global.PLAYER_2_CHARACTER[1] = match_info["assist_2"]
	Global.PLAYER_2_NODE_PATH[1] = match_info["assist_node_2"]
	
	Global.PLAYER_1_COLOR[0] = match_info.get("point_1_color", "res://game/assets/sprites/oga/ColorPalettes/1.png")
	Global.PLAYER_1_COLOR[1] = match_info.get("assist_1_color", "res://game/assets/sprites/oga/ColorPalettes/1.png")
	Global.PLAYER_2_COLOR[0] = match_info.get("point_2_color", "res://game/assets/sprites/oga/ColorPalettes/1.png")
	Global.PLAYER_2_COLOR[1] = match_info.get("assist_2_color", "res://game/assets/sprites/oga/ColorPalettes/1.png")
	
	Global.load_new_color(true, true)
	Global.load_new_color(false, false)
	Global.load_new_color(true, false)
	Global.load_new_color(false, true)
	
	Global.PLAYER_1_NODE[0] = load(Global.PLAYER_1_NODE_PATH[0])
	Global.PLAYER_1_NODE_INSTANCE[0] = Global.PLAYER_1_NODE[0].instantiate()
	
	Global.PLAYER_2_NODE[0] = load(Global.PLAYER_2_NODE_PATH[0])
	Global.PLAYER_2_NODE_INSTANCE[0] = Global.PLAYER_2_NODE[0].instantiate()
	
	Global.PLAYER_1_NODE[1] = load(Global.PLAYER_1_NODE_PATH[1])
	Global.PLAYER_1_NODE_INSTANCE[1] = Global.PLAYER_1_NODE[1].instantiate()
	
	Global.PLAYER_2_NODE[1] = load(Global.PLAYER_2_NODE_PATH[1])
	Global.PLAYER_2_NODE_INSTANCE[1] = Global.PLAYER_2_NODE[1].instantiate()
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.PLAYER_1_NODE[2] = load(Global.PLAYER_1_NODE_PATH[2])
		Global.PLAYER_1_NODE_INSTANCE[2] = Global.PLAYER_1_NODE[2].instantiate()
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.PLAYER_2_NODE[2] = load(Global.PLAYER_2_NODE_PATH[2])
		Global.PLAYER_2_NODE_INSTANCE[2] = Global.PLAYER_2_NODE[2].instantiate()
	Global.load_queue.load_stage_art()
	
	$FighterGame.setup()

func _input(event):
	input_helper(event)

func input_helper(event):
	if event.is_action_pressed("player1_start") or event.is_action_pressed("player2_start"):
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE and match_disconnected):
			MainMenuMusicControl.stop_music()
			main_menu()
	if (event.is_action_pressed("player1_cancel") or event.is_action_pressed("player2_cancel")):
		if (match_disconnected and Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			MainMenuMusicControl.stop_music()
			main_menu()

func display_debug_peers():
	var output = "My peer ID: " + str(multiplayer.get_unique_id())
	output += "\nPeers:\n"
	for id in SyncManager.peers.keys():
		var peer = SyncManager.peers[id]
		output += str(id)
		if (peer.spectator):
			output += " Spec."
		output += "\n"
	$CanvasLayer/DebugLabel.text = output

func _on_OnlineButton_pressed():
	display_debug_peers()
	if (Global.was_spectating):
		SyncManager.spectating = true
		
	if (SyncManager.spectating):
		$CanvasLayer/SpectatorLabel.text = "Spectating"
		Global.was_spectating = true
	else:
		$CanvasLayer/SpectatorLabel.text = ""
		
	$CanvasLayer/P1Name.text = Util.display_username(try_get_player_name(1))
	if (multiplayer.is_server()):
#       for testing rollbacks with 1 CPU player
#		fighter_game.get_node("ServerInputInterpreter").set_script(CPUInputInterpreter)
		$FighterGame/ServerInputInterpreter.set_multiplayer_authority(1)
		$FighterGame/ClientInputInterpreter.set_multiplayer_authority(get_opponent_peer_id())
		$CanvasLayer/P2Name.text = Util.display_username(try_get_player_name(get_opponent_peer_id()))
	else:
		if SyncManager.spectating:
			$FighterGame/ClientInputInterpreter.set_multiplayer_authority(get_client_player_peer_id())
			$CanvasLayer/P2Name.text = Util.display_username(try_get_player_name(get_client_player_peer_id()))
		else:
			$FighterGame/ClientInputInterpreter.set_multiplayer_authority(multiplayer.get_unique_id())
			$CanvasLayer/P2Name.text = Util.display_username(try_get_player_name(multiplayer.get_unique_id()))
	SyncManager.reset_network_adaptor()
	
	message_label.text = "Game loaded"

func try_get_player_name(peer_id: int) -> String:
	var result = OnlineMatch.get_player_names_by_peer_id()
	if (result.has(peer_id)):
		return result[peer_id]
	return ""

func _on_LocalButton_pressed():
	$FighterGame/ClientInputInterpreter.input_prefix = "player2_"
	SyncManager.network_adaptor = DummyNetworkAdaptor.new()
	if not is_replay():
		SyncManager.start()

func is_replay() -> bool:
	return Global.IS_REPLAY or ("replay" in OS.get_cmdline_args())
