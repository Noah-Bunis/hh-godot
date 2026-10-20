extends Node2D

const MIN_PLAYER_COUNT = 2
const MAX_PLAYER_COUNT = 16

func _ready() -> void:
	MainMenuMusicControl.play_main_menu_music()
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.PRIVATE_ROOM
	$CanvasLayer/GridContainer/CreateRoomButton.grab_focus()
	$AruDJAnimator.play("Idle")
	
	OnlineLobby.connect("error", Callable(self, "_on_OnlineMatch_error"))
	OnlineLobby.connect("match_created", Callable(self, "_on_OnlineMatch_match_created"))
	
	# We can configure OnlineMatch before using it:
	OnlineLobby.min_players = MIN_PLAYER_COUNT
	OnlineLobby.max_players = MAX_PLAYER_COUNT
	OnlineLobby.client_version = Global.get_battle_version()
	OnlineLobby.use_network_relay = OnlineLobby.NetworkRelay.AUTO
	
	OnlineMatch.min_players = MIN_PLAYER_COUNT
	OnlineMatch.max_players = MAX_PLAYER_COUNT
	OnlineMatch.ice_servers = [{ "urls": Build.ICE_SERVERS }]
	OnlineMatch.use_network_relay = OnlineMatch.NetworkRelay.AUTO
	update_lobby_size($CanvasLayer/GridContainer/PlayerCountMeter.value)

func _on_OnlineMatch_error(message: String) -> void:
	print("ERROR: %s" % message)
	$CanvasLayer/MessageLabel.text = tr("UI_LABEL_ERROR").format({"message": message})

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")

func _on_create_private_room_pressed():
	OnlineLobby.create_match(Global.nakama_socket)

func _on_OnlineMatch_match_created(match_id: String) -> void:
	print("Private match created: %s" % match_id)
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_PRIVATE_MATCH_CREATED").format({"match_id": match_id})
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/PrivateRoom.tscn")

func _on_PlayerCountMeter_value_changed(value):
	update_lobby_size(value)

func update_lobby_size(new_size):
	OnlineLobby.max_players = new_size
	OnlineMatch.max_players = new_size
	$CanvasLayer/GridContainer/PlayerCountLabel.text = tr("UI_LABEL_MAX_LOBBY_SIZE").format({"count": new_size})
	
