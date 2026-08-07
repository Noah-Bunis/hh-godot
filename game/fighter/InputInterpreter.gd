extends Node

class_name InputInterpreter

var input_prefix := "player1_"

var is_replaying: bool = false
var replay_input: int = 0

func prep_for_replay() -> void:
	is_replaying = true

const numpad_to_dir = [
	{
		Enums.Numpad.N1 : Enums.InputFlags.DOWN | Enums.InputFlags.RIGHT,
		Enums.Numpad.N2 : Enums.InputFlags.DOWN,
		Enums.Numpad.N3 : Enums.InputFlags.DOWN | Enums.InputFlags.LEFT,
		Enums.Numpad.N4 : Enums.InputFlags.RIGHT,
		Enums.Numpad.N5 : 0,
		Enums.Numpad.N6 : Enums.InputFlags.LEFT,
		Enums.Numpad.N7 : Enums.InputFlags.UP | Enums.InputFlags.RIGHT,
		Enums.Numpad.N8 : Enums.InputFlags.UP,
		Enums.Numpad.N9 : Enums.InputFlags.UP | Enums.InputFlags.LEFT
	},
	{
		Enums.Numpad.N1 : Enums.InputFlags.DOWN | Enums.InputFlags.LEFT,
		Enums.Numpad.N2 : Enums.InputFlags.DOWN,
		Enums.Numpad.N3 : Enums.InputFlags.DOWN | Enums.InputFlags.RIGHT,
		Enums.Numpad.N4 : Enums.InputFlags.LEFT,
		Enums.Numpad.N5 : 0,
		Enums.Numpad.N6 : Enums.InputFlags.RIGHT,
		Enums.Numpad.N7 : Enums.InputFlags.UP | Enums.InputFlags.LEFT,
		Enums.Numpad.N8 : Enums.InputFlags.UP,
		Enums.Numpad.N9 : Enums.InputFlags.UP | Enums.InputFlags.RIGHT
	}
]

const direction_flags = Enums.InputFlags.RIGHT | Enums.InputFlags.LEFT | Enums.InputFlags.UP | Enums.InputFlags.DOWN
const vertical_flags = Enums.InputFlags.UP | Enums.InputFlags.DOWN

func _init():
	add_to_group("network_sync")

func _network_process(input: Dictionary) -> void:
	$InputSource.update_input(input)

func get_training_input(leftface) -> int:
	var bit_input = $InputSource.get_input(0)
	# leftface should only be updated at the start of the recording
	if (leftface):
		if (bit_input & Enums.InputFlags.RIGHT):
			bit_input &= ~Enums.InputFlags.RIGHT
			bit_input |= Enums.InputFlags.LEFT
		elif (bit_input & Enums.InputFlags.LEFT):
			bit_input &= ~Enums.InputFlags.LEFT
			bit_input |= Enums.InputFlags.RIGHT
	return bit_input

func get_most_recent_input() -> int:
	return $InputSource.get_input(0)

func _get_local_input() -> Dictionary:
	return read_input()

func read_input() -> Dictionary:
	var bit_input := 0
	if (is_replaying):
		bit_input = replay_input
		var input := {}
		input[Enums.PlayerInput.InputVector] = bit_input
		return input

	var input_vector: Vector2 = Vector2(
			-Input.get_action_strength(input_prefix+"left") + Input.get_action_strength(input_prefix+"right"), 
			-Input.get_action_strength(input_prefix+"down") + Input.get_action_strength(input_prefix+"up"))
	var input_vector_stick: Vector2 = Vector2(
			-Input.get_action_strength(input_prefix+"left_stick") + Input.get_action_strength(input_prefix+"right_stick"), 
			-Input.get_action_strength(input_prefix+"down_stick") + Input.get_action_strength(input_prefix+"up_stick"))
	var virtual_deadzone = 0

	if (input_vector.x == 0 and input_vector.y == 0):
		input_vector.x = input_vector_stick.x
		input_vector.y = input_vector_stick.y
	
	if (input_vector.x < -virtual_deadzone):
		bit_input |= Enums.InputFlags.LEFT
	elif (input_vector.x > virtual_deadzone):
		bit_input |= Enums.InputFlags.RIGHT

	if (input_vector.y < -virtual_deadzone):
		bit_input |= Enums.InputFlags.DOWN
	elif (input_vector.y > virtual_deadzone):
		bit_input |= Enums.InputFlags.UP

	if (Input.get_action_strength(input_prefix+"abcd") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.BHold
		bit_input |= Enums.InputFlags.CHold
		bit_input |= Enums.InputFlags.DHold
	elif (Input.get_action_strength(input_prefix+"abc") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.BHold
		bit_input |= Enums.InputFlags.CHold
	elif (Input.get_action_strength(input_prefix+"bc") > 0):
		bit_input |= Enums.InputFlags.BHold
		bit_input |= Enums.InputFlags.CHold
		
	if (Input.get_action_strength(input_prefix+"ad") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.DHold
	
	if (Input.get_action_strength(input_prefix+"ab") > 0):
		bit_input |= Enums.InputFlags.AHold
		bit_input |= Enums.InputFlags.BHold

	if (Input.get_action_strength(input_prefix+"a") > 0):
		bit_input |= Enums.InputFlags.AHold
	
	if (Input.get_action_strength(input_prefix+"b") > 0):
		bit_input |= Enums.InputFlags.BHold
	
	if (Input.get_action_strength(input_prefix+"c") > 0):
		bit_input |= Enums.InputFlags.CHold
		
	if (Input.get_action_strength(input_prefix+"d") > 0):
		bit_input |= Enums.InputFlags.DHold

	var input := {}
	input[Enums.PlayerInput.InputVector] = bit_input
	return input

func _predict_remote_input(previous_input: Dictionary, _ticks_since_real_input: int) -> Dictionary:
	var input = previous_input.duplicate()
#	if ticks_since_real_input > 5:
#		input.erase(Enums.PlayerInput.InputVector)
	return input

func kara_check(index, button) -> bool:
	var combined = ($InputSource.get_input(index) | $InputSource.get_input(index + 1)) & button
	return combined == button

func long_kara_check(index, button) -> bool:
	var combined = ($InputSource.get_input(index) | $InputSource.get_input(index + 1) | $InputSource.get_input(index + 2)) & button
	return combined == button

func is_button_down(button) -> bool:
	#Yes,
	#button - int
	#	can also be UP. Negative edge inputs
	#	can also be HOLD, !is_button_down for not held
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (kara_check(i, button)):
			return true
	return false

func burst() -> bool:
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (long_kara_check(i, Enums.InputFlags.ADown | Enums.InputFlags.BDown | Enums.InputFlags.CDown | Enums.InputFlags.DDown)):
			return true
	return false


func is_holding_a_direction(direction, left_face) -> bool:
	return is_holding_a_direction_index(0, direction, left_face)

func is_holding_a_direction_index(index, direction, left_face) -> bool:
	var bit_direction
	if (left_face):
		bit_direction = numpad_to_dir[0][direction]
	else:
		bit_direction = numpad_to_dir[1][direction]
	# try mapping a direction of direction to bit representation
	
	return bit_direction == $InputSource.get_input(index) & (Enums.InputFlags.RIGHT | 
		Enums.InputFlags.LEFT | Enums.InputFlags.UP | Enums.InputFlags.DOWN)

func tap_numpad_direction(index, direction, left_face) -> bool:
	var bit_direction
	if (left_face):
		bit_direction = numpad_to_dir[0][direction]
	else:
		bit_direction = numpad_to_dir[1][direction]
	# try mapping a direction of direction to bit representation
	
	return bit_direction == ($InputSource.get_input(index) & direction_flags) && bit_direction != ($InputSource.get_input(index+1) & direction_flags)

func is_tapping_direction(direction, left_face) -> bool:
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (tap_numpad_direction(i, direction, left_face)):
			return true
	return false

func is_blocking(left_face) -> bool:
	return is_holding_a_direction(Enums.Numpad.N4, left_face) || is_holding_a_direction(Enums.Numpad.N1, left_face) || is_holding_a_direction(Enums.Numpad.N7, left_face)

func is_low_blocking(left_face) -> bool:
	return is_holding_a_direction(Enums.Numpad.N1, left_face) || is_holding_a_direction(Enums.Numpad.N2, left_face) || is_holding_a_direction(Enums.Numpad.N3, left_face)

func tap_switch_direction(index, switch_dir) -> bool:
	# As in joystick push-switches. Good for jumps, low crossup protection, charging (kinda)
	#TODO: Try to do one set of comparisons
	return (switch_dir == ($InputSource.get_input(index) & direction_flags & switch_dir)) && (switch_dir != ($InputSource.get_input(index+1) & direction_flags & switch_dir))

func is_tap_jumping() -> bool:
	var bit_direction = Enums.InputFlags.UP
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (tap_switch_direction(i, bit_direction)):
			return true
	return false

func is_just_blocking(leftface) -> bool:
	var bit_direction = Enums.InputFlags.LEFT
	if (leftface):
		bit_direction = Enums.InputFlags.RIGHT
	for i in range(Util.JUST_BLOCK_WINDOW):
		if (tap_switch_direction(i, bit_direction)):
			return true
	return false

func is_push_blocking() -> bool:
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (kara_check(i, Enums.InputFlags.BHold | Enums.InputFlags.CHold)):
			return true
	return false

func button_dash(forward:bool, left_face:bool) -> bool:
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (kara_check(i, Enums.InputFlags.ADown | Enums.InputFlags.BDown)):
			if (forward):
				return is_holding_a_direction_index(i, Enums.Numpad.N6, left_face)
			else:
				return is_holding_a_direction_index(i, Enums.Numpad.N4, left_face)
	return false

func button_dash_four_way(numpad: int, left_face:bool) -> bool:
	for i in range(Util.INPUT_BUFFER_LENIANCY):
		if (is_holding_a_direction_index(i, numpad, left_face)):
			if (long_kara_check(i, Enums.InputFlags.ADown | Enums.InputFlags.BDown) or 
					long_kara_check(i, Enums.InputFlags.BDown | Enums.InputFlags.CDown) or 
					long_kara_check(i, Enums.InputFlags.ADown | Enums.InputFlags.CDown)):
				return true
	return false

func is_dashing(forward:bool, left_face:bool) -> bool:
	return (is_stick_dashing(forward, left_face) or button_dash(forward, left_face))

func is_stick_dashing(forward:bool, left_face:bool) -> bool:
	if (forward):
		return special_input_no_hold(Enums.SpecialInput.FDash, left_face)
	else:
		return special_input_no_hold(Enums.SpecialInput.BDash, left_face)

func is_button_dashing(forward:bool, left_face:bool) -> bool:
	return button_dash(forward, left_face)

func is_air_dashing(forward:bool, left_face:bool) -> bool:
	return (is_stick_air_dashing(forward, left_face) or button_dash(forward, left_face))

func is_air_dashing_four_way(numpad:int, left_face:bool) -> bool:
	return (is_stick_air_dashing_four_way(numpad, left_face) or button_dash_four_way(numpad, left_face))
	
func is_stick_air_dashing(forward:bool, left_face:bool) -> bool:
	if (forward):
		return special_input_no_hold(Enums.SpecialInput.FAirDash, left_face)
	else:
		return special_input_no_hold(Enums.SpecialInput.BAirDash, left_face)

func is_stick_air_dashing_four_way(numpad:int, left_face:bool) -> bool:
	if (numpad == Enums.Numpad.N6):
		return special_input_no_hold(Enums.SpecialInput.FAirDash, left_face)
	elif (numpad == Enums.Numpad.N4):
		return special_input_no_hold(Enums.SpecialInput.BAirDash, left_face)
	elif (numpad == Enums.Numpad.N8):
		return special_input_no_hold(Enums.SpecialInput.UAirDash, left_face)
	elif (numpad == Enums.Numpad.N2):
		return special_input_no_hold(Enums.SpecialInput.DAirDash, left_face)
	else:
		return false

func special_input_button(input, buttons, left_face) -> bool:
	if (is_button_down(buttons)):
		return special_input(input, left_face)
	return false 

func special_input(input, left_face) -> bool:
	var time = input[0]
	for i in range(1, len(input)):
		var hist_index = 0 # index in input history, 0 is most recent
		var moveIndex = 0
		var move = input[i]
		var moveOK:bool = is_holding_a_direction_index(hist_index, move[moveIndex], left_face)
		while (moveOK and hist_index < time):
			if (not is_holding_a_direction_index(hist_index, move[moveIndex], left_face)):
				moveIndex += 1
				moveOK = is_holding_a_direction_index(hist_index, move[moveIndex], left_face)
				if (moveIndex >= len(move)-1 and moveOK):
					return true
			hist_index += 1
	return false

func special_input_no_hold(input, left_face) -> bool:
	var time = input[0]
	for i in range(1, len(input)):
		var hist_index = 0 # index in input history, 0 is most recent
		var moveIndex = 0
		var move = input[i]
		var moveOK:bool = is_holding_a_direction_index(hist_index, move[moveIndex], left_face)
		while (moveOK and hist_index < time):
			if (not is_holding_a_direction_index(hist_index, move[moveIndex], left_face)):
				moveIndex += 1
				if (moveIndex >= len(move)):
					return true
				moveOK = is_holding_a_direction_index(hist_index, move[moveIndex], left_face)
			hist_index += 1
	return false

func super_jump() -> bool:
	var time:int = Enums.SpecialInput.superJump[0]
	var input = Enums.SpecialInput.superJump
	var hist_index = 0 # index in input history, 0 is most recent
	var moveIndex = 1
	var moveOK:bool = input[moveIndex] == $InputSource.get_input(hist_index) & vertical_flags
	while (moveOK and hist_index < time):
		if (input[moveIndex] != $InputSource.get_input(hist_index) & vertical_flags):
			moveIndex += 1
			if (moveIndex >= len(input)-1):
				return true
			moveOK = input[moveIndex] == $InputSource.get_input(hist_index) & vertical_flags
		hist_index += 1
	return _super_jump_short_cut()

func _super_jump_short_cut() -> bool:
	# Spaghetti, but there are some strange bugs when trying to refactor superjump function
	var time:int = Enums.SpecialInput.superJumpShortCut[0]
	var input = Enums.SpecialInput.superJumpShortCut
	var hist_index = 0 # index in input history, 0 is most recent
	var moveIndex = 1
	var moveOK:bool = input[moveIndex] == $InputSource.get_input(hist_index) & vertical_flags
	while (moveOK and hist_index < time):
		if (input[moveIndex] != $InputSource.get_input(hist_index) & vertical_flags):
			moveIndex += 1
			if (moveIndex >= len(input)-1):
				return true
			moveOK = input[moveIndex] == $InputSource.get_input(hist_index) & vertical_flags
		hist_index += 1
	return false

func clear_history():
	$InputSource.clear_inputs()

func dump_ordered_input_history():
	return $InputSource.dump_ordered_input()
