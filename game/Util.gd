extends Node

const GRAVITY := SGFixed.ONE*3
const OLLIE_GRAVITY := SGFixed.ONE*2
const KANATA_GRAVITY := 185800
const JUGGLE_GRAVITY := 183500
const OLLIE_FAST_FALL_GRAVITY := 285800

const DEFAULT_HITSTOP := 8
const DEFAULT_BLOCKSTUN := 15
const DEFAULT_HITSTUN := 17
const DEFAULT_LIGHT_BLOCKSTUN := 13
const DEFAULT_LIGHT_HITSTUN := 15
const BONUS_JUGGLE_HITSTUN := 1
const IBFD_EXTRA_BLOCKSTUN := 8
const FD_EXTRA_BLOCKSTUN := 4
const IB_REDUCED_BLOCKSTUN := 7
const IB_REDUCED_AIR_BLOCKSTUN := 10
const PARRY_REDUCED_HITSTOP := 5
const ASSIST_EXIT_RECOVERY := 40
const FORCE_UNDIZZY := 450

const HYPER_FRICTION := 405536
const FD_FRICTION := 205536
const FRICTION := 125536
const MOD_FRICTION := 148536
const SLIPPERY_FRICTION := 105536
const SKID_FRICTION := 75536
const ICE_FRICTION := 55536
const SUPER_ICE_FRICTION := 15536
const COMBO_FRICTION := 115536
const MAX_VELOCITY_X := SGFixed.ONE*120 # 120
const MAX_VELOCITY_Y := SGFixed.ONE*120 # 120

const BASE_STRIKE_X_PUSHBACK := -SGFixed.ONE*27 # -SGFixed.ONE*28
const BASE_SHORT_STRIKE_X_PUSHBACK := -SGFixed.ONE*25 # -SGFixed.ONE*25
const BASE_AIR_Y_PUSHBACK := -SGFixed.ONE*30
const BASE_AIR_X_MULT := 16990 # 16384 * -SGFixed.ONE*28 = -SGFixed.ONE*7
const CROUCH_PUSHBACK_MULT := 58514
const ASSIST_PUSHBACK_MULT := 59514
const STAND_IB_PUSHBACK_MULT := 35746 # 35746
const CROUCH_IB_PUSHBACK_MULT := 45536 # 55536
const FD_PUSHBACK := -SGFixed.ONE*32 # -SGFixed.ONE*30
const IBFD_PUSHBACK := -SGFixed.ONE*60
const CORNER_PUSHBACK := -SGFixed.ONE*20

const GROUND_HEIGHT := 29112364
const PUSHBOX_SIZE := 2063232
const CORNER_POS := 175570000
const MIN_IAD_HEIGHT := SGFixed.ONE*140 # SGFixed.ONE*100
const DEATH_PLANE_Y := 35000000
const PROXY_NORMAL := SGFixed.ONE*250
const HIT_EFFECT_Y_OFFSET := SGFixed.ONE*170
const THROW_HIT_PUSH := -SGFixed.ONE*18
const BACK_THROW_HIT_PUSH := SGFixed.ONE*50

const LEVEL_ONE_SUPER := SGFixed.ONE*10000
const LEVEL_TWO_SUPER := LEVEL_ONE_SUPER*2
const LEVEL_THREE_SUPER := LEVEL_ONE_SUPER*3
const MAX_SUPER_METER := LEVEL_ONE_SUPER*5
const ASSIST_STOCK := SGFixed.ONE*10000
const MAX_ASSIST_METER := ASSIST_STOCK*4
const BASE_SYNC_RATE := SGFixed.ONE*30
const MAX_HP := 563 #563 # have confidence
const TOTAL_ROUND_TIME := 6000 # 6000

const PARRY_HIT_STOP := 11
const PARRY_ATTACKER_EXTRA_HIT_STOP := 4
const PARRY_SKIP_CANCEL_FRAME := INPUT_BUFFER_LENIANCY + 1
const PARRY_SYNC_RATE_BOOST := SGFixed.ONE*25
const PARRY_SUPER_METER_BOOST := SGFixed.ONE*1500
const PARRY_WINDOW := 8 # 6
const PARRY_METER_COST := 0 # SGFixed.ONE*3500 and 2500
const JUST_BLOCK_WINDOW := 8
const RED_PARRY_WINDOW := 3

const INPUT_BUFFER_LENIANCY := 1

const THROW_PROTECT_FRAME := 6
const BASE_ASSIST_RECOVERY := 45 # 45
const BASE_AIR_ASSIST_RECOVERY := 55
const BOOST_CANCEL_SYNC_RATE_UP := SGFixed.ONE*30
const EARLY_AIR_DASH_STARTUP := 0
const AIR_DASH_STARTUP := 3
const AIR_DASH_CANCEL_FRAME := 6 # 7
const BOOST_CANCEL_RECOVERY := 2

const SHADOW_POSITION_Y = 443

const GROUND_BOUNCE_HITSTOP = 3
const GROUND_BOUNCE_POWER_DECAY = -60536

const GROUND_THROW_SYNC_BOOST := SGFixed.ONE*20
const FIRST_HIT_SYNC_BOOST := SGFixed.ONE*20
const SUPPORT_FIRST_HIT_SYNC_BOOST := SGFixed.ONE*20

const ANGEL_METER_DRAIN := SGFixed.ONE*60
const ANGEL_FAST_METER_DRAIN := SGFixed.ONE*80

const FLIGHT_METER_DRAIN := SGFixed.ONE*72
const FLIGHT_ATTACK_METER_DRAIN := SGFixed.ONE*80

const MAX_COLOR_PALETTE_NUMBER := 4

var left_axis_neutral: bool = true
var right_axis_neutral: bool = true
var up_axis_neutral: bool = true
var down_axis_neutral: bool = true

func _ready() -> void:
	Input.connect("joy_connection_changed", Callable(self, "update_controllers"))

func is_left_pressed(is_p1: bool):
	if (is_p1):
		return is_left_pressed_prefix("player1_")
	else:
		return is_left_pressed_prefix("player2_")

func is_left_pressed_prefix(input_prefix: String):
	var prev_left_axis_neutral = left_axis_neutral
	if (Input.is_action_just_pressed(input_prefix+"left")):
		left_axis_neutral = false
		return prev_left_axis_neutral
	elif (Input.is_action_just_pressed(input_prefix+"left_stick")):
		left_axis_neutral = false
		return prev_left_axis_neutral
	else:
		left_axis_neutral = true

func is_right_pressed(is_p1: bool):
	if (is_p1):
		return is_right_pressed_prefix("player1_")
	else:
		return is_right_pressed_prefix("player2_")

func is_right_pressed_prefix(input_prefix: String):
	var prev_right_axis_neutral = right_axis_neutral
	if (Input.is_action_just_pressed(input_prefix+"right")):
		right_axis_neutral = false
		return prev_right_axis_neutral
	elif (Input.is_action_just_pressed(input_prefix+"right_stick")):
		right_axis_neutral = false
		return prev_right_axis_neutral
	else:
		right_axis_neutral = true

func is_left_held_prefix(input_prefix: String):
	if (Input.get_action_strength(input_prefix+"left") > 0):
		return true
	elif (Input.get_action_strength(input_prefix+"left_stick") > 0):
		return true
	else:
		return false

func is_right_held_prefix(input_prefix: String):
	if (Input.get_action_strength(input_prefix+"right") > 0):
		return true
	elif (Input.get_action_strength(input_prefix+"right_stick") > 0):
		return true
	else:
		return false

func is_up_pressed_prefix(input_prefix: String):
	var prev_up_axis_neutral = up_axis_neutral
	if (Input.is_action_just_pressed(input_prefix+"up")):
		up_axis_neutral = false
		return prev_up_axis_neutral
	elif (Input.is_action_just_pressed(input_prefix+"up_stick")):
		up_axis_neutral = false
		return prev_up_axis_neutral
	else:
		up_axis_neutral = true

func is_down_pressed_prefix(input_prefix: String):
	var prev_down_axis_neutral = down_axis_neutral
	if (Input.is_action_just_pressed(input_prefix+"down")):
		down_axis_neutral = false
		return prev_down_axis_neutral
	elif (Input.is_action_just_pressed(input_prefix+"down_stick")):
		down_axis_neutral = false
		return prev_down_axis_neutral
	else:
		down_axis_neutral = true

func damage_scaling(damage: int, minDamage: int, hitCount: int) -> int:
	var damageF = SGFixed.from_int(damage)
	var scaledF: int = SGFixed.mul(damageF, damage_scaling_percent(hitCount))
	return Util.fixed_max(SGFixed.to_int(scaledF), minDamage)

func damage_scaling_percent(hitCount: int) -> int:
	# warning, percent can be negative
	var percentF: int = 65536
#	percentF = SGFixed.mul(SGFixed.cos(SGFixed.mul(hitCountF, 8536)), 18536)
	if (hitCount <= 1):
		pass
	elif (hitCount == 2):
		percentF = 35237
	elif (hitCount == 3):
		percentF = 21769
	elif (hitCount == 4):
		percentF = 17932
	elif (hitCount == 5):
		percentF = 13792
	elif (hitCount == 6):
		percentF = 11355
	else:
		percentF = 9353 - (1000*(hitCount-7))
#	print(percentF)
	return percentF

func guts_scaling(damage: int, currentHP: int) -> int:
	var hp_modify: int = SGFixed.div(SGFixed.from_int(currentHP), SGFixed.from_int(MAX_HP))
	var guts_modify: int = SGFixed.mul(hp_modify, SGFixed.HALF) + SGFixed.HALF # minguts_percent + (hpmod * enough to max to 100%)
	return SGFixed.mul(damage, guts_modify)

func gravity_scaling(gravity: int, comboTime: int) -> int:
	var comboTimeF: int = SGFixed.from_int(comboTime)
	var modifyF: int = SGFixed.div(comboTimeF, SGFixed.ONE * 100)
	return gravity + modifyF

func pushback_scaling(pushback: int, comboTime: int) -> int:
	var comboTimeF: int = SGFixed.from_int(comboTime)
	var modifyF: int = SGFixed.div(comboTimeF, SGFixed.ONE * 9)
	return pushback - modifyF

func sync_rate_quality(endFrame: int, syncRateF: int) -> int:
	var fraction = SGFixed.div(SGFixed.from_int(endFrame), 6553600)
	return endFrame - SGFixed.to_int(SGFixed.mul(fraction, syncRateF))

func assist_guard_cancel_exhausted(state: Dictionary) -> bool:
	return state[Enums.StKey.assist_meter] < Util.ASSIST_STOCK*2

func assist_burst_exhausted(state: Dictionary) -> bool:
	return state[Enums.StKey.assist_meter] < Util.ASSIST_STOCK*1

func save_node_transform_state(node: SGFixedNode2D, state: Dictionary) -> void:
	state[Enums.StKey.fixed_position_x] = node.fixed_position.x
	state[Enums.StKey.fixed_position_y] = node.fixed_position.y
	state[Enums.StKey.fixed_scale_x] = node.fixed_scale.x
	state[Enums.StKey.fixed_scale_y] = node.fixed_scale.y

func save_player_transform_state(node: SGFixedNode2D, state: Dictionary) -> void:
	state[Enums.StKey.fixed_position_x] = node.fixed_position.x
	state[Enums.StKey.fixed_position_y] = node.fixed_position.y
	state[Enums.StKey.fixed_scale_x] = node.fixed_scale.x

func save_hitbox_transform_state(node: SGFixedNode2D, state: Dictionary) -> void:
	state[Enums.StKey.fixed_position_x] = node.fixed_position.x
	state[Enums.StKey.fixed_position_y] = node.fixed_position.y
	state[Enums.StKey.fixed_scale_x] = node.fixed_scale.x
	state[Enums.StKey.fixed_scale_y] = node.fixed_scale.y

func load_node_transform_state(node: SGFixedNode2D, state: Dictionary) -> void:
	node.fixed_position.x = state.get(Enums.StKey.fixed_position_x, 0)
	node.fixed_position.y = state.get(Enums.StKey.fixed_position_y, 0)
	node.fixed_scale.x = state.get(Enums.StKey.fixed_scale_x, SGFixed.ONE)
	node.fixed_scale.y = state.get(Enums.StKey.fixed_scale_y, SGFixed.ONE)

func reset_node_transform_state(node: SGFixedNode2D) -> void:
	node.fixed_position.x = 0
	node.fixed_position.y = 0
	node.fixed_scale.x = SGFixed.ONE
	node.fixed_scale.y = SGFixed.ONE

func interpolate_node_transform_state(node: SGFixedNode2D, old_state: Dictionary, new_state: Dictionary, weight: float) -> void:
	node.position = lerp(
		Vector2(SGFixed.to_float(old_state.get(Enums.StKey.fixed_position_x, 0)), SGFixed.to_float(old_state.get(Enums.StKey.fixed_position_y, 0))),
		Vector2(SGFixed.to_float(new_state.get(Enums.StKey.fixed_position_x, 0)), SGFixed.to_float(new_state.get(Enums.StKey.fixed_position_y, 0))),
		weight)
	
	node.scale = lerp(
		Vector2(SGFixed.to_float(old_state.get(Enums.StKey.fixed_scale_x, SGFixed.ONE)), SGFixed.to_float(old_state.get(Enums.StKey.fixed_scale_y, SGFixed.ONE))),
		Vector2(SGFixed.to_float(new_state.get(Enums.StKey.fixed_scale_x, SGFixed.ONE)), SGFixed.to_float(new_state.get(Enums.StKey.fixed_scale_y, SGFixed.ONE))),
		weight)

func fixed_abs(fixed_num: int) -> int:
	if (fixed_num <= 0):
		fixed_num *= -1
	return fixed_num

func fixed_max(fixed_num1: int, fixed_num2: int) -> int:
	if (fixed_num1 >= fixed_num2):
		return fixed_num1
	else:
		return fixed_num2

func fixed_min(fixed_num1: int, fixed_num2: int) -> int:
	if (fixed_num1 <= fixed_num2):
		return fixed_num1
	else:
		return fixed_num2

func reset_input_map_device(device: int, is_p1: bool) -> void:
	var input_map_actions: Array = ["player1_up", "player1_down", "player1_left", "player1_right", "player1_up_stick", "player1_down_stick", "player1_left_stick", "player1_right_stick", "player1_a", "player1_b", "player1_c", "player1_d", "player1_abc", "player1_abcd", "player1_bc", "player1_ab", "player1_ad", "player1_cancel", "player1_start", "player1_record", "player1_replay"]
	var other_input_map_actions: Array = ["player2_up", "player2_down", "player2_left", "player2_right", "player2_up_stick", "player2_down_stick", "player2_left_stick", "player2_right_stick", "player2_a", "player2_b", "player2_c", "player2_d", "player2_abc", "player2_abcd", "player2_bc", "player2_ab", "player2_ad", "player2_cancel", "player2_start", "player2_record", "player2_replay"]
	
	if (not is_p1):
		var temp = other_input_map_actions
		other_input_map_actions = input_map_actions
		input_map_actions = temp
		if (not Global.p2_is_gamepad):
			device = 1000
	else:
		if (not Global.p1_is_gamepad):
			device = 1000
	
	for i in range(len(input_map_actions)):
		var input_action = input_map_actions[i]
		Input.action_release(input_action)
		InputMap.action_erase_events(input_action)
		var event = InputEventKey.new()
		if (device < 1000):
			event = InputEventJoypadButton.new()
			if (_get_default_joy_stick(is_p1, input_action)[0] != -1):
				event = InputEventJoypadMotion.new()
		if (event is InputEventKey):
			if (Global.p1_is_gamepad and Global.p2_is_gamepad):
				event.physical_keycode = 0
			elif (Global.p1_is_gamepad):
				if (is_p1):
					event.physical_keycode = 0
				else:
					event.physical_keycode = _reset_p1_keyboard(other_input_map_actions[i])
			elif (Global.p2_is_gamepad):
				if (is_p1):
					event.physical_keycode = _reset_p1_keyboard(input_action)
				else:
					event.physical_keycode = 0
			else:
				if (is_p1):
					event.physical_keycode = _reset_p1_keyboard(input_action)
				else:
					event.physical_keycode = _reset_p2_keyboard(input_action)
		elif (event is InputEventJoypadButton):
			if (Global.p1_is_gamepad and Global.p2_is_gamepad):
				event.button_index = _get_default_joy_button(is_p1, input_action)
			elif (Global.p1_is_gamepad):
				if (not is_p1):
					event.button_index = 127
				else:
					event.button_index = _get_default_joy_button(is_p1, input_action)
			elif (Global.p2_is_gamepad):
				if (not is_p1):
					event.button_index = _get_default_joy_button(is_p1, input_action)
				else:
					event.button_index = 127
			else:
				if (is_p1):
					event.button_index = 127
				else:
					event.button_index = 127
			event.device = device
		elif (event is InputEventJoypadMotion):
			var axes = _get_default_joy_stick(is_p1, input_action)
			if (Global.p1_is_gamepad and Global.p2_is_gamepad):
				event.axis = axes[0]
				event.axis_value = axes[1]
			elif (Global.p1_is_gamepad):
				if (not is_p1):
					event.axis = -1
					event.axis_value = 1
				else:
					event.axis = axes[0]
					event.axis_value = axes[1]
			elif (Global.p2_is_gamepad):
				if (not is_p1):
					event.axis = axes[0]
					event.axis_value = axes[1]
				else:
					event.axis = -1
					event.axis_value = 1
			else:
				if (is_p1):
					event.axis = -1
					event.axis_value = 1
				else:
					event.axis = -1
					event.axis_value = 1
			event.device = device
		else:
			print("Unknown InputEvent: " + str(event))
		InputMap.action_add_event(input_action, event)

func _reset_p2_keyboard(key):
	var index = 2
	if (Global.input_maps[index].has(remove_player_prefix(key))):
		return Global.input_maps[index][remove_player_prefix(key)]
	var input_map_actions = {
		"player2_up" : KEY_UP, 
		"player2_down" : KEY_DOWN, 
		"player2_left" : KEY_LEFT, 
		"player2_right" : KEY_RIGHT,
		"player2_a" : KEY_KP_4, 
		"player2_b" : KEY_KP_5, 
		"player2_c" : KEY_KP_6,
		"player2_d" : KEY_KP_0,
		"player2_cancel" : KEY_KP_2, 
		"player2_start" : KEY_TAB, 
		"player2_record" : KEY_R, 
		"player2_replay" : KEY_P
	}
	return input_map_actions.get(key, 0)

func _reset_p1_keyboard(key):
	var index = -1
	if (Global.input_maps[index].has(remove_player_prefix(key))):
		return Global.input_maps[index][remove_player_prefix(key)]
	var input_map_actions = {
		"player1_up" : KEY_W,
		"player1_down" : KEY_S, 
		"player1_left" : KEY_A, 
		"player1_right" : KEY_D, 
		"player1_a" : KEY_J, 
		"player1_b" : KEY_K, 
		"player1_c" : KEY_L,
		"player1_d" : KEY_SPACE,
		"player1_cancel" : KEY_BACKSPACE, 
		"player1_start" : KEY_ESCAPE,
		"player1_record" : KEY_R,
		"player1_replay" : KEY_P
	}
	return input_map_actions.get(key, 0)

func _get_default_joy_button(is_p1, button):
	var index = 2
	if (is_p1):
		index = 1
	if (Global.input_maps[index].has(remove_player_prefix(button))):
		return Global.input_maps[index][remove_player_prefix(button)]

	var input_map_actions = {
		"player1_up" : JOY_BUTTON_DPAD_UP,
		"player1_down" : JOY_BUTTON_DPAD_DOWN, 
		"player1_left" : JOY_BUTTON_DPAD_LEFT, 
		"player1_right" : JOY_BUTTON_DPAD_RIGHT,
		"player1_a" : JOY_BUTTON_X,
		"player1_b" : JOY_BUTTON_Y,
		"player1_c" : JOY_BUTTON_RIGHT_SHOULDER,
		"player1_d" : JOY_BUTTON_A,
		"player1_cancel" : JOY_BUTTON_B, 
		"player1_start" : JOY_BUTTON_START,
		"player2_up" : JOY_BUTTON_DPAD_UP,
		"player2_down" : JOY_BUTTON_DPAD_DOWN, 
		"player2_left" : JOY_BUTTON_DPAD_LEFT, 
		"player2_right" : JOY_BUTTON_DPAD_RIGHT,
		"player2_a" : JOY_BUTTON_X,
		"player2_b" : JOY_BUTTON_Y,
		"player2_c" : JOY_BUTTON_RIGHT_SHOULDER,
		"player2_d" : JOY_BUTTON_A,
		"player2_cancel" : JOY_BUTTON_B, 
		"player2_start" : JOY_BUTTON_START,
	}
	return input_map_actions.get(button, 127)

func _get_default_joy_stick(is_p1, button):
	var index = 2
	if (is_p1):
		index = 1
		
	if (Global.input_maps[index].has(remove_player_prefix(button)) and 
			Global.input_maps[index][remove_player_prefix(button)] > 128):
		return [Global.input_maps[index][remove_player_prefix(button)] - 127, 1];
	
	var input_map_actions = {
		"player1_up_stick" : [JOY_AXIS_LEFT_Y, -1],
		"player1_down_stick" : [JOY_AXIS_LEFT_Y, 1],
		"player1_left_stick" : [JOY_AXIS_LEFT_X, -1],
		"player1_right_stick" : [JOY_AXIS_LEFT_X, 1],
		"player2_up_stick" : [JOY_AXIS_LEFT_Y, -1],
		"player2_down_stick" : [JOY_AXIS_LEFT_Y, 1],
		"player2_left_stick" : [JOY_AXIS_LEFT_X, -1],
		"player2_right_stick" : [JOY_AXIS_LEFT_X, 1],
	}
	return input_map_actions.get(button, [-1, 0])

func set_input_map_ui_controls() -> void:
	InputMap.action_erase_events("ui_accept")
	InputMap.action_erase_events("ui_cancel")
	var input_map_actions : Dictionary = {}
	var assigned = false
	var default_input_map_actions = {
			"ui_accept": ["default_a", "default_b", "default_c", "default_d"],
			"ui_cancel": ["default_cancel"]
		}
	
	var config = open_battle_controller_config_file()
	if (config == null):
		return
	for device_id in Input.get_connected_joypads():
		add_saved_device_input_map_ui_controls(device_id)
		#input_map_actions = default_input_map_actions
		#if (device_id == Global.p1_device_id):
			#var new_input_map_actions = {
				#"ui_accept": ["player1_a", "player1_b", "player1_c", "player1_d"],
				#"ui_cancel": ["player1_cancel"]
			#}
			#assigned = false
			#for ui_control_key in new_input_map_actions:
				#for input_action in new_input_map_actions[ui_control_key]:
					#var action_list: Array = InputMap.action_get_events(input_action)
					#for event in action_list:
						#if (event is InputEventKey):
							#pass
						#elif (event is InputEventJoypadButton or event is InputEventJoypadMotion):
							#assigned = true
			#if (assigned):
				#input_map_actions = new_input_map_actions
		#elif (device_id == Global.p2_device_id):
			#var new_input_map_actions = {
				#"ui_accept": ["player2_a", "player2_b", "player2_c", "player2_d"],
				#"ui_cancel": ["player2_cancel"]
			#}
			#assigned = false
			#for ui_control_key in new_input_map_actions:
				#for input_action in new_input_map_actions[ui_control_key]:
					#var action_list: Array = InputMap.action_get_events(input_action)
					#for event in action_list:
						#if (event is InputEventKey):
							#pass
						#elif (event is InputEventJoypadButton or event is InputEventJoypadMotion):
							#assigned = true
			#if (assigned):
				#input_map_actions = new_input_map_actions
		#
		#assigned = false
		#for ui_control_key in input_map_actions:
			#for input_action in input_map_actions[ui_control_key]:
				#var action_list: Array = InputMap.action_get_events(input_action)
				#for event in action_list:
					#if (event is InputEventKey):
						#pass
					#elif (event is InputEventJoypadButton):
						#var joy_event = InputEventJoypadButton.new()
						#joy_event.device = device_id
						#joy_event.button_index = event.button_index
						#InputMap.action_add_event(ui_control_key, joy_event)
						#assigned = true
					#elif (event is InputEventJoypadMotion):
						#var joy_event = InputEventJoypadMotion.new()
						#joy_event.device = device_id
						#joy_event.axis = event.axis
						#InputMap.action_add_event(ui_control_key, joy_event)
						#assigned = true
					#else:
						#print("Unknown InputEvent: " + str(event))
	input_map_actions = {
			"ui_accept": ["player1_a", "player1_b", "player1_c", "player1_d"],
			"ui_cancel": ["player1_cancel"]
		}
	
	assigned = false
	for ui_control_key in input_map_actions:
		for input_action in input_map_actions[ui_control_key]:
			var action_list: Array = InputMap.action_get_events(input_action)
			for event in action_list:
				if (event is InputEventKey):
					assigned = true
	if (not assigned):
		input_map_actions = default_input_map_actions
	
	for ui_control_key in input_map_actions:
		for input_action in input_map_actions[ui_control_key]:
			var action_list: Array = InputMap.action_get_events(input_action)
			for event in action_list:
				if (event is InputEventKey):
					var key_event = InputEventKey.new()
					key_event.device = event.device
					key_event.physical_keycode = event.physical_keycode
					InputMap.action_add_event(ui_control_key, key_event)
				elif (event is InputEventJoypadButton):
					pass
				elif (event is InputEventJoypadMotion):
					pass
				else:
					print("Unknown InputEvent: " + str(event))
	
	var mouse_event = InputEventMouseButton.new()
	mouse_event.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("ui_accept", mouse_event)
	mouse_event = InputEventMouseButton.new()
	mouse_event.button_index = MOUSE_BUTTON_RIGHT
	InputMap.action_add_event("ui_cancel", mouse_event)
	
	#_burner_input_map_ui_controls()

func _burner_input_map_ui_controls() -> void:
	for device_id in Input.get_connected_joypads():
		if device_id not in [Global.p1_device_id, Global.p2_device_id]:
			add_saved_device_input_map_ui_controls(device_id)

func add_saved_device_input_map_ui_controls(device_id: int, config:ConfigFile=null) -> void:
	if (config == null):
		config = open_battle_controller_config_file()
		if (config == null):
			return
	
	var device_name:String = get_controller_data_name_by_id(device_id)
	var input_map_actions = {}
	if not config.has_section(device_name):
		add_default_input_map_ui_controls(device_id)
		return
	
	input_map_actions = {
		"ui_accept": ["_a", "_b", "_c", "_d"],
		"ui_cancel": ["_cancel"]
	}
	for ui_control_key in input_map_actions:
		for input_action in input_map_actions[ui_control_key]:
			var button = read_saved_control_scheme_button(config, device_name, input_action)
			if (button < -1):
				pass
			elif (button > 128):
				var joy_event = InputEventJoypadMotion.new()
				joy_event.device = device_id
				joy_event.axis = button - 127
				InputMap.action_add_event(ui_control_key, joy_event)
			else:
				var joy_event = InputEventJoypadButton.new()
				joy_event.device = device_id
				joy_event.button_index = button
				InputMap.action_add_event(ui_control_key, joy_event)
			
func add_default_input_map_ui_controls(device_id: int) -> void:
	var input_map_actions = {
		"ui_accept": ["default_a", "default_b", "default_c", "default_d"],
		"ui_cancel": ["default_cancel"]
	}
	for ui_control_key in input_map_actions:
		for input_action in input_map_actions[ui_control_key]:
			var action_list: Array = InputMap.action_get_events(input_action)
			for event in action_list:
				if (event is InputEventKey):
					pass
				elif (event is InputEventJoypadButton):
					var joy_event = InputEventJoypadButton.new()
					joy_event.device = device_id
					joy_event.button_index = event.button_index
					InputMap.action_add_event(ui_control_key, joy_event)
				elif (event is InputEventJoypadMotion):
					var joy_event = InputEventJoypadMotion.new()
					joy_event.device = device_id
					joy_event.axis = event.axis
					InputMap.action_add_event(ui_control_key, joy_event)
				else:
					print("Unknown InputEvent: " + str(event))

func init_global_input_map():
	init_control_scheme(true, true)
	init_control_scheme(true, false)
	init_control_scheme(false, true)
	init_control_scheme(false, false)

func init_control_scheme(is_p1, is_key):
	var input_map_actions = ["player1_up", "player1_left", "player1_down", "player1_right", "player1_a", "player1_b", "player1_c", "player1_d", "player1_ab", "player1_ad", "player1_bc", "player1_abc", "player1_abcd", "player1_cancel", "player1_record", "player1_replay"]
	if (not is_p1):
		input_map_actions = ["player2_up", "player2_left", "player2_down", "player2_right", "player2_a", "player2_b", "player2_c", "player2_d", "player2_ab", "player2_ad", "player2_bc", "player2_abc", "player2_abcd", "player2_cancel", "player2_record", "player2_replay"]

	if (not is_key):
		input_map_actions = ["player1_a", "player1_b", "player1_c", "player1_d", "player1_ab", "player1_ad", "player1_bc", "player1_abc", "player1_abcd", "player1_cancel", "player1_record", "player1_replay"]
		if (not is_p1):
			input_map_actions = ["player2_a", "player2_b", "player2_c", "player2_d", "player2_ab", "player2_ad", "player2_bc", "player2_abc", "player2_abcd", "player2_cancel", "player2_record", "player2_replay"]
	
	var index = 2
	if (is_p1):
		index = 1
	if (is_key):
		index *= -1
	
	Global.input_maps[index] = {}
	for action in input_map_actions:
		var button = 127
		if (is_key):
			button = 0
			for event in InputMap.action_get_events(action):
				if (event is InputEventKey):
					button = event.physical_keycode
		else:
			for event in InputMap.action_get_events(action):
				if (event is InputEventJoypadButton):
					button = event.button_index
				elif (event is InputEventJoypadMotion):
					button = event.axis + 127
		Global.input_maps[index][remove_player_prefix(action)] = button

func save_control_scheme(is_p1, is_key):
	init_control_scheme(is_p1, is_key)
	write_control_scheme(is_p1, is_key)

func print_controls():
	for player_map in Global.input_maps:
		print(str(player_map))
		for input_map_key in Global.input_maps[player_map]:
			print(input_map_key + ": " + str(Global.input_maps[player_map][input_map_key]))

func try_create_new_controller_file():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://controllersettings.cfg")

	# If the file DID load, ignore it.
	if err == OK:
		return

	config = ConfigFile.new()
	print("Title: New controller config file")
	# Store some values.
	# param order:   section          key             value
	# Save it to a file (overwrite if already exists).
	config.save("user://controllersettings.cfg")

func load_battle_controller_config() -> void:
	var config = open_battle_controller_config_file()
	if (config == null):
		return
	_try_loading_control_scheme(config, true, true)
	_try_loading_control_scheme(config, true, false)
	_try_loading_control_scheme(config, false, true)
	_try_loading_control_scheme(config, false, false)

func open_battle_controller_config_file() -> ConfigFile:
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://controllersettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Load: Controller Config File Error: " + str(err))
		return null
	return config

func _try_loading_control_scheme(config:ConfigFile, is_p1:bool, is_key:bool=false):
	var section_name = ""
	var player_index = 0
	if (is_key):
		if (is_p1):
			section_name = "P1Keyboard"
			player_index = -1
		else: 
			section_name = "P2Keyboard"
			player_index = -2
	else:
		section_name = get_controller_data_name(is_p1)
		if (is_p1):
			player_index = 1
		else:
			player_index = 2
	if (config.has_section(section_name)):
		for button_key in config.get_section_keys(section_name):
			if (is_key):
				Global.input_maps[player_index][remove_player_prefix(button_key)] = config.get_value(section_name, button_key, 127)
			else:
				Global.input_maps[player_index][remove_player_prefix(button_key)] = config.get_value(section_name, button_key, 0)
		return true
	else:
		return false

func read_saved_control_scheme_button(config:ConfigFile, controller_name: String, button_key: String):
	var is_key: bool = false
	if (controller_name == "P1Keyboard" || controller_name == "P2Keyboard"):
		is_key = true
	if (config.has_section(controller_name)):
		if (is_key):
			return config.get_value(controller_name, button_key, 127)
		else:
			return config.get_value(controller_name, button_key, 0)
	else:
		return -1

func write_to_config_file(section, key, value):
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	
	# Load data from a file.
	var err = config.load("user://gamesettings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Config File Error: " + str(err))
		return

	# Store some values.
	config.set_value(section, key, value)
	
	# Save it to a file (overwrite if already exists).
	config.save("user://gamesettings.cfg")

func save_default_control_scheme(device_id: int):
	var config = open_battle_controller_config_file()
	if (config == null):
		return
	
	var default_input_map = [
			"default_a", "default_b", "default_c", "default_d", "default_cancel", "default_record", "default_replay"
		]
	var section_name = get_controller_data_name_by_id(device_id)
	if (config.has_section(section_name)):
		return
	print("new controller, setting up default controls")
	for button_key in default_input_map:
		var action_list: Array = InputMap.action_get_events(button_key)
		var button = 127
		for event in action_list:
			if (event is InputEventKey):
				pass
			elif (event is InputEventJoypadButton):
				button = event.button_index
			elif (event is InputEventJoypadMotion):
				button = event.axis + 127
		config.set_value(section_name, remove_player_prefix(button_key), button)
	config.save("user://controllersettings.cfg")

func write_control_scheme(is_p1, is_key=false):
	var config = open_battle_controller_config_file()
	if (config == null):
		return

	var section_name = ""
	var player_index = 0
	if (is_key):
		if (is_p1):
			section_name = "P1Keyboard"
			player_index = -1
		else: 
			section_name = "P2Keyboard"
			player_index = -2
	else:
		section_name = get_controller_data_name(is_p1)
		if (is_p1):
			player_index = 1
		else:
			player_index = 2
	
	if (section_name == ""):
		push_error("controller name could not be recognized")
		return
	
	for button_key in Global.input_maps[player_index]:
		config.set_value(section_name, button_key, Global.input_maps[player_index][remove_player_prefix(button_key)])
	config.save("user://controllersettings.cfg")

func get_controller_data_name(is_p1):
	var device_id = Global.p2_device_id
	if (is_p1):
		device_id = Global.p1_device_id
	return get_controller_data_name_by_id(device_id)

func get_controller_data_name_by_id(device_id: int):
	if (device_id not in Input.get_connected_joypads()):
		return ""
	var joy_data: Dictionary = Input.get_joy_info(device_id)
	if joy_data.has("vendor_id") and joy_data.has("product_id"):
		return str(joy_data["product_id"]) + "_" + str(joy_data["vendor_id"])
	else:
		return "UnrecognizedGamepad"

func update_controllers(device_id: int, connected: bool):
	print(str(device_id) + " " + str(connected))
	if (connected):
		try_replace_controller(device_id)
	else:
		remove_controller(device_id)
	Util.save_default_control_scheme(device_id)
	Util.set_input_map_ui_controls()

func update_controllers_full(device_id: int, connected: bool, name: String, guid: String):
	print(str(device_id) + " " + str(connected) + " " + name + " " + guid)
	update_controllers(device_id, connected)

func try_replace_controller(device_id):
	if (Global.p1_device_id < 0):
		Global.p1_device_id = device_id
		Util.load_battle_controller_config()
		Util.reset_input_map_device(device_id, true)
	elif (Global.p2_device_id < 0):
		Global.p2_device_id = device_id
		Util.load_battle_controller_config()
		Util.reset_input_map_device(device_id, false)
	else:
		print("can't replace controller: " + str(device_id))
		print("current ids: " + str(Global.p1_device_id) + " " + str(Global.p2_device_id))
		var controller_list = "current controllers: "
		for controller in Input.get_connected_joypads():
			controller_list += str(controller) + " "
		print(controller_list)

func remove_controller(device_id):
	if (device_id == Global.p1_device_id):
		Global.p1_device_id = -1000
		#TODO: should we set p1_is_gamepad to false?
	elif (device_id == Global.p2_device_id):
		Global.p2_device_id = -1000
		#TODO: should we set p2_is_gamepad to false?
	else:
		print("controller was not p1 or p2: " + str(device_id))
		print("current ids: " + str(Global.p1_device_id) + " " + str(Global.p2_device_id))
		var controller_list = "current controllers: "
		for controller in Input.get_connected_joypads():
			controller_list += str(controller) + " "
		print(controller_list)

func print_controller_data():
	for id in Input.get_connected_joypads():
		print(Input.get_joy_info(id))

func remove_player_prefix(button_key: String) -> String:
	if (button_key.contains("_")):
		return button_key.substr(button_key.find("_"))
	else:
		return button_key

func is_gamepad_button_event(input_event):
	if (input_event is InputEventJoypadButton):
		return true
	elif (input_event is InputEventJoypadMotion):
		if input_event.axis == JOY_AXIS_TRIGGER_RIGHT or input_event.axis == JOY_AXIS_TRIGGER_LEFT:
			return true
	return false

const USERNAME_PREFIX_LENGTH = 20
func display_username(raw_username:String) -> String:
	if (raw_username.length() <= USERNAME_PREFIX_LENGTH):
		return "?"
	raw_username = raw_username.substr(USERNAME_PREFIX_LENGTH, raw_username.length() - USERNAME_PREFIX_LENGTH)
	return raw_username

func create_username(id:String, displayname:String) -> String:
	if (id.length() > USERNAME_PREFIX_LENGTH):
		id = id.substr(0, USERNAME_PREFIX_LENGTH)
	elif (id.length() < USERNAME_PREFIX_LENGTH):
		for i in range (USERNAME_PREFIX_LENGTH-id.length()):
			id += "*"
	return id+displayname
