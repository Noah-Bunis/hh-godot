extends Node2D

@onready var host_field = $CanvasLayer/GridContainer/HostField
@onready var port_field = $CanvasLayer/GridContainer/PortField
@onready var message_label = $CanvasLayer/MessageLabel
@onready var server_button = $CanvasLayer/GridContainer/ServerButton
@onready var client_button = $CanvasLayer/GridContainer/ClientButton
#onready var sync_lost_label = $CanvasLayer/SyncLostLabel

func _ready() -> void:
	MainMenuMusicControl.play_main_menu_music()
	multiplayer.peer_connected.connect(_on_network_peer_connected)
	multiplayer.peer_disconnected.connect(_on_network_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_network_peer_connected)
	multiplayer.connection_failed.connect(_on_network_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	$CanvasLayer/GridContainer/ServerButton.grab_focus()
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.DIRECT_IP
	$AruDJAnimator.play("Idle")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (host_field.has_focus() or port_field.has_focus()):
			pass
		elif (multiplayer.multiplayer_peer != null):
			_on_network_peer_disconnected(multiplayer.multiplayer_peer.get_unique_id())
		elif (client_button.has_focus() or server_button.has_focus()):
			get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")
		else:
			get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")

func _physics_process(delta):
	if (multiplayer.multiplayer_peer != null):
		server_button.disabled = true
		client_button.disabled = true
		host_field.editable = false
		port_field.editable = false
	else:
		server_button.disabled = false
		client_button.disabled = false
		host_field.editable = true
		port_field.editable = true

func _on_ServerButton_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(int(port_field.text), 1)
	if (result == OK):
		multiplayer.multiplayer_peer = peer
		message_label.text = tr("UI_LABEL_SERVER_SEARCHING")
	else:
		message_label.text = tr("UI_LABEL_SERVER_ERROR").format({"error": result})
		multiplayer.multiplayer_peer = null

func _on_ClientButton_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(host_field.text, int(port_field.text))
	if (result == OK):
		multiplayer.multiplayer_peer = peer
		message_label.text = tr("UI_LABEL_CLIENT_SEARCHING")
	else:
		message_label.text = tr("UI_LABEL_CLIENT_ERROR").format({"error": result})
		multiplayer.multiplayer_peer = null

func _on_network_peer_connected(peer_id: int):
	message_label.text = tr("UI_STATUS_SERVER_CONNECTED")
	SyncManager.add_peer(peer_id)
	start_character_select()

func _on_network_peer_disconnected(peer_id: int):
	message_label.text = tr("UI_STATUS_SERVER_DISCONNECTED")
	SyncManager.clear_peers()
	multiplayer.multiplayer_peer = null

func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)

func start_character_select():
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineCharacterSelect.tscn")
