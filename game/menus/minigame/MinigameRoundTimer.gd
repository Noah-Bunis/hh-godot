extends "res://game/ui/RoundTimer.gd"
class_name MinigameRoundTimer


var minigame_director: MinigameDirector


func _init() -> void:
	remove_from_group("network_sync")


func _process(_delta: float) -> void:
	if minigame_director == null:
		hide()
		return

	if minigame_director.state == MinigameDirector.director_state.FINISHED:
		hide()
		return

	show()
	var remaining_time: float = minigame_director.time_remaining
	if minigame_director.state == MinigameDirector.director_state.WAITING:
		remaining_time = minigame_director.minigame_duration

	remaining_time = maxf(remaining_time, 0.0)
	display_text(ceili(remaining_time * 10.0))
