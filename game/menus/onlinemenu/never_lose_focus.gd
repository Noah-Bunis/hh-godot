extends Control

@export var home_control: Control

func _physics_process(_delta) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		_on_focus_lost()

func _on_focus_lost() -> void:
	home_control.grab_focus()
	print("UI control lost focus!")
