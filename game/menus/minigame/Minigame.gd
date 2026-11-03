extends Resource
class_name Minigame


@export var display_name: String = "Minigame"
@export_multiline var instruction: String = "GET READY!"
@export var savestate: Dictionary = {}
@export var dummy_point_character: int = -1
@export var dummy_point_scene: PackedScene


func get_instruction() -> String:
	return instruction


func start() -> void:
	# Override this in individual minigames.
	pass


func stop() -> void:
	# Override this in individual minigames.
	pass