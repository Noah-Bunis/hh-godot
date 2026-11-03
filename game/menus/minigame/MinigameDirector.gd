extends Node
class_name MinigameDirector


signal instruction_changed(minigame: Minigame)
signal result_changed(success: bool)
signal run_finished(score: int, total_games: int)


enum director_state {
	WAITING,
	ANNOUNCING,
	PLAYING,
	RESULTS,
	FINISHED
}


@export var minigames: Array[Minigame] = []

@export var minigame_duration: float = 5.0
@export var announcement_duration: float = 1.0
@export var results_duration: float = 0.75


var state: director_state = director_state.WAITING

var current_minigame: Minigame = null

var minigame_index: int = 0
var score: int = 0
var time_remaining: float = 0.0

var announcement_timer: float = 0.0
var results_timer: float = 0.0


func start_run() -> void:
	if minigames.is_empty():
		state = director_state.FINISHED
		run_finished.emit(0, 0)
		return

	if current_minigame != null:
		current_minigame.stop()

	minigame_index = 0
	score = 0
	current_minigame = null

	start_next_minigame()


func start_next_minigame() -> void:
	if current_minigame != null:
		current_minigame.stop()
		current_minigame = null

	if minigame_index >= minigames.size():
		state = director_state.FINISHED
		run_finished.emit(score, minigames.size())
		return

	current_minigame = minigames[minigame_index]
	minigame_index += 1

	if current_minigame == null:
		push_warning("MinigameDirector: Minigame at index %d is null." % (minigame_index - 1))
		start_next_minigame()
		return

	time_remaining = minigame_duration
	announcement_timer = announcement_duration

	state = director_state.ANNOUNCING

	instruction_changed.emit(current_minigame)


func _process(delta: float) -> void:
	match state:
		director_state.ANNOUNCING:
			announcement_timer -= delta

			if announcement_timer <= 0.0:
				announcement_timer = 0.0
				state = director_state.PLAYING
				current_minigame.start()

		director_state.PLAYING:
			time_remaining -= delta

			if time_remaining <= 0.0:
				time_remaining = 0.0
				report_failure()

		director_state.RESULTS:
			results_timer -= delta

			if results_timer <= 0.0:
				results_timer = 0.0
				start_next_minigame()


func finish_minigame(success: bool) -> void:
	if state != director_state.PLAYING:
		return

	state = director_state.RESULTS
	results_timer = results_duration

	if success:
		score += 1

	if current_minigame != null:
		current_minigame.stop()

	result_changed.emit(success)


func report_success() -> void:
	finish_minigame(true)


func report_failure() -> void:
	finish_minigame(false)