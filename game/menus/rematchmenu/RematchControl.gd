extends Node2D

signal rematch ()
signal chara_select ()
signal main_menu ()


var peer_ready = [false, false]
var select_data = [-1, -1]

func _ready():
	multiplayer.peer_connected.connect(_on_network_peer_connected)
	multiplayer.peer_disconnected.connect(_on_network_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_network_peer_connected)
	multiplayer.connection_failed.connect(_on_network_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	$P1Cursor.connect("select_chara", Callable(self, "select_p1"))
	$P2Cursor.connect("select_chara", Callable(self, "select_p2"))
	$P1Cursor.connect("deselect_chara", Callable(self, "deselect_p1"))
	$P2Cursor.connect("deselect_chara", Callable(self, "deselect_p2"))
	
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		var peer = multiplayer.get_unique_id()
		if (not SyncManager.spectating):
			if peer == 1:
				$P2Cursor.queue_free()
			else:
				$P1Cursor.queue_free()
				$P2Cursor.input_prefix = "player1_"
		else:
			$P1Cursor.queue_free()
			$P2Cursor.queue_free()
		$Timer.start(8)
	else:
		$CanvasLayer/RemainingTime.visible = false

func _on_network_peer_connected(_peer_id: int):
	pass

func _on_network_peer_disconnected(_peer_id: int):
	$Timer.stop()
	
func _on_server_disconnected() -> void:
	_on_network_peer_disconnected(1)

func deselect_ok():
	$P1Cursor.deselect_ok = true
	$P2Cursor.deselect_ok = true

@rpc("any_peer") func remote_rematch():
	emit_signal("rematch")

@rpc("any_peer") func remote_chara_select():
	emit_signal("chara_select")

@rpc("any_peer") func remote_main_menu():
	emit_signal("main_menu")

@rpc("any_peer") func select_p(peer_row:int):
	$Timer.start($Timer.time_left + 1)
	var peer = multiplayer.get_remote_sender_id()
	if peer == 1:
		select_data[0] = peer_row
		peer_ready[0] = true
	else:
		select_data[1] = peer_row
		peer_ready[1] = true

@rpc("any_peer") func deselect_p():
	var peer = multiplayer.get_remote_sender_id()
	if peer == 1:
		select_data[0] = -1
		peer_ready[0] = false
	else:
		select_data[1] = -1
		peer_ready[1] = false

func select_p1():
	select_data[0] = $P1Cursor.row
	peer_ready[0] = true
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		$Timer.start($Timer.time_left + 2)
		rpc("select_p", select_data[0])

func select_p2():
	select_data[1] = $P2Cursor.row
	peer_ready[1] = true
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		$Timer.start($Timer.time_left + 2)
		rpc("select_p", select_data[1])

func deselect_p1():
	select_data[0] = -1
	peer_ready[0] = false
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		rpc("deselect_p")

func deselect_p2():
	select_data[1] = -1
	peer_ready[1] = false
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		rpc("deselect_p")

func rematch_ready() -> bool:
	return peer_ready[0] and peer_ready[1] and select_data[0] == 0 and select_data[1] == 0

func _physics_process(_delta):
	if ($CanvasLayer/RemainingTime.visible):
		$CanvasLayer/RemainingTime.text = str(int($Timer.time_left+1))
	
	if (rematch_ready()):
		emit_signal("rematch")
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			rpc("remote_rematch")
	elif (peer_ready[0] and select_data[0] == 1):
		emit_signal("chara_select")
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			rpc("remote_chara_select")
	elif (peer_ready[0] and select_data[0] == 2):
		emit_signal("main_menu")
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			rpc("remote_main_menu")
	elif (peer_ready[1] and select_data[1] == 1):
		emit_signal("chara_select")
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			rpc("remote_chara_select")
	elif (peer_ready[1] and select_data[1] == 2):
		emit_signal("main_menu")
		if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
			rpc("remote_main_menu")

func _input(event):
	if event.is_action_pressed("player1_cancel") or Util.is_action_pressed_player_specific(event, "menu_back_b", true):
		if (get_node("P1Cursor") != null):
			$P1Cursor.deselect()
	if event.is_action_pressed("player2_cancel") or Util.is_action_pressed_player_specific(event, "menu_back_b", false):
		if (get_node("P2Cursor") != null):
			$P2Cursor.deselect()

func _on_Timer_timeout():
	emit_signal("main_menu")
	if (Global.NETPLAY_MODE != Global.NETPLAY_MODES.OFFLINE):
		rpc("remote_main_menu")
