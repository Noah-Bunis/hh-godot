extends CharacterSelect

class_name RPCCharacterSelect

@onready var message_label = $CanvasLayer/MessageLabel

var peer_ready = false
var all_peer_load_ready = 0

var p1_cursor_pos_row = -1
var p1_cursor_pos_col = -1
var p1_assist_pos_row = -1
var p1_assist_pos_col = -1

var p2_cursor_pos_row = -1
var p2_cursor_pos_col = -1
var p2_assist_pos_row = -1
var p2_assist_pos_col = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	character = [
		[Enums.PointCharacters.Ollie, Enums.PointCharacters.Suisei, Enums.PointCharacters.Kanata],
		[Enums.PointCharacters.Mio, Enums.PointCharacters.Subaru, Enums.PointCharacters.Oga],
		[Enums.PointCharacters.Subaru, Enums.PointCharacters.Subaru, Enums.PointCharacters.Subaru],
		[Enums.PointCharacters.Flayon, Enums.PointCharacters.Kurokami, Enums.PointCharacters.Subaru]
		]

	assist2 = [
		[Enums.AssistCharacters.Ollie, Enums.AssistCharacters.Suisei, Enums.AssistCharacters.Kanata, Enums.AssistCharacters.Fubuki, Enums.AssistCharacters.Hakka],
		[Enums.AssistCharacters.Mio, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Oga, Enums.AssistCharacters.Fubuki, Enums.AssistCharacters.OkaKoro],
		[Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Sana],
		[Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Sana]
		]
	assist1 = [
		[Enums.AssistCharacters.Hakka, Enums.AssistCharacters.Fubuki, Enums.AssistCharacters.Ollie, Enums.AssistCharacters.Suisei, Enums.AssistCharacters.Kanata],
		[Enums.AssistCharacters.OkaKoro, Enums.AssistCharacters.Fubuki, Enums.AssistCharacters.Mio, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Oga],
		[Enums.AssistCharacters.Sana, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru],
		[Enums.AssistCharacters.Sana, Enums.AssistCharacters.Sora, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru, Enums.AssistCharacters.Subaru]
		]
	
	update_p1_portrait(P1Cursor.row, P1Cursor.col)
	update_p2_portrait(P2Cursor.row, P2Cursor.col)
	WinCounterP1.update_win_count(true)
	WinCounterP2.update_win_count(false)

	multiplayer.peer_connected.connect(_on_network_peer_connected)
	multiplayer.peer_disconnected.connect(_on_network_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_network_peer_connected)
	multiplayer.connection_failed.connect(_on_network_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	OnlineMatch.connect("error", Callable(self, "_on_OnlineMatch_error"))
	OnlineMatch.connect("disconnected", Callable(self, "_on_OnlineMatch_disconnected"))
	OnlineMatch.connect("match_created", Callable(self, "_on_OnlineMatch_match_created"))
	OnlineMatch.connect("match_joined", Callable(self, "_on_OnlineMatch_match_joined"))
	OnlineMatch.connect("matchmaker_matched", Callable(self, "_on_OnlineMatch_matchmaker_matched"))
	OnlineMatch.connect("player_joined", Callable(self, "_on_OnlineMatch_player_joined"))
	OnlineMatch.connect("player_left", Callable(self, "_on_OnlineMatch_player_left"))
	OnlineMatch.connect("player_status_changed", Callable(self, "_on_OnlineMatch_player_status_changed"))
	OnlineMatch.connect("match_ready", Callable(self, "_on_OnlineMatch_match_ready"))
	OnlineMatch.connect("match_not_ready", Callable(self, "_on_OnlineMatch_match_not_ready"))
	
	update_p1_portrait(P1Cursor.row, P1Cursor.col)
	update_p2_portrait(P2Cursor.row, P2Cursor.col)
	WinCounterP1.update_win_count(true)
	WinCounterP2.update_win_count(false)
	var peer = multiplayer.get_unique_id()
	if (not SyncManager.spectating and not Global.was_spectating):
		if peer == 1:
			P2Cursor.queue_free()
			P2Portrait.texture = null
		else:
			P1Cursor.queue_free()
			P1Portrait.texture = null
	else:
		p1_ready = true
		p2_ready = true
		P2Cursor.queue_free()
		P2Portrait.texture = null
		P1Cursor.queue_free()
		P1Portrait.texture = null
	message_label.text = str(peer)
	MainMenuMusicControl.reset_seek()
	P1Cursor.deselect_ok = false
	P2Cursor.deselect_ok = false
	display_peer_ids()
	set_player_names()
	$TimeLimit.start(30)

func display_peer_ids():
	var output = "Peers:"
	output += "\n"
	for id in SyncManager.peers.keys():
		output += str(id) + "\n"
	$CanvasLayer/DebugLabel.text = output

func _on_OnlineMatch_error(message: String) -> void:
	print("ERROR: %s" % message)

func _on_OnlineMatch_disconnected() -> void:
	print("Disconnected from match.")

func _on_OnlineMatch_match_created(match_id: String) -> void:
	print("Private match created: %s" % match_id)

func _on_OnlineMatch_match_joined(match_id: String) -> void:
	print("Joined private match: %s" % match_id)

func _on_OnlineMatch_matchmaker_matched(players: Dictionary) -> void:
	print("Joined match via matchmaker")
	for player in players.values():
		print ("Player joined: %s" % Util.display_username(player.username))

func _on_OnlineMatch_player_joined(player: OnlineMatch.Player) -> void:
	print("Player joined: %s" % Util.display_username(player.username))

func _on_OnlineMatch_player_left(player: OnlineMatch.Player) -> void:
	print("Player left: %s" % Util.display_username(player.username))

func _on_OnlineMatch_player_status_changed(player: OnlineMatch.Player, status) -> void:
	print("Player status changed: %s -> %s" % [Util.display_username(player.username), status])
	if player.peer_id != SyncManager.network_adaptor.get_unique_id() && status == OnlineMatch.PlayerStatus.CONNECTED:
		rpc_id(player.peer_id, "receive_message", "Hi! We're connected now :-)")

@rpc("any_peer")
func receive_message(message: String) -> void:
	print("Message from %s: %s" % [multiplayer.get_remote_sender_id(), message])

func _on_OnlineMatch_match_not_ready() -> void:
	print("The match isn't ready to start")

func _on_OnlineMatch_match_ready(players: Dictionary) -> void:
	print("The match is ready to start! Here are players:")
	for player in players.values():
		print ("- %s" % Util.display_username(player.username))

### Remote Character Select

func connect_ui_elements():
	P2Cursor = $P2Cursor
	P1Cursor = $P1Cursor
	A1Portrait = $A1Portrait
	A2Portrait = $A2Portrait
	P1Portrait = $P1Portrait
	P2Portrait = $P2Portrait
	AkiMC = $AkiMC
	P1SelectFlash = $P1SelectFlash
	P2SelectFlash = $P2SelectFlash
	KimiNoHiroin = $KimiNoHiroin
	WinCounterP1 = $CanvasLayer/WinCounterP1
	WinCounterP2 = $CanvasLayer/WinCounterP2

@rpc("any_peer")
func remote_peer_select(row:int, col:int, color_number:int):
	var peer = multiplayer.get_remote_sender_id()
	message_label.text = str(peer) + " " + str(row) + " " + str(col)
	var charaData = resolve_characters(row, col)
	if peer == 1:
		Global.PLAYER_1_NODE_PATH[0] = charaData[0]
		Global.PLAYER_1_CHARACTER[0] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[0])
		if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
			Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])
		p1_color_number = color_number
		update_p1_portrait(row, col)
		P1Portrait.change_color_number(p1_color_number)
		P1SelectFlash.player_call()
	else:
		Global.PLAYER_2_NODE_PATH[0] = charaData[0]
		Global.PLAYER_2_CHARACTER[0] = charaData[1]
		p2_color_number = color_number
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[0])
		if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
			Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[2])
		update_p2_portrait(row, col)
		P2Portrait.change_color_number(p2_color_number)
		P2SelectFlash.player_call()

@rpc("any_peer") 
func remote_peer_assist_select(row:int, col:int, color_number:int):
	var peer = multiplayer.get_remote_sender_id()
	message_label.text = str(peer) + " " + str(row) + " " + str(col)
	if peer == 1:
		var charaData = resolve_assists(row, col, true)
		Global.PLAYER_1_NODE_PATH[1] = charaData[0]
		Global.PLAYER_1_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[1])
		a1_color_number = color_number
		update_a1_portrait(row, col)
		A1Portrait.change_color_number(a1_color_number)
		P1SelectFlash.player_call()
	else:
		var charaData = resolve_assists(row, col, false)
		Global.PLAYER_2_NODE_PATH[1] = charaData[0]
		Global.PLAYER_2_CHARACTER[1] = charaData[1]
		Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[1])
		a2_color_number = color_number
		update_a2_portrait(row, col)
		A2Portrait.change_color_number(a2_color_number)
		P2SelectFlash.player_call()

func players_ready():
	var peer = multiplayer.multiplayer_peer.get_unique_id()
	if peer == 1:
		return peer_ready and p1_ready
	else:
		return peer_ready and p2_ready

func update_p1():
	message_label.text = "p1 update"
	p1_cursor_pos_row = P1Cursor.row
	p1_cursor_pos_col = P1Cursor.col
	p1_color_number = select_color(P1Cursor.input_prefix)
	P1Portrait.change_color_number(p1_color_number)
	rpc("remote_peer_select", P1Cursor.row, P1Cursor.col, p1_color_number)
	var charaData = resolve_characters(P1Cursor.row, P1Cursor.col)
	Global.PLAYER_1_NODE_PATH[0] = charaData[0]
	Global.PLAYER_1_CHARACTER[0] = charaData[1]
	p1_assist_select = AssistSelect.instantiate()
	add_child(p1_assist_select)
	p1_assist_select.deselect_ok(false)
	p1_assist_select.position.x = 966
	p1_assist_select.position.y = 300
	p1_assist_select.setup(true, true)
	p1_assist_select.get_node("CharacterCursor").connect("change_character", Callable(self, "update_a1_portrait"))
	p1_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(self, "update_a1"))
	p1_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(P1SelectFlash, "player_call"))
	p1_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(AkiMC, "p1_call"))
	update_a1_portrait(p1_assist_select.cursor_row(), p1_assist_select.cursor_col())
	Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[0])
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])

func update_p2():
	message_label.text = "p2 update"
	p2_cursor_pos_row = P2Cursor.row
	p2_cursor_pos_col = P2Cursor.col
	p2_color_number = select_color(P2Cursor.input_prefix)
	P2Portrait.change_color_number(p2_color_number)
	rpc("remote_peer_select", P2Cursor.row, P2Cursor.col, p2_color_number)
	var charaData = resolve_characters(P2Cursor.row, P2Cursor.col)
	Global.PLAYER_2_NODE_PATH[0] = charaData[0]
	Global.PLAYER_2_CHARACTER[0] = charaData[1]
	p2_assist_select = AssistSelect.instantiate()
	add_child(p2_assist_select)
	p2_assist_select.deselect_ok(false)
	p2_assist_select.position.x = 966
	p2_assist_select.position.y = 300
	p2_assist_select.setup(false, true) # online is P1 only
	p2_assist_select.get_node("CharacterCursor").connect("change_character", Callable(self, "update_a2_portrait"))
	p2_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(self, "update_a2"))
	p2_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(P2SelectFlash, "player_call"))
	p2_assist_select.get_node("CharacterCursor").connect("select_chara", Callable(AkiMC, "p2_call"))
	update_a2_portrait(p2_assist_select.cursor_row(), p2_assist_select.cursor_col())
	Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[0])
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[2])

@rpc("any_peer") func update_a1():
	message_label.text = "a1 update"
	var charaData = resolve_assists(p1_assist_select.cursor_row(), p1_assist_select.cursor_col(), true)
	Global.PLAYER_1_NODE_PATH[1] = charaData[0]
	Global.PLAYER_1_CHARACTER[1] = charaData[1]
	Global.load_queue.queue_resource(Global.PLAYER_1_NODE_PATH[1])
	
	p1_assist_pos_row = p1_assist_select.cursor_row()
	p1_assist_pos_col = p1_assist_select.cursor_col()
	a1_color_number = select_color(p1_assist_select.get_node("CharacterCursor").input_prefix)
	A1Portrait.change_color_number(a1_color_number)
	rpc("remote_peer_assist_select", p1_assist_select.cursor_row(), p1_assist_select.cursor_col(), a1_color_number)
	p1_ready = true
	rpc("ready_up_peer")
	local_ready()

func update_a2():
	message_label.text = "a2 update"
	var charaData = resolve_assists(p2_assist_select.cursor_row(), p2_assist_select.cursor_col(), false)
	Global.PLAYER_2_NODE_PATH[1] = charaData[0]
	Global.PLAYER_2_CHARACTER[1] = charaData[1]
	Global.load_queue.queue_resource(Global.PLAYER_2_NODE_PATH[1])
	
	p2_assist_pos_row = p2_assist_select.cursor_row()
	p2_assist_pos_col = p2_assist_select.cursor_col()
	a2_color_number = select_color(p2_assist_select.get_node("CharacterCursor").input_prefix)
	A2Portrait.change_color_number(a2_color_number)
	rpc("remote_peer_assist_select", p2_assist_select.cursor_row(), p2_assist_select.cursor_col(), a2_color_number)
	p2_ready = true
	rpc("ready_up_peer")
	local_ready()

@rpc("any_peer") func ready_up_peer():
	peer_ready = true
	message_label.text = "peer_ready"
	if (players_ready()):
		message_label.text = "teams selected!"
		start_loading_process()

func local_ready():
	if (players_ready()):
		message_label.text = "locally: teams selected!"
		start_loading_process()

func music_load():
	#MainMenuMusicControl.stop_music() TODO: Is there a loading song? eventually maybe
	
	#Global.STAGE_ART_ID = stage_id
	#Global.BGM_ID = bgm_id
	#if (evaluate_p1_side_bgm()):
		#Global.BGM_IS_P1_SIDE = true
	#else:
		#Global.BGM_IS_P1_SIDE = false
	Global.STAGE_ART_ID = 1
	Global.BGM_ID = 1
	Global.STAGE_RANDOM_ONCE = true
	Global.BGM_RANDOM_ONCE = true
	#MainMenuMusicControl.play_cursor_select()

func start_loading_process():
	Global.SET_TOTAL = 0
	Global.P1_SET_WIN_TOTAL = 0
	WinCounterP1.update_win_count(true)
	WinCounterP2.update_win_count(false)
	resolve_colors()
	resolve_assist_colors()
	display_colors()
	
	if (SyncManager.spectating):
		SyncManager.input_delay = 10
	message_label.text = "Loading teams..."
	Global.PLAYER_1_NODE[0] = Global.load_queue.get_resource(Global.PLAYER_1_NODE_PATH[0])
	Global.PLAYER_1_NODE_INSTANCE[0] = Global.PLAYER_1_NODE[0].instantiate()
	
	Global.PLAYER_2_NODE[0] = Global.load_queue.get_resource(Global.PLAYER_2_NODE_PATH[0])
	Global.PLAYER_2_NODE_INSTANCE[0] = Global.PLAYER_2_NODE[0].instantiate()
	
	Global.PLAYER_1_NODE[1] = Global.load_queue.get_resource(Global.PLAYER_1_NODE_PATH[1])
	Global.PLAYER_1_NODE_INSTANCE[1] = Global.PLAYER_1_NODE[1].instantiate()
	
	Global.PLAYER_2_NODE[1] = Global.load_queue.get_resource(Global.PLAYER_2_NODE_PATH[1])
	Global.PLAYER_2_NODE_INSTANCE[1] = Global.PLAYER_2_NODE[1].instantiate()
	if (Global.PLAYER_1_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.PLAYER_1_NODE[2] = Global.load_queue.get_resource(Global.PLAYER_1_NODE_PATH[2])
		Global.PLAYER_1_NODE_INSTANCE[2] = Global.PLAYER_1_NODE[2].instantiate()
	if (Global.PLAYER_2_CHARACTER[0] == Enums.PointCharacters.Mio):
		Global.PLAYER_2_NODE[2] = Global.load_queue.get_resource(Global.PLAYER_2_NODE_PATH[2])
		Global.PLAYER_2_NODE_INSTANCE[2] = Global.PLAYER_2_NODE[2].instantiate()
	Global.load_queue.load_stage_art()
	music_load()
	message_label.text = "Load complete, waiting on peer"
	rpc_id(1, "peer_load_queue_ready")

func display_colors():
	var output = ""
	output += str(p1_cursor_pos_row)+" "
	output += str(p1_cursor_pos_col)+" "
	output += str(p2_cursor_pos_row)+" "
	output += str(p2_cursor_pos_col)+" "
	output += "\n"
	output += str(p1_assist_pos_row)+" "
	output += str(p1_assist_pos_col)+" "
	output += str(p2_assist_pos_row)+" "
	output += str(p2_assist_pos_col)+" "
	$CanvasLayer/DebugLabel.text = output
	

@rpc("any_peer", "call_local") func peer_load_queue_ready():
	all_peer_load_ready += 1
	message_label.text = "# of peers loaded: " + str(all_peer_load_ready)
	if (is_all_load_ready()):
		message_label.text = "All peers loading completed!"
		if (get_tree().get_multiplayer().is_server()):
			rpc("go_to_next_scene")

func is_all_load_ready() -> bool:
	return all_peer_load_ready >= SyncManager.peers.size() + 1

@rpc("any_peer", "call_local")
func go_to_next_scene():
	message_label.text = "going to match..."
	print("go to next scene")
	get_tree().change_scene_to_file("res://game/DemoMain.tscn")

func physics_tick():
	if ($CanvasLayer/RemainingTime.visible):
		$CanvasLayer/RemainingTime.text = str(int($TimeLimit.time_left+1))

func _input(event):
	pass

func input_helper(event):
	pass

func _on_network_peer_connected(peer_id: int):
	message_label.text = "CONNECTED "+str(peer_id)
	display_peer_ids()

func _on_network_peer_disconnected(peer_id: int):
	message_label.text = "Disconnected "+str(peer_id)
	display_peer_ids()
	if (SyncManager.get_player_peer_count() < 1):
		exit()
	elif (is_all_load_ready()):
		if (get_tree().get_multiplayer().is_server()):
			rpc("go_to_next_scene")

func exit():
	MainMenuMusicControl.play_main_menu_music()
	if (Global.NETPLAY_MODE == Global.NETPLAY_MODES.PRIVATE_ROOM):
		OnlineMatch.leave()
		SyncManager.clear_peers()
		OnlineLobby.send_status_update(OnlineLobby.CHALLENGE_STATE.IDLE)
		get_tree().change_scene_to_file("res://game/menus/onlinemenu/PrivateRoom.tscn")
	elif (Global.NETPLAY_MODE == Global.NETPLAY_MODES.PUBLIC_QUEUE):
		OnlineMatch.leave()
		SyncManager.clear_peers()
		get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")
	else:
		get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")

func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)

func get_opponent_peer_id() -> int:
	if (SyncManager.get_player_peer_count() >= 1):
		if (SyncManager.get_player_peer_ids()[0] != SyncManager.network_adaptor.get_unique_id()):
			return SyncManager.get_player_peer_ids()[0]
		else:
			return SyncManager.get_player_peer_ids()[1]
	printerr ("Main: unable to find opponent peer id")
	message_label.text = "unable to find opponent's peer id"
	return 1

func get_client_player_peer_id() -> int:
	if (SyncManager.get_player_peer_count() >= 1):
		if (SyncManager.get_player_peer_ids()[0] != 1):
			return SyncManager.get_player_peer_ids()[0]
		else:
			return SyncManager.get_player_peer_ids()[1]
	printerr ("Main: unable to find client peer id")
	message_label.text = "unable to find client peer id"
	return 1

func set_player_names():
	$CanvasLayer/P1Name.text = Util.display_username(try_get_player_name(1))
	if (multiplayer.is_server()):
		$CanvasLayer/P2Name.text = Util.display_username(try_get_player_name(get_opponent_peer_id()))
	else:
		if SyncManager.spectating:
			$CanvasLayer/P2Name.text = Util.display_username(try_get_player_name(get_client_player_peer_id()))
		else:
			$CanvasLayer/P2Name.text = Util.display_username(try_get_player_name(multiplayer.get_unique_id()))

func try_get_player_name(peer_id: int) -> String:
	var result = OnlineMatch.get_player_names_by_peer_id()
	if (result.has(peer_id)):
		return result[peer_id]
	return ""

func _on_TimeLimit_timeout():
	exit()
