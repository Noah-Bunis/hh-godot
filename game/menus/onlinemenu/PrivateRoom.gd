extends Node2D

@onready var Challenge = load("res://game/menus/onlinemenu/Challenge.tscn")
@onready var PlayerCard = load("res://game/menus/onlinemenu/LobbyPlayerCard.tscn")
@onready var WebRTCNetworkAdaptor = load("res://addons/godot-rollback-netcode/NakamaWebRTCNetworkAdaptor.gd")
var challenges:Array = []
var challenges_sent:Dictionary = {}

var challenge_state: int = OnlineLobby.CHALLENGE_STATE.IDLE
var player_cards: Dictionary = {}
var player_cards_order: Array = []

var peer_ready: Dictionary = {}

func _ready() -> void:
	if (OnlineLobby.match_id == ""):
		print("Lobby is already closed")
		exit_lobby()
		return
	MainMenuMusicControl.play_main_menu_music()
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.PRIVATE_ROOM
	SyncManager.network_adaptor = WebRTCNetworkAdaptor.new()
	$CanvasLayer/RoomIDField.secret = true
	$CanvasLayer/BattleVersionLabel.text = tr("UI_LABEL_BATTLE_VERSION").format({"version": Global.BATTLE_ENGINE_VERSION})
	$CanvasLayer/GridContainer/CopyRoomID.grab_focus()
	SyncManager.input_delay = 2
	$CanvasLayer/GridContainer/InputDelayMeter.value = SyncManager.input_delay
	$CanvasLayer/ErrorLabel.visible = false
	challenge_state = OnlineLobby.CHALLENGE_STATE.IDLE
	
	if (Global.IS_PUBLIC_LOBBY):
		$CanvasLayer/RoomIDLabel.hide()
		$CanvasLayer/RoomIDField.hide()
		$CanvasLayer/GridContainer/CopyRoomID.hide()
		$CanvasLayer/GridContainer/HideRoomID.hide()
	
	join_an_online_match()
	print("PrivateRoom _ready complete")

func join_an_online_match() -> void:
	# Connect to all of OnlineLobby's signals.
	OnlineLobby.connect("error", Callable(self, "_on_OnlineLobby_error"))
	OnlineLobby.connect("disconnected", Callable(self, "_on_OnlineLobby_disconnected"))
	OnlineLobby.connect("match_created", Callable(self, "_on_OnlineLobby_match_created"))
	OnlineLobby.connect("match_joined", Callable(self, "_on_OnlineLobby_match_joined"))
	OnlineLobby.connect("player_joined", Callable(self, "_on_OnlineLobby_player_joined"))
	OnlineLobby.connect("player_left", Callable(self, "_on_OnlineLobby_player_left"))
	OnlineLobby.connect("player_status_changed", Callable(self, "_on_OnlineLobby_player_status_changed"))
	OnlineLobby.connect("challenge_status_changed", Callable(self, "_on_OnlineLobby_lobby_status_changed"))
	OnlineLobby.connect("match_ready", Callable(self, "_on_OnlineLobby_match_ready"))
	OnlineLobby.connect("match_not_ready", Callable(self, "_on_OnlineLobby_match_not_ready"))
	
	OnlineLobby.connect("challenge_received", Callable(self, "_on_OnlineLobby_challenge_received"))
	OnlineLobby.connect("challenge_accepted", Callable(self, "_on_OnlineLobby_challenge_accepted"))
	OnlineLobby.connect("game_id_received", Callable(self, "join_isolated_game"))
	
	OnlineLobby.connect("spectate_request_received", Callable(self, "_on_OnlineLobby_spectate_request_received"))
	OnlineLobby.connect("spectate_request_accepted", Callable(self, "_on_OnlineLobby_spectate_request_accepted"))
	
	OnlineMatch.connect("error", Callable(self, "_on_OnlineMatch_error"))
	#OnlineMatch.connect("error_code", Callable(self, "_on_OnlineMatch_error_code"))
	OnlineMatch.connect("match_created", Callable(self, "_on_OnlineMatch_match_created"))
	OnlineMatch.connect("match_joined", Callable(self, "_on_OnlineMatch_match_joined"))
	OnlineMatch.connect("match_left", Callable(self, "_on_OnlineMatch_match_left"))
	OnlineMatch.connect("match_ready", Callable(self, "_on_OnlineMatch_match_ready"))
	OnlineMatch.connect("match_not_ready", Callable(self, "_on_OnlineMatch_match_not_ready"))
	OnlineMatch.connect("player_joined", Callable(self, "_on_OnlineMatch_match_player_joined"))
	OnlineMatch.connect("player_left", Callable(self, "_on_OnlineMatch_match_player_left"))
	OnlineMatch.connect("player_status_changed", Callable(self, "_on_OnlineMatch_player_status_changed"))
	OnlineMatch.connect("webrtc_peer_added", Callable(self, "_on_OnlineMatch_webrtc_peer_added"))
	OnlineMatch.connect("webrtc_peer_removed", Callable(self, "_on_OnlineMatch_webrtc_peer_removed"))
	OnlineMatch.connect("disconnected", Callable(self, '_on_OnlineMatch_disconnected'))
	
	SyncManager.connect("peer_added", Callable(self, "_on_SyncManager_peer_added"))
	SyncManager.connect("peer_removed", Callable(self, "_on_SyncManager_peer_removed"))
	
	OnlineMatch.leave()

	$CanvasLayer/RoomIDField.text = OnlineLobby.match_id
	SyncManager.spectating = false
	Global.was_spectating = false
	if (OnlineLobby.match_id == ""):
		print("ERROR: No match id!")
		update_message_log("ERROR: No match id!")
		exit_lobby()
		
	Global.MATCH_TOTAL = 0
	Global.SET_TOTAL = 0
	Global.P1_WIN_TOTAL = 0
	Global.P1_SET_WIN_TOTAL = 0
	
	update_ui()
	OnlineLobby.clear_my_spectators()
	init_player_list(OnlineLobby.players)



func _on_OnlineMatch_match_left():
	print("OnlineMatch left")

func _on_OnlineMatch_match_player_left(player):
	print(str(player) + " left")

func _on_OnlineMatch_match_not_ready():
	print("Match not ready")

func _on_OnlineMatch_webrtc_peer_added (webrtc_peer, player):
	pass
	#print("webrtc peer added " + str(webrtc_peer))

func _on_OnlineMatch_webrtc_peer_removed (webrtc_peer, player):
	pass
	#print("webrtc peer removed " + str(webrtc_peer))

func _on_OnlineLobby_error(message: String) -> void:
	print("ERROR: %s" % message)
	$CanvasLayer/ErrorLabel.visible = true
	$CanvasLayer/ErrorLabel.text = tr("UI_LABEL_ERROR").format({"message": message})
	update_ui()

func _on_OnlineLobby_disconnected() -> void:
	print("Disconnected from lobby.")
	update_message_log("Disconnected from lobby")
	exit_lobby()

func _on_OnlineLobby_match_created(match_id: String) -> void:
	print("Private match created: %s" % match_id)
	update_message_log("Private match created: " + match_id)
	update_ui()

func _on_OnlineLobby_match_joined(match_id: String) -> void:
	print("Joined private match: %s" % match_id)
	update_message_log("Joined private match: " + match_id)
	update_ui()

func _on_OnlineLobby_player_joined(player: OnlineLobby.Player) -> void:
	print("Player joined: %s" % Util.display_username(player.username))
	update_message_log("Player joined: " + Util.display_username(player.username))
	update_ui()

	if (player.session_id != OnlineLobby.my_session_id):
		add_player_list(player)

func update_ui() -> void:
	$CanvasLayer/SpectatorLabel.text = get_spectator_ids()
	$CanvasLayer/NameLabel.text = Util.display_username(Global.nakama_session.username)
	$CanvasLayer/DebugLabel.text = get_debug_session_ids()
	if (challenge_state == OnlineLobby.CHALLENGE_STATE.IN_GAME):
		$Background.self_modulate = Color("#6f0f08")
	elif (challenge_state == OnlineLobby.CHALLENGE_STATE.CHALLENGING):
		$Background.self_modulate = Color("#6f4708")
	elif (challenge_state == OnlineLobby.CHALLENGE_STATE.DECIDING):
		$Background.self_modulate = Color("#162d69")
	elif (challenge_state == OnlineLobby.CHALLENGE_STATE.SPECTATING):
		$Background.self_modulate = Color("#4c004f")
	else:
		$Background.self_modulate = Color("#16483a")

func get_debug_session_ids() -> String:
	var output = "PeerIDs:\n"
	for key in SyncManager.peers.keys():
		output += str(key) + "\n"
	return output

func get_spectator_ids() -> String:
	var output = "Spectators:\n"
	for key in OnlineLobby.my_spectators.keys():
		output += str(Util.display_username(OnlineLobby.players[key].username)) + "\n"
	return output

func _on_OnlineLobby_player_left(player: OnlineLobby.Player) -> void:
	print("Player left lobby: %s" % Util.display_username(player.username))
	update_message_log("Player left lobby: " + Util.display_username(player.username))
	remove_player_list(player)
	update_ui()

func _on_OnlineLobby_player_status_changed(player: OnlineLobby.Player, status) -> void:
	print("Player status changed: %s -> %s" % [Util.display_username(player.username), status])
	update_ui()

func _on_OnlineLobby_lobby_status_changed(session_id: String, status: int) -> void:
	print("Lobby status changed: %s -> %d" % [session_id, status])
	if (player_cards.has(session_id)):
		player_cards[session_id].update_status(status)
	update_ui()

func _on_OnlineLobby_challenge_received(sender: String, is_connect: bool) -> void:
	if (is_connect):
		if (challenge_state == OnlineLobby.CHALLENGE_STATE.CHALLENGING || challenge_state == OnlineLobby.CHALLENGE_STATE.SPECTATING):
			decline_challenge(sender)
		else:
			update_message_log("Challenge Received")
			var challenge = Challenge.instantiate()
			challenge.from = OnlineLobby.players[sender]
			challenge.connect("accept_result", Callable(self, "accept_challenge"))
			if (challenges.is_empty()):
				add_child(challenge)
			update_challenge_status(OnlineLobby.CHALLENGE_STATE.DECIDING)
			challenges.push_back(challenge)
			MainMenuMusicControl.play_cursor_select()
	else:
		delete_challenge_pop_up(false)
		OnlineMatch.leave()
	update_ui()

func _on_OnlineLobby_challenge_accepted(sender: String, accepted: bool) -> void:
	if (accepted):
		update_message_log("Opponent accepted challenge")
		create_new_match(sender)
	else:
		update_message_log("Opponent declined challenge")
		take_down_challenge(sender)
	update_ui()

func _on_OnlineLobby_spectate_request_received(sender: String, is_connect: bool) -> void:
	if (is_connect):
		if (challenge_state == OnlineLobby.CHALLENGE_STATE.SPECTATING):
			OnlineLobby.accept_spectate_request(sender, false)
			update_ui()
			return
		OnlineLobby.accept_spectate_request(sender, true)
		update_message_log("Spectator received: " + sender)
	else:
		update_message_log("Spectator disconnected: " + sender)
	update_ui()

func _on_OnlineLobby_spectate_request_accepted(sender: String, is_connect: bool) -> void:
	if (is_connect):
		update_message_log("Spectate request accepted: " + sender)
		SyncManager.spectating = true
		player_cards[sender].spectating = true
		update_challenge_status(OnlineLobby.CHALLENGE_STATE.SPECTATING)
	else:
		update_message_log("Spectate request denied: " + sender)
		player_cards[sender].spectating = false
		update_challenge_status(OnlineLobby.CHALLENGE_STATE.IDLE)
	update_ui()

func take_down_challenge(sender: String) -> void:
	if (challenges_sent.has(sender)):
		challenges_sent.erase(sender)
	if (challenges_sent.is_empty()):
		update_challenge_status(OnlineLobby.CHALLENGE_STATE.IDLE)
	if (player_cards.has(sender)):
		player_cards[sender].challenging = false
	update_ui()

func _on_OnlineMatch_error(message: String) -> void:
	print("ERROR: %s" % message)
	update_message_log("ERROR: " + message)
	update_ui()
#
#func _on_OnlineMatch_error_code(code, message, extra) -> void:
	#if (extra != null):
		#print("ERROR details: %s" % str(extra))
		#update_message_log("ERROR details: " + str(extra))
		#update_ui()

func _on_OnlineMatch_match_created(match_id: String) -> void:
	print("Private match created: %s" % match_id)
	update_message_log("Private game created: " + match_id)
	SyncManager.clear_peers()
	OnlineLobby.send_game_id(OnlineLobby.isolated_match_session_id, OnlineMatch.match_id)
	update_ui()

func _on_OnlineMatch_match_joined(match_id: String) -> void:
	print("Joined private match: %s" % match_id)
	update_message_log("Joined private game: " + match_id)
	update_ui()

func _on_OnlineMatch_match_ready(players: Dictionary) -> void:
	print("The match is ready to start! Here are players:")
	# a match can be ready before all players have arrived
	update_message_log("Match is ready")
	print(get_tree().get_multiplayer().get_peers())
	for player in players.values():
		print ("- %s" % Util.display_username(player.username))
	update_ui()

func _on_OnlineMatch_match_player_joined(player: OnlineMatch.Player) -> void:
	update_message_log("Joined: " + str(player.peer_id) + " " + str(player.session_id))

func _on_OnlineMatch_player_status_changed(player: OnlineMatch.Player, status) -> void:
	print("Player status changed: %s -> %s" % [Util.display_username(player.username), status])
	#update_message_log("My Sync ID: " + str(SyncManager.network_adaptor.get_unique_id()))
	if player.peer_id != SyncManager.network_adaptor.get_unique_id() && status == OnlineMatch.PlayerStatus.CONNECTED:
		update_message_log("Connected: " + str(player.peer_id))
		try_add_SyncManager_peer(player.peer_id, player.session_id, OnlineLobby.host_players)
		rpc_id(player.peer_id, "receive_message_OnlineMatch", "Hi! We're connected now :-)")
	update_ui()

@rpc("any_peer") func receive_message_OnlineMatch(message: String) -> void:
	print("Message from %s: %s" % [get_tree().get_multiplayer().get_remote_sender_id(), message])
	update_ui()

func try_add_SyncManager_peer(peer_id, session_id, player_ids):
	print ("private room: Trying peer add " + str(peer_id))
	if (session_id != OnlineMatch.my_session_id):
		if (OnlineMatch.players.has(OnlineMatch.my_session_id) and
				peer_id != OnlineMatch.players[OnlineMatch.my_session_id].peer_id):
			#print("Host ID?: " + str(OnlineMatch.players[OnlineMatch.my_session_id].peer_id))
			SyncManager.add_peer(peer_id, {spectator = !player_ids.has(session_id)})
			if (not player_ids.has(session_id)):
				print ("private room: Added spectator: " + str(peer_id))
			else:
				print ("private room: Added player: " + str(peer_id))
		else:
			print ("private room: Session id mismatch or missing, but same peer id")
	update_ui()

func create_new_match(sender: String) -> void:
	OnlineMatch.create_match(Global.nakama_socket)
	OnlineLobby.isolated_match_session_id = sender
	update_ui()

func join_isolated_game(sender: String, game_id: String) -> void:
	if (game_id.length() >= 50):
		printerr("Game id longer than 50 chars, should only be 37 characters")
		game_id = game_id.substr(0, 50)
	SyncManager.clear_peers()
	OnlineMatch.join_match(Global.nakama_socket, game_id)
	update_ui()

func receive_message(message: String) -> void:
	print("Message: %s" % [message])
	update_ui()

func _on_OnlineLobby_match_not_ready() -> void:
	print("The lobby isn't ready to start")
	update_ui()

func _on_OnlineLobby_match_ready(players: Dictionary) -> void:
	print("The lobby is ready to start! Here are players:")

	update_message_log("Lobby is starting!")
	for player in players.values():
		print ("- %s" % Util.display_username(player.username))
	update_ui()

func _on_SyncManager_peer_added(peer_id) -> void:
	print ("private room: SyncManager peer add: " + str(peer_id))
	if (SyncManager.peers.size() == OnlineMatch.players.size() - 1):
		print("telling the host we're ready")
		ready_up.rpc(get_tree().get_multiplayer().get_unique_id())
	update_ui()

func _on_SyncManager_peer_removed(peer_id) -> void:
	print ("private room: SyncManager peer removed: " + str(peer_id))

func _on_OnlineMatch_disconnected() -> void:
	update_ui()

func accept_challenge(accept_result: bool, sender: String):
	if (accept_result):
		update_message_log("You accepted challenge")
		OnlineLobby.accept_challenge(sender, true)
		delete_challenge_pop_up(true)
		for challenge in challenges:
			# decline other challenges
			decline_challenge(challenge.get_session_id())
			delete_challenge_pop_up(true)
	else:
		update_message_log("You declined challenge")
		decline_challenge(sender)
		delete_challenge_pop_up(false)
	update_ui()

func decline_challenge(sender: String):
	OnlineLobby.accept_challenge(sender, false)
	update_ui()

@rpc("any_peer", "call_local")
func ready_up(peer_id) -> void:
	if (get_tree().get_multiplayer().is_server()):
		print("Ready up peer: " + str(peer_id))
		peer_ready[peer_id] = true
		if (peer_ready.size() >= OnlineMatch.players.size()):
			print("Start game rpc")
			rpc("start_game")
	update_ui()

@rpc("any_peer", "call_local") func start_game() -> void:
	update_message_log("Starting up the game!")
	if (OnlineMatch.get_match_state() != OnlineMatch.MatchState.PLAYING):
		OnlineMatch.start_playing()
	update_challenge_status(OnlineLobby.CHALLENGE_STATE.IN_GAME)
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineCharacterSelect.tscn")
	update_ui()

func delete_challenge_pop_up(accepted: bool):
	if (not challenges.is_empty()):
		var challenge = challenges.pop_front()
		challenge.disconnect("accept_result", Callable(self, "accept_challenge"))
		challenge.queue_free()
		challenge = null
	
	if (challenges.is_empty()):
		if (accepted):
			update_challenge_status(OnlineLobby.CHALLENGE_STATE.CHALLENGING)
		else:
			update_challenge_status(OnlineLobby.CHALLENGE_STATE.IDLE)
		$CanvasLayer/GridContainer/InputDelayMeter.grab_focus()
	else:
		if (accepted):
			update_challenge_status(OnlineLobby.CHALLENGE_STATE.CHALLENGING)
		else:
			update_challenge_status(OnlineLobby.CHALLENGE_STATE.DECIDING)
		var challenge = challenges[0]
		add_child(challenge)
	update_ui()

func _on_InputDelayMeter_value_changed(value):
	$CanvasLayer/GridContainer/InputDelayLabel.text = tr("UI_LABEL_INPUT_DELAY").format({"frames": int(value)})
	SyncManager.set_input_delay(int($CanvasLayer/GridContainer/InputDelayMeter.value))
	update_ui()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_lobby()

func exit_lobby():
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/LoginToServer.tscn")
	OnlineLobby.leave()
	OnlineMatch.leave()
	SyncManager.stop()
	SyncManager.clear_peers()
	SyncManager.reset_network_adaptor()

func init_player_list(players):
	for session_id in players.keys():
		if (session_id != OnlineLobby.my_session_id):
			add_player_list(players[session_id], players[session_id].status)
	update_ui()

func add_player_list(player, status=OnlineLobby.CHALLENGE_STATE.IDLE):
	player_cards[player.session_id] = PlayerCard.instantiate()
	player_cards[player.session_id].player = player
	player_cards[player.session_id].name = player.session_id
	player_cards[player.session_id].update_status(status)
	$CanvasLayer/ScrollContainer/VBox.add_child(player_cards[player.session_id])
	player_cards[player.session_id].connect("challenge", Callable(self, "send_challenge"))
	player_cards[player.session_id].connect("spectate", Callable(self, "send_spectate_request"))
	player_cards_order.append(player_cards[player.session_id])
	if (player_cards.size() == 1):
		player_cards[player.session_id].get_node("Challenge").focus_neighbor_top = player_cards[player.session_id].get_node("Challenge").get_path_to($CanvasLayer/GridContainer/InputDelayMeter)
		player_cards[player.session_id].get_node("Spectate").focus_neighbor_top = player_cards[player.session_id].get_node("Spectate").get_path_to($CanvasLayer/GridContainer/InputDelayMeter)
		$CanvasLayer/GridContainer/InputDelayMeter.focus_neighbor_bottom = $CanvasLayer/GridContainer/InputDelayMeter.get_path_to(player_cards[player.session_id].get_node("Challenge"))
	update_ui()
	MainMenuMusicControl.play_cursor_select()

func remove_player_list(player):
	# remove any challenges or spectates sent to the player
	take_down_challenge(player.session_id)
	self_disconnect_spectate_request(player.session_id)
	
	player_cards[player.session_id].disconnect("challenge", Callable(self, "send_challenge"))
	player_cards[player.session_id].disconnect("spectate", Callable(self, "send_spectate_request"))
	if (player_cards[player.session_id].has_focus() and challenges.is_empty()):
		$CanvasLayer/GridContainer/InputDelayMeter.grab_focus() # TODO: ideally this hops onto the next item in the list (backwards)
	$CanvasLayer/ScrollContainer/VBox.remove_child(player_cards[player.session_id])
	player_cards[player.session_id].queue_free()
	player_cards_order.erase(player_cards[player.session_id])
	player_cards.erase(player.session_id)
	if (player_cards_order.size() == 1):
		player_cards_order[0].get_node("Challenge").focus_neighbor_top = player_cards_order[0].get_node("Challenge").get_path_to($CanvasLayer/GridContainer/InputDelayMeter)
		player_cards_order[0].get_node("Spectate").focus_neighbor_top = player_cards_order[0].get_node("Spectate").get_path_to($CanvasLayer/GridContainer/InputDelayMeter)
		$CanvasLayer/GridContainer/InputDelayMeter.focus_neighbor_bottom = $CanvasLayer/GridContainer/InputDelayMeter.get_path_to(player_cards_order[0].get_node("Challenge"))
	elif (player_cards_order.size() == 0):
		$CanvasLayer/GridContainer/InputDelayMeter.focus_neighbor_bottom = NodePath("")
	update_ui()

func _on_copy_room_id_pressed():
	DisplayServer.clipboard_set(OnlineLobby.match_id) 
	update_message_log("Copied Room ID to clipboard")
	update_ui()

func _on_hide_room_id_pressed():
	$CanvasLayer/RoomIDField.secret = !$CanvasLayer/RoomIDField.secret
	if (not $CanvasLayer/RoomIDField.secret):
		$CanvasLayer/RoomIDField.text = str(OnlineLobby.match_id) 
		update_message_log("Showing room ID")
	else: 
		update_message_log("Hiding room ID")
	update_ui()

func send_challenge(session_id: String, already_challenging: bool):
	if (not already_challenging):
		if (OnlineLobby.players[(session_id)].status == OnlineLobby.CHALLENGE_STATE.IDLE or 
				OnlineLobby.players[(session_id)].status == OnlineLobby.CHALLENGE_STATE.DECIDING):
			if (not challenges_sent.has(session_id)):
				if (challenge_state == OnlineLobby.CHALLENGE_STATE.SPECTATING):
					disconnect_spectate_request(session_id)
				update_challenge_status(OnlineLobby.CHALLENGE_STATE.CHALLENGING)
				OnlineLobby.send_challenge(session_id)
				challenges_sent[session_id] = true
				if (player_cards.has(session_id)):
					player_cards[session_id].challenging = true
				update_message_log("Send Challenge")
				SyncManager.spectating = false
			else:
				# should be unreachable
				update_message_log("Already sent challenge")
		else:
			update_message_log("Can only challenge an idle player or someone being challenged")
	else:
		take_down_challenge(session_id)
		OnlineLobby.send_challenge_disconnect(session_id)
		update_message_log("Cancelled challenge")
		OnlineMatch.leave()
	update_ui()

func send_spectate_request(session_id: String, is_already_spectating: bool):
	if (not is_already_spectating):
		if (not OnlineLobby.players[(session_id)].status == OnlineLobby.CHALLENGE_STATE.SPECTATING and
				not OnlineLobby.players[(session_id)].status == OnlineLobby.CHALLENGE_STATE.IN_GAME):
			if (challenge_state == OnlineLobby.CHALLENGE_STATE.IDLE):
				OnlineLobby.send_spectate_request(session_id)
				update_challenge_status(OnlineLobby.CHALLENGE_STATE.SPECTATING)
				update_message_log("Send spectate request")
		else:
			update_message_log("Cannot spectate someone in a game or another spectator")
	else:
		disconnect_spectate_request(session_id)
		update_challenge_status(OnlineLobby.CHALLENGE_STATE.IDLE)
		update_message_log("Cancelled spectate request")
	update_ui()

func disconnect_spectate_request(session_id):
	OnlineLobby.send_spectate_disconnect_request(session_id)
	self_disconnect_spectate_request(session_id)
	update_ui()

func self_disconnect_spectate_request(session_id):
	if (player_cards.has(session_id)):
		player_cards[session_id].spectating = false
	SyncManager.spectating = false

func update_challenge_status(new_status):
	challenge_state = new_status
	OnlineLobby.send_status_update(challenge_state)

func update_message_log(new_message: String):
	$CanvasLayer/MessageLabel.text = new_message+"\n"+$CanvasLayer/MessageLabel.text
