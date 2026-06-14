extends KurokamiFlightBaseState

class_name KurokamiFlightState

const SPEED = SGFixed.ONE*15
const UP_SPEED = SGFixed.ONE*6

func _init():
	endFrame = 180
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Flight")
	state[Enums.StKey.leftfaceOK] = true
	state[Enums.StKey.hitStopFrame] = 0
	
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 8):
		state[Enums.StKey.frame] = 2
	state[Enums.StKey.super_meter] -= Util.FLIGHT_METER_DRAIN

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)
	if (
			(interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.velocity_x] = -SPEED 
	elif ( 
			(interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.velocity_x] = SPEED
	else:
		state[Enums.StKey.accel_x] = 0
		state[Enums.StKey.velocity_x] = 0
	
	if (
			(interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.velocity_y] = -UP_SPEED
	elif (
			(interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.velocity_y] = SPEED
	else:
		state[Enums.StKey.accel_y] = 0
		state[Enums.StKey.velocity_y] = 0
	
	if (not interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) or
			(
				interpreter.is_button_down(Enums.InputFlags.ADown) or
				interpreter.is_button_down(Enums.InputFlags.BDown) or
				interpreter.is_button_down(Enums.InputFlags.CDown) or
				interpreter.is_button_down(Enums.InputFlags.DDown)
			)
		):
		common_flight_transitions(state, interpreter)


	if (state[Enums.StKey.super_meter] <= 0):
		change_state.call("FlightNoFuel")

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func common_flight_transitions(state: Dictionary, interpreter: InputInterpreter):
	if (boost_OK(state, interpreter)):
		change_state.call("AirBoostCancel")
	elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "AirBoostCancel"):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			change_state.call("AirAssistCall2")
		elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			change_state.call("AirAssistCallSuper")
		else:
			change_state.call("AirAssistCall")
	if (level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		change_state.call("AirStomp")
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		change_state.call("RyukenShiki")
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		change_state.call("RyukenShiki")
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		change_state.call("AirGrapple")
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		change_state.call("FlightExit")
	elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N6, state[Enums.StKey.leftface])):
		change_state.call("FlightForwardAirdash")
	elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N4, state[Enums.StKey.leftface])):
		change_state.call("FlightBackwardAirdash")
	elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N2, state[Enums.StKey.leftface])):
		change_state.call("FlightDownwardAirdash")
	elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N8, state[Enums.StKey.leftface])):
		change_state.call("FlightUpwardAirdash")
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		change_state.call("Flight5C")
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		change_state.call("Flight5B")
	elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		change_state.call("Flight5A")

