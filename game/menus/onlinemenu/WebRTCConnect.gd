# https://www.snopekgames.com/tutorial/2021/how-use-webrtc-godot-nakama-signalling-server
extends Node2D

@onready var Challenge = preload("res://game/menus/onlinemenu/ChallengePublicQueue.tscn")
var challenge
var peer_ready = {}

func _ready():
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.PUBLIC_QUEUE
	join_an_online_match()

func join_an_online_match() -> void:
	# We can configure OnlineMatch before using it:
	OnlineMatch.min_players = 2
	OnlineMatch.max_players = 2
	OnlineMatch.client_version = Global.get_battle_version()
	OnlineMatch.ice_servers = [{ "urls": Build.ICE_SERVERS }]
	OnlineMatch.use_network_relay = OnlineMatch.NetworkRelay.AUTO

	# Connect to all of OnlineMatch's signals.
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
	
	print ("Joined the matchmaking queue...")
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_MATCHMAKING_QUEUED")
	reset_without_retry()
	OnlineMatch.start_matchmaking(Global.nakama_socket)

func delete_challenge():
	if (challenge != null):
		challenge.disconnect("accept_result", Callable(self, "accept_challenge"))
		challenge.disconnect("timed_out_challenge", Callable(self, "timeout"))
		challenge.queue_free()
		challenge = null

func reset():
	exit()

func reset_without_retry():
	delete_challenge()
	SyncManager.clear_peers()
	peer_ready = {}
	OnlineMatch.leave()

func timeout():
	exit()

func _on_OnlineMatch_error(message: String) -> void:
	print("ERROR: %s" % message)
	reset()
	$CanvasLayer/MessageLabel.text = tr("UI_LABEL_ERROR").format({"message": message})

func _on_OnlineMatch_disconnected() -> void:
	print("Disconnected from match.")
	reset()
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_DISCONNECTED")

func _on_OnlineMatch_match_created(match_id: String) -> void:
	print("Private match created: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PRIVATE_MATCH_CREATED").format({"match_id": match_id})

func _on_OnlineMatch_match_joined(match_id: String) -> void:
	print("Joined private match: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_JOINED_PRIVATE_MATCH").format({"match_id": match_id})

func _on_OnlineMatch_matchmaker_matched(players: Dictionary) -> void:
	print("Joined match via matchmaker")
	for player in players.values():
		print ("Player joined: %s" % Util.display_username(player.username))

func _on_OnlineMatch_player_joined(player: OnlineMatch.Player) -> void:
	print("Player joined: %s" % Util.display_username(player.username))
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PLAYER_JOINED").format({"player_name": Util.display_username(player.username)})

func _on_OnlineMatch_player_left(player: OnlineMatch.Player) -> void:
	print("Player left: %s" % Util.display_username(player.username))
	reset()
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PLAYER_LEFT").format({"player_name": Util.display_username(player.username)})

func _on_OnlineMatch_player_status_changed(player: OnlineMatch.Player, status) -> void:
	print("Player status changed: %s -> %s" % [Util.display_username(player.username), status])
	if player.peer_id != SyncManager.network_adaptor.get_unique_id() && status == OnlineMatch.PlayerStatus.CONNECTED:
		rpc_id(player.peer_id, "receive_message", "Hi! We're connected now :-)")
		SyncManager.add_peer(player.peer_id)
		update_message_log("Match found")
		challenge = Challenge.instantiate()
		challenge.from_queue = player
		challenge.connect("accept_result", Callable(self, "accept_challenge"))
		challenge.connect("timed_out_challenge", Callable(self, "timeout"))
		add_child(challenge)

@rpc("any_peer") func receive_message(message: String) -> void:
	print("Message from %s: %s" % [multiplayer.get_remote_sender_id(), message])

func _on_OnlineMatch_match_not_ready() -> void:
	print("The match isn't ready to start")

func _on_OnlineMatch_match_ready(players: Dictionary) -> void:
	print("The match is ready to start! Here are players:")
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_MATCH_STARTING")
	for player in players.values():
		print ("- %s" % Util.display_username(player.username))
		print ("- %s" % player.session_id)
		print ("- %s" % player.peer_id)

func accept_challenge(accept_result: bool, sender: String):
	if (accept_result):
		update_message_log("You accepted challenge")
		if SyncManager.network_adaptor.is_network_host():
			rpc("ready_up", 1)
		else:
			rpc("ready_up", multiplayer.get_unique_id())
	else:
		update_message_log("You declined challenge")
		rpc("declined")
		
@rpc("any_peer", "call_local") func ready_up(peer_id) -> void:
	if (SyncManager.is_multiplayer_authority()):
		peer_ready[peer_id] = true
		if (peer_ready.size() >= OnlineMatch.players.size()):
			rpc("start_game")

@rpc("any_peer", "call_local") func declined() -> void:
	reset()

@rpc("any_peer", "call_local") func start_game() -> void:
	print ("The host told me it's time to start the game!")
	delete_challenge()
	if (OnlineMatch.get_match_state() != OnlineMatch.MatchState.PLAYING):
		OnlineMatch.start_playing()
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineCharacterSelect.tscn")

func update_message_log(message: String):
	$CanvasLayer/MessageLabel.text = message

func exit():
	reset_without_retry()
	OnlineMatch.leave()
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit()
