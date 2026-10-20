extends Node2D

class_name Challenge

signal accept_result(accepted, sender)

#var frame = 0
#var frame_update = 10

var ping: int
var from: OnlineLobby.Player: get = get_from, set = set_from # can be accessed publicly, add a set get?

func _ready() -> void:
	ping = -1
	$CanvasLayer/GridContainer/InputDelayMeter.grab_focus()
	$CanvasLayer/GridContainer/InputDelayMeter.value = SyncManager.input_delay
	SyncManager.network_adaptor.connect("received_ping_back", Callable(self, "update_ping"))

#func _physics_process(_delta):
#	frame += 1
#	if (frame == frame_update):
#		frame = 0
#		$CanvasLayer/GridContainer/PingLabel.set_text("Ping: " + str(ping) + "ms")

func update_ping(new_ping: int, msg):
	pass
#	ping = new_ping
#	$CanvasLayer/GridContainer/PingLabel.set_text("Ping: " + str(ping/2) + "ms")

func set_from(p_from: OnlineLobby.Player):
	from = p_from
	update_ui(from.username)

func get_from() -> OnlineLobby.Player:
	return from

func get_session_id() -> String:
	return from.session_id

func update_ui(name: String):
	$CanvasLayer/GridContainer/ChallengerName.set_text(Util.display_username(from.username))

func _on_accept_challenge_pressed():
	SyncManager.set_input_delay(int($CanvasLayer/GridContainer/InputDelayMeter.value))
	emit_signal("accept_result", true, from.session_id)

func _on_decline_challenge_pressed():
	SyncManager.set_input_delay(2)
	emit_signal("accept_result", false, from.session_id)

func _on_InputDelayMeter_value_changed(value):
	$CanvasLayer/GridContainer/InputDelayLabel.text = tr("UI_LABEL_INPUT_DELAY").format({"frames": int(value)})
	SyncManager.set_input_delay(int($CanvasLayer/GridContainer/InputDelayMeter.value))
