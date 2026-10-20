extends Control

@onready var BUTTON_MAP_MENU = preload("res://game/menus/buttonmap/ButtonMapMenuScreen.tscn")
var button_menu
var button_map_paused_before_open: bool
var last_input_event: InputEvent
var command_list_node: Node
var command_list_input_was_enabled: bool
var command_list_physics_was_enabled: bool

signal close_menu()
signal exit()
signal command_list()

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	command_list_node = get_parent().get_node_or_null("CommandList")

func _on_ExitButton_pressed():
	get_tree().paused = false
	emit_signal("exit")

func _on_CloseButton_pressed():
	get_tree().paused = false
	emit_signal("close_menu")

func _on_CommandListButton_pressed():
	emit_signal("command_list")

func _input(event: InputEvent) -> void:
	last_input_event = event

func _on_ChangeControlsButton_pressed() -> void:
	button_map_paused_before_open = get_tree().paused
	button_menu = BUTTON_MAP_MENU.instantiate()
	button_menu.configure_single_player(last_input_event, true)
	set_process_input(false)
	if (command_list_node != null):
		command_list_input_was_enabled = command_list_node.is_processing_input()
		command_list_physics_was_enabled = command_list_node.is_physics_processing()
		command_list_node.set_process_input(false)
		command_list_node.set_physics_process(false)
	var focus_owner = get_viewport().gui_get_focus_owner()
	if (focus_owner != null):
		focus_owner.release_focus()
	get_parent().add_child(button_menu)
	button_menu.connect("complete", Callable(self, "button_set_complete"))

func button_set_complete() -> void:
	get_tree().paused = button_map_paused_before_open
	button_menu.disconnect("complete", Callable(self, "button_set_complete"))
	button_menu.queue_free()
	button_menu = null
	set_process_input(true)
	if (command_list_node != null):
		command_list_node.set_process_input(command_list_input_was_enabled)
		command_list_node.set_physics_process(command_list_physics_was_enabled)
	$ChangeControlsButton.call_deferred("grab_focus")
