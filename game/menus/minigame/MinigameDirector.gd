extends Node

class_name MinigameDirector

signal instruction_changed(text: String)
signal result_changed(success: bool)
signal run_finished(score: int, total_games: int)

enum State {
	WAITING,
	ANNOUNCING,
	PLAYING,
	RESULTS,
	FINISHED
}

@export var minigame_duration: float = 5.0
@export var announcement_duration: float = 1.0
@export var results_duration: float = 0.75

var state = State.WAITING

var minigames: Array[StringName] = [
	&"block",
	&"combo",
	&"survive"
]

var current_minigame_id: StringName = &""

var minigame_index: int = 0
var score: int = 0
var time_remaining: float = 0.0

var announcement_timer: float = 0.0
var results_timer: float = 0.0


func start_run() -> void:
	minigame_index = 0
	score = 0
	current_minigame_id = &""

	start_next_minigame()


func start_next_minigame() -> void:
	if minigame_index >= minigames.size():
		state = State.FINISHED

		run_finished.emit(score, minigames.size())
		return

	current_minigame_id = minigames[minigame_index]
	minigame_index += 1

	time_remaining = minigame_duration
	announcement_timer = announcement_duration

	state = State.ANNOUNCING

	instruction_changed.emit(
		_get_instruction(current_minigame_id)
	)


func _process(delta: float) -> void:
	match state:
		State.ANNOUNCING:
			announcement_timer -= delta

			if announcement_timer <= 0.0:
				announcement_timer = 0.0
				state = State.PLAYING

		State.PLAYING:
			time_remaining -= delta

			if time_remaining <= 0.0:
				finish_minigame(false)

		State.RESULTS:
			results_timer -= delta

			if results_timer <= 0.0:
				results_timer = 0.0
				start_next_minigame()


func finish_minigame(success: bool) -> void:
	if state != State.PLAYING:
		return

	state = State.RESULTS
	results_timer = results_duration

	if success:
		score += 1

	result_changed.emit(success)


func report_success() -> void:
	finish_minigame(true)


func report_failure() -> void:
	finish_minigame(false)


func _get_instruction(minigame_id: StringName) -> String:
	match minigame_id:
		&"block":
			return "BLOCK!"

		&"combo":
			return "LAND A COMBO!"

		&"survive":
			return "DON'T GET HIT!"

		_:
			return "GET READY!"
