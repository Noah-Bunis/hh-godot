extends Node2D

@onready var message_label = $CanvasLayer/MessageLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	OnlineLobby.leave()
	
	MainMenuMusicControl.play_main_menu_music()
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.PRIVATE_ROOM
	
	OnlineLobby.connect("error", Callable(self, "_on_OnlineLobby_error"))
	OnlineLobby.connect("match_joined", Callable(self, "_on_OnlineLobby_match_joined"))
	OnlineLobby.connect("match_created", Callable(self, "_on_OnlineLobby_match_created"))
	
	# We can configure OnlineMatch before using it:
	OnlineLobby.min_players = 2
	OnlineLobby.max_players = 250
	OnlineLobby.client_version = Global.get_battle_version()
	OnlineLobby.use_network_relay = OnlineLobby.NetworkRelay.AUTO
	
	OnlineMatch.min_players = 2
	OnlineMatch.max_players = 250
	OnlineMatch.ice_servers = [{ "urls": Build.ICE_SERVERS }]
	OnlineMatch.use_network_relay = OnlineMatch.NetworkRelay.AUTO
	
	OnlineLobby.create_new_public_lobby(Global.nakama_socket)

func _on_OnlineLobby_error(message: String) -> void:
	print("ERROR: %s" % message)
	$CanvasLayer/MessageLabel.text = tr("UI_LABEL_ERROR").format({"message": message})

func _on_OnlineLobby_match_created(match_id: String) -> void:
	print("Created new public lobby: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PUBLIC_LOBBY_CREATED").format({"match_id": match_id})
	OnlineLobby.join_public_lobby(Global.nakama_socket, match_id)

func _on_OnlineLobby_match_joined(match_id: String) -> void:
	print("Joined private match: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_JOINED_PRIVATE_MATCH").format({"match_id": match_id})
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/PrivateRoom.tscn")

func exit():
#	reset_without_retry()
	OnlineLobby.leave()
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit()
