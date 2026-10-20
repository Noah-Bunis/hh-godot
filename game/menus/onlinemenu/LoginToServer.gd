extends Node2D

#var login_success = false

func _ready() -> void:
	MainMenuMusicControl.play_main_menu_music()
	OnlineLobby.leave()
	OnlineMatch.leave()
	$CanvasLayer/NameLabel.text = Global.user_display_name
	Global.NETPLAY_MODE = Global.NETPLAY_MODES.PRIVATE_ROOM
	$AruDJAnimator.play("Idle")
	connect_to_nakama()

var nakama_client: NakamaClient
var nakama_session: NakamaSession
var nakama_socket: NakamaSocket

func connect_to_nakama() -> void:
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_CONNECTING_SERVER")
	# Connect to a local Nakama instance using all the default settings.
	if (not Global.LOCAL_SERVER):
		nakama_client = Nakama.create_client(Build.SERVER_KEY, Build.SERVER_IP, Build.SERVER_PORT, 'http', 
			Nakama.DEFAULT_TIMEOUT, NakamaLogger.LOG_LEVEL.ERROR)
	else:
		$CanvasLayer/MessageLabel.text = tr("UI_STATUS_CONNECTING_LOCAL_SERVER")
		print("connecting to local server")
		nakama_client = Nakama.create_client(Build.SERVER_KEY, '127.0.0.1', Build.SERVER_PORT, 'http', 
			Nakama.DEFAULT_TIMEOUT, NakamaLogger.LOG_LEVEL.ERROR)
	# Login to Nakama using "device authentication".
	var device_id = OS.get_unique_id()
	nakama_session = await nakama_client.authenticate_device_async(device_id, device_id)
	if nakama_session.is_exception():
		print ("Unable to connect to Nakama")
		print (nakama_session.get_exception().message)
		$CanvasLayer/MessageLabel.text = tr("UI_STATUS_UNABLE_CONNECT_SERVER")
		return
		
	var name_update = await nakama_client.update_account_async(nakama_session, Util.create_username(device_id, Global.user_display_name), Global.user_display_name)
	if name_update.is_exception():
		print ("Unable to create display name")
		print (name_update.get_exception().message)
		$CanvasLayer/MessageLabel.text = tr("UI_STATUS_USERNAME_FAILED")
		return
#		get_tree().quit()

	if (nakama_session.username != Util.create_username(device_id,Global.user_display_name)):
		print("Name updated : oldname: " + Util.display_username(nakama_session.username) + " new name: "+Global.user_display_name)
		nakama_session = await nakama_client.authenticate_device_async(device_id, device_id)
		if nakama_session.is_exception():
			print ("Unable to connect to Nakama")
			print (nakama_session.get_exception().message)
			$CanvasLayer/MessageLabel.text = tr("UI_STATUS_USERNAME_UPDATE_FAILED")
			return
		
	# Open a realtime socket to Nakama.
	nakama_socket = Nakama.create_socket_from(nakama_client)
	await nakama_socket.connect_async(nakama_session)
	Global.nakama_client = nakama_client
	Global.nakama_socket = nakama_socket
	Global.nakama_session = nakama_session
	
	print ("Connected to Nakama!")
	$CanvasLayer/MessageLabel.text = tr("UI_STATUS_CONNECTED_SERVER")
	
	get_tree().change_scene_to_file("res://game/menus/onlinemenu/OnlineModes.tscn")

func _input(event):
	input_help(event)

func input_help(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://game/menus/buttonmap/OnlineControllerPickMenuScreen.tscn")
