extends "res://game/menus/buttonmap/ButtonMapMenuBase.gd"

class_name KeyboardButtonMapMenu

func _ready():
	super._ready()
	ARROW_SPRITE_JUMP = 52

func free_button_menu():
	queue_free()

func set_is_p1(is_p1:bool):
	self.is_p1 = is_p1
	input_map_actions = ["player1_up", "player1_left", "player1_down", "player1_right", "player1_a", "player1_b", "player1_c", "player1_d", "player1_ab", "player1_ad", "player1_bc", "player1_abc", "player1_abcd", "player1_cancel", "player1_record", "player1_replay"]
	if (not is_p1):
		input_map_actions = ["player2_up", "player2_left", "player2_down", "player2_right", "player2_a", "player2_b", "player2_c", "player2_d", "player2_ab", "player2_ad", "player2_bc", "player2_abc", "player2_abcd", "player2_cancel", "player2_record", "player2_replay"]

	for i in range (0, len(input_map_actions)):
		var input_action = input_map_actions[i]
		var appended = false
		for input_event in InputMap.action_get_events(input_action):
			if (input_event is InputEventKey):
				actions_to_buttons.append(input_event)
				display_button(i, input_event.physical_keycode)
				appended = true
				break
		if (not appended):
			var new_event = InputEventKey.new()
			new_event.physical_keycode = 0
			actions_to_buttons.append(new_event)
			display_button(i, new_event.physical_keycode)
	ready_for_inputs = true

func display_button(list_index: int, button_index: int):
	var button_output = "["
	button_output += OS.get_keycode_string(button_index)
	button_output += "]"
	$ButtonMapBase/GridContainer.get_node(str(list_index)).text = button_output

func valid_attack_button(event: InputEventKey):
	var reserved = [
#		KEY_W, KEY_A, KEY_S, KEY_D,
#		KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN,
		KEY_ESCAPE, KEY_TAB,
	]
	for reserve_key in reserved:
		if (event.physical_keycode == reserve_key):
			return false
	return true

func valid_unmap_action(event):
	var correct_device: bool = false
	var is_right_input = false
	if (is_p1):
		correct_device = true
		is_right_input = Input.is_action_just_pressed("player1_start")
	elif (not is_p1):
		correct_device = true
		is_right_input = Input.is_action_just_pressed("player2_start")
	var is_unmap_action = is_right_input
	return correct_device and is_unmap_action

func prep_new_button(button: int):
	super.unmap_button()
	var new_event = InputEventKey.new()
	new_event.physical_keycode = button
	# switch events if new_event is the same button as existing event 
	var action_index = find_button_by_action(new_event.physical_keycode)
	if (action_index != -1):
		var old_event = actions_to_buttons[current_button]
		actions_to_buttons[action_index] = old_event
		display_button(action_index, old_event.physical_keycode)
	actions_to_buttons[current_button] = new_event
	display_button(current_button, new_event.physical_keycode)
	MainMenuMusicControl.play_cursor_select()
	
func unmap_button():
	super.unmap_button()
	var new_event = InputEventKey.new()
#	if (is_p1):
#		new_event.device = Global.p1_device_id
#	else:
#		new_event.device = Global.p2_device_id
	new_event.physical_keycode = 0
	# switch events if new_event is the same button as existing event 
	actions_to_buttons[current_button] = new_event
	display_button(current_button, new_event.physical_keycode)
	MainMenuMusicControl.play_cursor_deselect()


func find_button_by_action(button_index):
	for i in range(0, len(actions_to_buttons)):
		if (actions_to_buttons[i].physical_keycode == button_index):
			return i
	return -1

func set_new_buttons():
	for i in range(0, len(input_map_actions)):
		var input_action: String = input_map_actions[i]
		var event_action: InputEventKey = actions_to_buttons[i]
		Input.action_release(input_action)
		for input_event in InputMap.action_get_events(input_action):
			if (input_event is InputEventKey):
				InputMap.action_erase_event(input_action, input_event)
		InputMap.action_add_event(input_action, event_action)
#		var appended = false
#		for input_event in InputMap.get_action_list(input_action): 
#			if (input_event is InputEventKey):
#				input_event.physical_scancode = event_action.physical_scancode
#				appended = true
#		if (not appended):
#			InputMap.action_add_event(input_action, event_action)
	var is_key = true
	Util.save_control_scheme(is_p1, is_key)
	Util.set_input_map_ui_controls()
	OK_delay = 5
	MainMenuMusicControl.play_cursor_select()
	emit_signal("button_set_complete", is_p1)

func input_helper(event: InputEvent):
	if (ready_for_inputs and event is InputEventKey and button_cooldown <= 0):
		if (is_p1):
#			if (Util.is_down_pressed_prefix("player1_")):
#				advance_to_next_button()
#			elif (Util.is_up_pressed_prefix("player1_")):
#				advance_to_prev_button()
#			if (Input.is_action_just_pressed("player1_start")):
#				OK_delay = 5
			if (event.is_pressed() and valid_attack_button(event)):
				if (current_button == len(input_map_actions)):
					set_new_buttons()
				else:
					prep_new_button(event.physical_keycode)
					advance_to_next_button()
			elif (valid_unmap_action(event)):
				if (current_button < len(input_map_actions)):
					unmap_button()
					advance_to_next_button()
				elif (current_button == len(input_map_actions)):
					set_new_buttons()
		elif (not is_p1):
#			if (Util.is_down_pressed_prefix("player2_")):
#				advance_to_next_button()
#			elif (Util.is_up_pressed_prefix("player2_")):
#				advance_to_prev_button()
#			elif (Input.is_action_just_pressed("player2_start")):
#				OK_delay = 5
			if (event.is_pressed() and valid_attack_button(event)):
				if (current_button == len(input_map_actions)):
					set_new_buttons()
				else:
					prep_new_button(event.physical_keycode)
					advance_to_next_button()
			elif (event.is_pressed() and valid_unmap_action(event)):
				if (current_button < len(input_map_actions)):
					unmap_button()
					advance_to_next_button()
				elif (current_button == len(input_map_actions)):
					set_new_buttons()
