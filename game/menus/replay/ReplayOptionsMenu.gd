extends GridContainer

const VIEWPORT_MARGIN := 32.0

@onready var BUTTON_MAP_MENU = preload("res://game/menus/buttonmap/ButtonMapMenuScreen.tscn")
var button_menu

signal close_menu()
signal exit()
signal reset()
signal loadstate()
signal frame_bar_toggled(is_visible: bool)
signal assist_frame_bars_toggled(is_visible: bool)
signal punish_analysis_toggled(player_index: int, is_visible: bool)
signal move_data_toggled(player_index: int, is_visible: bool)

var menu_close_delay: int
var most_recent_focus:Control
var button_map_paused_before_open: bool
var last_input_event: InputEvent
var frame_bar_visible := false
var assist_frame_bars_visible := false
var punish_analysis_visible: Array[bool] = [false, false]
var move_data_visible: Array[bool] = [false, false]
var _base_position: Vector2
var _base_scale: Vector2
var _base_size: Vector2
var _layout_ready := false

func _on_focus_changed(control: Control) -> void:
	if control != null and is_ancestor_of(control):
		most_recent_focus = control

func _ready():
	_base_position = position
	_base_scale = scale
	_base_size = size
	_layout_ready = true
	get_viewport().size_changed.connect(_fit_to_viewport)
	get_viewport().connect("gui_focus_changed", Callable(self, "_on_focus_changed"))
	most_recent_focus = $CloseButton
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$TakeoverButton.add_item(tr("UI_TRAINING_NONE"), 0)
	$TakeoverButton.add_item(tr("UI_REPLAY_PLAYER_ONE"), 1)
	$TakeoverButton.add_item(tr("UI_REPLAY_PLAYER_TWO"), 2)
	_update_player_button_texts()
	call_deferred("_fit_to_viewport")
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and _layout_ready:
		_update_player_button_texts()
		call_deferred("_fit_to_viewport")

func _update_player_button_texts() -> void:
	var player_labels := [tr("UI_REPLAY_PLAYER_ONE"), tr("UI_REPLAY_PLAYER_TWO")]
	var move_buttons := [$MoveDataButton, $MoveDataP2Button]
	var punish_buttons := [$PunishAnalysisButton, $PunishAnalysisP2Button]
	for player_index in range(2):
		var move_status := tr("UI_TRAINING_ON") if move_data_visible[player_index] else tr("UI_TRAINING_OFF")
		var punish_status := tr("UI_TRAINING_ON") if punish_analysis_visible[player_index] else tr("UI_TRAINING_OFF")
		move_buttons[player_index].text = "%s: %s" % [player_labels[player_index], move_status]
		punish_buttons[player_index].text = "%s: %s" % [player_labels[player_index], punish_status]
	$FrameBarButton.text = tr("UI_TRAINING_ON") if frame_bar_visible else tr("UI_TRAINING_OFF")
	$AssistFrameBarButton.text = tr("UI_TRAINING_ON") if assist_frame_bars_visible else tr("UI_TRAINING_OFF")
	if $TakeoverButton.item_count == 3:
		$TakeoverButton.set_item_text(0, tr("UI_TRAINING_NONE"))
		$TakeoverButton.set_item_text(1, player_labels[0])
		$TakeoverButton.set_item_text(2, player_labels[1])

func _fit_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var margin := minf(VIEWPORT_MARGIN, minf(viewport_size.x, viewport_size.y) * 0.05)
	var available_size := viewport_size - Vector2.ONE * margin * 2.0
	var content_size := _base_size.max(get_combined_minimum_size())
	var base_display_size := content_size * _base_scale
	var fit_scale := minf(
		1.0,
		minf(available_size.x / base_display_size.x, available_size.y / base_display_size.y)
	)
	size = content_size
	$Background.position = content_size / 2.0
	$Background.scale = content_size / $Background.texture.get_size()
	scale = _base_scale * fit_scale
	var displayed_size := content_size * scale
	position = Vector2(
		clampf(_base_position.x, margin, viewport_size.x - displayed_size.x - margin),
		clampf(_base_position.y, margin, viewport_size.y - displayed_size.y - margin)
	)

func _physics_process(delta):
	if menu_close_delay > 0:
		menu_close_delay -= 1
		if (menu_close_delay == 0):
			close_training_options_menu()

func open_training_options_menu():
	if (not is_enabled()):
		self.visible = true
		call_deferred("_fit_to_viewport")
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

func _on_FrameBarButton_pressed() -> void:
	frame_bar_visible = not frame_bar_visible
	$FrameBarButton.text = tr("UI_TRAINING_ON") if frame_bar_visible else tr("UI_TRAINING_OFF")
	frame_bar_toggled.emit(frame_bar_visible)

func _on_AssistFrameBarButton_pressed() -> void:
	assist_frame_bars_visible = not assist_frame_bars_visible
	$AssistFrameBarButton.text = tr("UI_TRAINING_ON") if assist_frame_bars_visible else tr("UI_TRAINING_OFF")
	assist_frame_bars_toggled.emit(assist_frame_bars_visible)

func _on_PunishAnalysisButton_pressed() -> void:
	_toggle_punish_analysis(0)

func _on_PunishAnalysisP2Button_pressed() -> void:
	_toggle_punish_analysis(1)

func _toggle_punish_analysis(player_index: int) -> void:
	punish_analysis_visible[player_index] = not punish_analysis_visible[player_index]
	_update_player_button_texts()
	call_deferred("_fit_to_viewport")
	punish_analysis_toggled.emit(player_index, punish_analysis_visible[player_index])

func _on_MoveDataButton_pressed() -> void:
	_toggle_move_data(0)

func _on_MoveDataP2Button_pressed() -> void:
	_toggle_move_data(1)

func _toggle_move_data(player_index: int) -> void:
	move_data_visible[player_index] = not move_data_visible[player_index]
	_update_player_button_texts()
	call_deferred("_fit_to_viewport")
	move_data_toggled.emit(player_index, move_data_visible[player_index])

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
