extends Resource
class_name MinigameInstruction


signal progress_changed(progress_text: String)


func get_instruction() -> String:
	return ""


func get_progress_text() -> String:
	return ""


func start(_target_player: BasePlayer, _on_success: Callable) -> void:
	pass


func stop() -> void:
	pass
