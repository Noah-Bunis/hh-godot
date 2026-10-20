extends Control

signal challenge(session_id, curr_state)
signal spectate(session_id, curr_state)

#var frame = 0
#var frame_update = 10

var ping: int
var player: OnlineLobby.Player: get = get_player, set = set_player 

var challenging: bool: get = get_challenging, set = set_challenging
var spectating: bool: get = get_spectating, set = set_spectating

func _ready() -> void:
	ping = -1
	challenging = false
	spectating = false

func update_ping(new_ping: int, msg):
	ping = new_ping
	$PingLabel.text = tr("UI_LABEL_PING").format({"ping": ping})

func update_status(new_status: int):
	if (new_status == OnlineLobby.CHALLENGE_STATE.IN_GAME):
		$StatusLabel.text = tr("UI_LABEL_STATUS_IN_GAME")
		$Background.self_modulate = Color("#550606")
	elif (new_status == OnlineLobby.CHALLENGE_STATE.CHALLENGING):
		$StatusLabel.text = tr("UI_LABEL_STATUS_CHALLENGING")
		$Background.self_modulate = Color("#ddaa30")
	elif (new_status == OnlineLobby.CHALLENGE_STATE.DECIDING):
		$StatusLabel.text = tr("UI_LABEL_STATUS_DECIDING")
		$Background.self_modulate = Color("#184b9b")
	elif (new_status == OnlineLobby.CHALLENGE_STATE.SPECTATING):
		$StatusLabel.text = tr("UI_MENU_SPECTATE")
		$Background.self_modulate = Color("#580f8a")
	else:
		$StatusLabel.text = tr("UI_LABEL_STATUS_READY")
		$Background.self_modulate = Color("#146c76")

func set_player(p_player: OnlineLobby.Player):
	$NameLabel.set_text(Util.display_username(p_player.username))
	$PingLabel.set_text(str(p_player.peer_id))
	player = p_player

func get_player() -> OnlineLobby.Player:
	return player

func _on_challenge_pressed():
	emit_signal("challenge", player.session_id, challenging)

func _on_spectate_pressed():
	emit_signal("spectate", player.session_id, spectating)

func set_challenging(p_challenging: bool):
	challenging = p_challenging
	if (challenging):
		$Challenge.text = tr("UI_BUTTON_CANCEL")
	else:
		$Challenge.text = tr("UI_MENU_CHALLENGE")

func get_challenging():
	return challenging

func set_spectating(p_spectating: bool):
	spectating = p_spectating
	if (spectating):
		$Spectate.text = tr("UI_BUTTON_CANCEL")
	else:
		$Spectate.text = tr("UI_MENU_SPECTATE")
		
func get_spectating():
	return spectating

#func has_focus() -> bool:
	#return $Challenge.has_focus() || $Spectate.has_focus()
