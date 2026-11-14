extends Resource
class_name Minigame


@export var display_name: String = "Minigame"
@export_multiline var message: String = "GET READY!"
@export var objective: MinigameInstruction
@export var savestate: Dictionary = {}
@export var dummy_point_character: int = -1
@export var dummy_point_scene: PackedScene
@export var dummy_assist_character: int = -1
@export var dummy_assist_scene: PackedScene

func get_instruction() -> String:
	if objective != null:
		return objective.get_instruction()
	return message


func start(target_player: BasePlayer, on_success: Callable) -> void:
	if objective != null:
		objective.start(target_player, on_success)


func stop() -> void:
	if objective != null:
		objective.stop()