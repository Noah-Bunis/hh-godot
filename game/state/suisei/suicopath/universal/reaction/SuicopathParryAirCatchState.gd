extends SuicopathAirParryWhiffState

class_name SuicopathAirParryCatchState

func _init():
	endFrame = Util.PARRY_HIT_STOP
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2031616, Enums.StKey.Hurt1PosY : -18153472,
			Enums.StKey.Hurt1ScaleX : 1142691, Enums.StKey.Hurt1ScaleY : 1549402,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			Enums.StKey.counterOK : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("AngelAirParryCatch")
	state[Enums.StKey.hitStopFrame] = 0
	state[Enums.StKey.drag_x] = Util.FD_FRICTION
	state[Enums.StKey.doubleJump] = 1
	state[Enums.StKey.airDash] = 1
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.velocity_x] = SGFixed.ONE*20

func physics_tick(state: Dictionary) -> void:
	# NOTE: hitStopFrame == 0 is the "I was in hitstop, and can delay cancel"
	if (state[Enums.StKey.frame] == Util.PARRY_HIT_STOP - 1):
		# last frame and transition out of hitstop
		if (not state[Enums.StKey.cancelState].is_empty()):
			state[Enums.StKey.velocity_x] = 0
			change_state.call(state[Enums.StKey.cancelState])
	elif (state[Enums.StKey.frame] <= Util.PARRY_SKIP_CANCEL_FRAME):
		# the real cancel from parry starts on frame 10
		state[Enums.StKey.cancelState] = ""

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		state[Enums.StKey.velocity_x] = 0
		common_jump_transitions(state, interpreter)
	
	special_cancel(state, interpreter)
	gatling_cancel(state, interpreter)
	jump_cancel(state, interpreter)
	meter_cancel(state, interpreter)
	
	# special throw section
	if (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			state[Enums.StKey.cancelState] = "AngelAirBackThrowWhiff"
		else:
			state[Enums.StKey.cancelState] = "AngelAirThrowWhiff"
	
	if (state[Enums.StKey.frame] > Util.PARRY_SKIP_CANCEL_FRAME):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])) 
				and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
			state[Enums.StKey.velocity_x] = 0
			change_state.call("AngelAirParryWhiff")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.ParryHurt):
		anim.stop(true)
		anim.play("AngelAirParryCatch")
		state[Enums.StKey.hitStopFrame] = Util.PARRY_HIT_STOP - 1
		state[Enums.StKey.velocity_y] = 0
		state[Enums.StKey.velocity_x] = 0
	else:
		super.reaction(state, interpreter, event_cause)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.AirThrowOK:
			return false
		Enums.StateProperty.BlockingOK:
			return true
		_:
			return super.has_property(state,property)
