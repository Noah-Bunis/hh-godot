extends Node2D

class_name RoundTracker

signal win()
signal rounds_updated()

var roundData: Dictionary
var roundsToWin: int = 2

enum State {
	p1_rounds,
	p2_rounds,
}

func _ready():
	add_to_group("network_sync")
	reset_to_game_start()

func _save_state() -> Dictionary:
	var state : Dictionary = {
		State.p1_rounds : roundData[State.p1_rounds],
		State.p2_rounds : roundData[State.p2_rounds],
	}
	return state

func _load_state(state: Dictionary) -> void:
	update_rounds_won(true, state[State.p1_rounds])
	update_rounds_won(false, state[State.p2_rounds])

func register_ko(is_p1: bool) -> void:
	var index = 0
	if (is_p1):
		index = State.p1_rounds
	else:
		index = State.p2_rounds
	
	update_rounds_won(is_p1, roundData[index] + 1)

	if (roundData[index] >= roundsToWin):
		Global.P1_WON_MATCH = is_p1
		emit_signal("win")

func reset_to_game_start() -> void:
	update_rounds_won(true, 0)
	update_rounds_won(false, 0)

func read_rounds_won(is_p1: bool = true) -> int:
	if (is_p1):
		return roundData[State.p1_rounds]
	else:
		return roundData[State.p2_rounds]

func update_rounds_won(is_p1: bool, rounds: int) -> void:
	var index = 0
	if (is_p1):
		index = State.p1_rounds
	else:
		index = State.p2_rounds
	roundData[index] = rounds
	rounds_updated.emit(is_p1)

func is_game_over() -> bool:
	return roundData[State.p1_rounds] >= roundsToWin or roundData[State.p2_rounds] >= roundsToWin
