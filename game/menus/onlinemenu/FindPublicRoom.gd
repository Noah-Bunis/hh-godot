extends Node2D

@onready var message_label = $CanvasLayer/MessageLabel
@onready var LOBBY_CARD = preload("res://game/menus/onlinemenu/PublicLobbyCard.tscn")

var player_cards = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	OnlineLobby.leave()
	
	MainMenuMusicControl.play_main_menu_music()
#	$CanvasLayer/GridContainer/PasteButton.grab_focus()
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.PRIVATE_ROOM
	
	OnlineLobby.connect("error", Callable(self, "_on_OnlineLobby_error"))
	OnlineLobby.connect("public_lobbies_found", Callable(self, "_on_OnlineLobby_lobbies_found"))
	OnlineLobby.connect("match_joined", Callable(self, "_on_OnlineLobby_match_joined"))
	OnlineLobby.connect("match_created", Callable(self, "_on_OnlineLobby_match_created"))
	
	# We can configure OnlineMatch before using it:
	OnlineLobby.client_version = Global.get_battle_version()
	OnlineLobby.use_network_relay = OnlineLobby.NetworkRelay.AUTO
	
	OnlineMatch.ice_servers = [{ "urls": Build.ICE_SERVERS }]
	OnlineMatch.use_network_relay = OnlineMatch.NetworkRelay.AUTO
	var lobby_data = await OnlineLobby.find_lobbies(Global.nakama_socket, Global.nakama_client, Global.nakama_session)

func add_lobby_to_list(lobby):
	player_cards[lobby.match_id] = LOBBY_CARD.instantiate()
	player_cards[lobby.match_id].update_card(lobby)
	$CanvasLayer/ScrollContainer/GridContainer.add_child(player_cards[lobby.match_id])
	player_cards[lobby.match_id].grab_focus()
	player_cards[lobby.match_id].connect("join", Callable(self, "join_a_lobby"))

func join_a_lobby(match_id):
	OnlineLobby.join_public_lobby(Global.nakama_socket, match_id)

func _on_OnlineLobby_lobbies_found(lobby_data) -> void:
	if (lobby_data != null):
		for lobby in lobby_data:
			add_lobby_to_list(lobby)
func _on_OnlineLobby_error(message: String) -> void:
	print("ERROR: %s" % message)
	$CanvasLayer/MessageLabel.text = tr("UI_LABEL_ERROR").format({"message": message})

func _on_OnlineLobby_match_created(match_id: String) -> void:
	print("Created new public lobby: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PUBLIC_LOBBY_CREATED").format({"match_id": match_id})
	OnlineLobby.join_match(Global.nakama_socket, match_id)

func _on_OnlineLobby_match_joined(match_id: String) -> void:
	print("Joined private match: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_JOINED_PRIVATE_MATCH").format({"match_id": match_id})
	Global.NETPLAY_MODE
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/PrivateRoom.tscn")

func exit():
	OnlineLobby.leave()
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit()
