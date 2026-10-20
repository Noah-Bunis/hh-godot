extends "res://game/menus/buttonmap/ButtonMapMenuBase.gd"

class_name ButtonMapMenu

var is_rt_down: bool = false
var is_lt_down: bool = false

func _ready():
	super._ready()

func free_button_menu():
	queue_free()

func set_is_p1(is_p1:bool):
	self.is_p1 = is_p1
	input_map_actions = ["player1_a", "player1_b", "player1_c", "player1_d", "player1_ab", "player1_ad", "player1_bc", "player1_abc", "player1_abcd", "player1_cancel", "player1_record", "player1_replay"]
	if (not is_p1):
		input_map_actions = ["player2_a", "player2_b", "player2_c", "player2_d", "player2_ab", "player2_ad", "player2_bc", "player2_abc", "player2_abcd", "player2_cancel", "player2_record", "player2_replay"]

	for i in range (0, len(input_map_actions)):
		var input_action = input_map_actions[i]
		var appended = false
		for input_event in InputMap.action_get_events(input_action):
			if (input_event is InputEventJoypadButton):
				actions_to_buttons.append(input_event)
				display_button(i, input_event.button_index)
				appended = true
				break
			elif (input_event is InputEventJoypadMotion):
				actions_to_buttons.append(input_event)
				display_button(i, input_event.axis, true)
				appended = true
				break
		if (not appended):
			var new_event = InputEventJoypadButton.new()
			new_event.button_index = 127
			actions_to_buttons.append(new_event)
			display_button(i, new_event.button_index)
	ready_for_inputs = true

func display_button(list_index: int, button_index: int, is_axis:bool=false):
	var button_output = "("
	if (not is_axis):
		match button_index:
			JOY_BUTTON_A:
				button_output += "A"
			JOY_BUTTON_B:
				button_output += "B"
			JOY_BUTTON_X:
				button_output += "X"
			JOY_BUTTON_Y:
				button_output += "Y"
			JOY_BUTTON_LEFT_SHOULDER:
				button_output += "L1"
			JOY_BUTTON_RIGHT_SHOULDER:
				button_output += "R1"
			JOY_BUTTON_LEFT_STICK:
				button_output += "L3"
			JOY_BUTTON_RIGHT_STICK:
				button_output += "R3"
			JOY_BUTTON_BACK:
				button_output += "Select"
			JOY_BUTTON_GUIDE:
				button_output += "Home"
			JOY_BUTTON_A:
				button_output += "Share"
			JOY_BUTTON_PADDLE1:
				button_output += "Paddle1"
			JOY_BUTTON_PADDLE2:
				button_output += "Paddle2"
			JOY_BUTTON_PADDLE3:
				button_output += "Paddle3"
			JOY_BUTTON_PADDLE4:
				button_output += "Paddle4"
			JOY_BUTTON_TOUCHPAD:
				button_output += "TouchPad"
			127:
				button_output += ""
			_:
				button_output += "?"
	else:
		match button_index:
			JOY_AXIS_TRIGGER_LEFT:
				button_output += "L2"
			JOY_AXIS_TRIGGER_RIGHT:
				button_output += "R2"
			_:
				button_output += "?Axis"
	button_output += ")"
	$ButtonMapBase/GridContainer.get_node(str(list_index)).text = button_output

func valid_attack_button(event, is_axis:bool=false):
	var correct_device: bool = false
	if (is_p1 and event.device == Global.p1_device_id):
		correct_device = true
	elif (not is_p1 and event.device == Global.p2_device_id):
		correct_device = true
	if (correct_device):
		if (is_axis):
			return (event.axis == JOY_AXIS_TRIGGER_RIGHT or event.axis == JOY_AXIS_TRIGGER_LEFT)
		else:
			return not (event.button_index == 11 or 
				event.button_index == 12 or 
				event.button_index == 13 or
				event.button_index == 14 or 
				event.button_index == 15)
	return false

func valid_unmap_action(event):
	var correct_device: bool = false
	var is_right_input = false
	if (is_p1 and event.device == Global.p1_device_id):
		correct_device = true
		is_right_input = Util.is_right_pressed_prefix("player1_")
	elif (not is_p1 and event.device == Global.p2_device_id):
		correct_device = true
		is_right_input = Util.is_right_pressed_prefix("player2_")
	var is_unmap_action = is_right_input
	return correct_device and is_unmap_action

func prep_new_button(event):
	super.unmap_button()
	var new_event
	var new_event_button
	var old_event_button
	var is_axis:bool
	
	if (event is InputEventJoypadMotion):
		is_axis = true
		new_event = InputEventJoypadMotion.new()
		new_event_button = event.axis
		new_event.axis = event.axis
	else:
		is_axis = false
		new_event = InputEventJoypadButton.new()
		new_event.button_index = event.button_index
		new_event_button = event.button_index

	if (is_p1):
		new_event.device = Global.p1_device_id
	else:
		new_event.device = Global.p2_device_id
	# switch events if new_event is the same button as existing event 
	var action_index = find_button_by_action(new_event_button, is_axis)
	if (action_index != -1):
		var old_event = actions_to_buttons[current_button]
		var is_old_axis = true
		if (old_event is InputEventJoypadMotion):
			old_event_button = old_event.axis
		elif (old_event is InputEventJoypadButton):
			old_event_button = old_event.button_index
			is_old_axis = false
		actions_to_buttons[action_index] = old_event
		display_button(action_index, old_event_button, is_old_axis)
	actions_to_buttons[current_button] = new_event
	display_button(current_button, new_event_button, is_axis)
	MainMenuMusicControl.play_cursor_select()

func unmap_button():
	super.unmap_button()
	var new_event = InputEventJoypadButton.new()
	if (is_p1):
		new_event.device = Global.p1_device_id
	else:
		new_event.device = Global.p2_device_id
	new_event.button_index = 127
	# switch events if new_event is the same button as existing event 
	actions_to_buttons[current_button] = new_event
	display_button(current_button, new_event.button_index)
	MainMenuMusicControl.play_cursor_deselect()

func find_button_by_action(button_index, is_axis=false):
	for i in range(0, len(actions_to_buttons)):
		if (is_axis):
			if (actions_to_buttons[i] is InputEventJoypadMotion and 
					actions_to_buttons[i].axis == button_index):
				return i
		else:
			if (actions_to_buttons[i] is InputEventJoypadButton and 
					actions_to_buttons[i].button_index == button_index):
				return i
	return -1

func set_new_buttons():
	for i in range(0, len(input_map_actions)):
		var input_action: String = input_map_actions[i]
		var event_action = actions_to_buttons[i]
		Input.action_release(input_action)
		InputMap.action_erase_events(input_action)
		InputMap.action_add_event(input_action, event_action)
	var is_key = false
	Util.save_control_scheme(is_p1, is_key)
	Util.set_input_map_ui_controls()
	OK_delay = 5
	MainMenuMusicControl.play_cursor_select()
	emit_signal("button_set_complete", is_p1)

func input_helper(event: InputEvent):
	if (ready_for_inputs and button_cooldown <= 0):
		var prefix = "player1_"
		if (is_p1 and event.device == Global.p1_device_id):
			prefix = "player1_"
		elif (not is_p1 and event.device == Global.p2_device_id):
			prefix = "player2_"
		else:
			# could be mouse events and other things
			return 
			
		if (event is InputEventJoypadButton or event is InputEventJoypadMotion):
			var is_axis = event is InputEventJoypadMotion
			
			if (not is_axis and Input.is_action_just_pressed(prefix+"start")):
				if (current_button == len(input_map_actions)):
					set_new_buttons()
				else:
					OK_delay = 5
			elif (Util.is_down_pressed_prefix(prefix)):
				advance_to_next_button()
				MainMenuMusicControl.play_cursor_move()
			elif (Util.is_up_pressed_prefix(prefix)):
				advance_to_prev_button()
				MainMenuMusicControl.play_cursor_move()
			elif (valid_unmap_action(event)):
				if (current_button < len(input_map_actions)):
					unmap_button()
					advance_to_next_button()
			elif (event.is_pressed() and valid_attack_button(event, is_axis)):
				if (is_axis):
					if (is_rt_down and event.axis == JOY_AXIS_TRIGGER_RIGHT):
						return 
					elif (is_lt_down and event.axis == JOY_AXIS_TRIGGER_LEFT):
						return
					if (not is_rt_down and event.axis == JOY_AXIS_TRIGGER_RIGHT):
						is_rt_down = true
					if (not is_lt_down and event.axis == JOY_AXIS_TRIGGER_LEFT):
						is_lt_down = true
				if (current_button == len(input_map_actions)):
					set_new_buttons()
				else:
					prep_new_button(event)
					advance_to_next_button()
			
			if (event.is_released() and is_axis):
				if (event.axis == JOY_AXIS_TRIGGER_RIGHT):
					is_rt_down = false
				if (event.axis == JOY_AXIS_TRIGGER_LEFT):
					is_lt_down = false
