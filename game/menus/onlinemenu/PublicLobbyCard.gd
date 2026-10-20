extends Control

signal join(match_id)

var match_id

func _ready() -> void:
	pass

func update_card(lobby_data):
	match_id = lobby_data.match_id
	$CurrentSizeLabel.text = tr("UI_LABEL_PLAYERS_COUNT").format({"count": lobby_data.size})
	var split = lobby_data.label.split('"requiredPlayerCount":')
	if (len(split) > 1):
		var max_size = (split[1]).substr(0, len(split[1]) - 1)
		$CurrentSizeLabel.text = tr("UI_LABEL_PLAYERS_CAPACITY").format({"count": lobby_data.size, "maximum": max_size})
#	lobby_data.label

func _on_join_room_pressed():
	emit_signal("join", match_id)

#func grab_focus():
	#$Join.grab_focus()

#func has_focus() -> bool:
	#return $Join.has_focus()
