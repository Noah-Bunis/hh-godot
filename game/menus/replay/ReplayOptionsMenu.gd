extends GridContainer

@onready var BUTTON_MAP_MENU = preload("res://game/menus/buttonmap/ButtonMapMenuScreen.tscn")
var button_menu

signal close_menu()
signal exit()
signal reset()
signal loadstate()

var menu_close_delay: int
var most_recent_focus:Control
var button_map_paused_before_open: bool
var last_input_event: InputEvent

#func _on_focus_changed(control:Control) -> void:
	#if control is PopupMenu:
		#return
	#if control != null:
		#most_recent_focus = control

func _ready():
	get_viewport().connect("gui_focus_changed", Callable(self, "_on_focus_changed"))
	most_recent_focus = $CloseButton
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$TakeoverButton.add_item(tr("UI_TRAINING_NONE"), 0)
	$TakeoverButton.add_item(tr("UI_REPLAY_PLAYER_ONE"), 1)
	$TakeoverButton.add_item(tr("UI_REPLAY_PLAYER_TWO"), 2)
	
func _physics_process(delta):
	if menu_close_delay > 0:
		menu_close_delay -= 1
		if (menu_close_delay == 0):
			close_training_options_menu()

func open_training_options_menu():
	if (not is_enabled()):
		self.visible = true
		if (most_recent_focus != null):
			most_recent_focus.grab_focus()
		else:
			$CloseButton.grab_focus()
	
func set_close_delay():
	if (is_enabled()):
		menu_close_delay = 2
	
func close_training_options_menu():
	if (is_enabled()):
		self.visible = false
		emit_signal("close_menu")

func get_takeover_player() -> int:
	return $TakeoverButton.selected

func is_enabled() -> bool:
	return self.visible

func _on_ExitButton_pressed():
	get_tree().paused = false
#	emit_signal("exit")
	call_deferred("emit_signal", "exit")

func _on_ResetButton_pressed():
	get_tree().paused = false
	emit_signal("reset")

func _on_LoadStateButton_pressed():
	emit_signal("loadstate")

func _on_CloseButton_pressed():
	get_tree().paused = false
	set_close_delay()

func _input(event):
	last_input_event = event
	input_helper(event)

func input_helper(event):
	if is_enabled():
		if event.is_action_pressed("player1_start") or event.is_action_pressed("player2_start"):
			_on_CloseButton_pressed()
		elif event.is_action_pressed("player1_cancel") or event.is_action_pressed("player2_cancel") or event.is_action_pressed("menu_back_b"):
			_on_CloseButton_pressed()

func _on_ChangeControlsButton_pressed():
	button_map_paused_before_open = get_tree().paused
	button_menu = BUTTON_MAP_MENU.instantiate()
	button_menu.configure_single_player(last_input_event, true)
	set_process_input(false)
	var focus_owner = get_viewport().gui_get_focus_owner()
	if (focus_owner != null):
		focus_owner.release_focus()
	get_parent().add_child(button_menu)
	button_menu.connect("complete", Callable(self, "button_set_complete"))

func button_set_complete():
	get_tree().paused = button_map_paused_before_open
	button_menu.disconnect("complete", Callable(self, "button_set_complete"))
	button_menu.queue_free()
	button_menu = null
	set_process_input(true)
	$ChangeControlsButton.call_deferred("grab_focus")
