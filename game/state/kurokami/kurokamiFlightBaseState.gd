extends KurokamiAirAttackState

class_name KurokamiFlightBaseState

func _init():
	endFrame = 180

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Flight")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.kara_OK] = true
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.velocity_x] = 0

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		if (boost_OK(state, interpreter)):
			change_state.call("AirBoostCancel")
		elif (interpreter.button_dash_four_way(Enums.Numpad.N6, state[Enums.StKey.leftface])):
			change_state.call("FlightForwardAirdash")
		elif (interpreter.button_dash_four_way(Enums.Numpad.N4, state[Enums.StKey.leftface])):
			change_state.call("FlightBackwardAirdash")
		elif (interpreter.button_dash_four_way(Enums.Numpad.N2, state[Enums.StKey.leftface])):
			change_state.call("FlightDownwardAirdash")
		elif (interpreter.button_dash_four_way(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			change_state.call("FlightUpwardAirdash")
		if (burst_OK(state, interpreter)):
			change_state.call("Burst")

	if (state[Enums.StKey.hitStopFrame] == 0 and not state[Enums.StKey.cancelState].is_empty()):
		# is out of hitstop, and cancellable
		# delay cancel state
		anim.stop(true)
		change_state.call(state[Enums.StKey.cancelState])

	gatling_cancel(state, interpreter)
	special_cancel(state, interpreter)
	jump_cancel(state, interpreter)
	meter_cancel(state, interpreter)

	if (state[Enums.StKey.frame] >= endFrame):
		change_state.call("Flight")
	if (state[Enums.StKey.super_meter] <= 0):
		change_state.call("FlightNoFuel")


func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Flight5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Flight5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Flight5A"

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	super.special_cancel(state,interpreter)
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
				interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface]) or 
				interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "FlightExit"
		elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N6, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "FlightForwardAirdash"
		elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N4, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "FlightBackwardAirdash"
		elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N2, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "FlightDownwardAirdash"
		elif (interpreter.is_air_dashing_four_way(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "FlightUpwardAirdash"


func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AirBoostCancel"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "AirBoostCancel"):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AirAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AirAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "AirAssistCall"
	else:
		if (boost_OK(state, interpreter)):
			change_state.call("AirBoostCancel")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		pass
	else:
		super.reaction(state, interpreter, event_cause)

