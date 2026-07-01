extends SuicopathCrouchParryWhiffState

class_name SuicopathCrouchParryCatchState

func _init():
	endFrame = Util.PARRY_HIT_STOP
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			#
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 786432, Enums.StKey.Hurt1PosY : -8454144,
			Enums.StKey.Hurt1ScaleX : 305194, Enums.StKey.Hurt1ScaleY : 951940,
			Enums.StKey.Hurt2PosX : 917504, Enums.StKey.Hurt2PosY : -7208960,
			Enums.StKey.Hurt2ScaleX : 668398, Enums.StKey.Hurt2ScaleY : -793234,
			Enums.StKey.Hurt3PosX : 4390912, Enums.StKey.Hurt3PosY : -13172735,
			Enums.StKey.Hurt3ScaleX : 302121, Enums.StKey.Hurt3ScaleY : -600552,
			Enums.StKey.counterOK : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.hitStopFrame] = 0
	state[Enums.StKey.hitstun] = 0
	state[Enums.StKey.drag_x] = Util.FD_FRICTION
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.velocity_x] = SGFixed.ONE*20
	anim.play("AngelCrouchParryCatch")

func physics_tick(state: Dictionary) -> void:
	# NOTE: hitStopFrame == 0 is the "I was in hitstop, and can delay cancel"
	if (state[Enums.StKey.frame] == Util.PARRY_HIT_STOP-1):
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
		common_idle_transitions(state, interpreter)
	
	gatling_cancel(state, interpreter)
	special_cancel(state, interpreter)
	jump_cancel(state, interpreter)
	meter_cancel(state, interpreter)
	
	# special throw section
	if (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			state[Enums.StKey.cancelState] = "AngelGroundBackThrowWhiff"
		else:
			state[Enums.StKey.cancelState] = "AngelGroundThrowWhiff"
	
	if (state[Enums.StKey.frame] > Util.PARRY_SKIP_CANCEL_FRAME):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
			state[Enums.StKey.velocity_x] = 0
			change_state.call("AngelCrouchParryWhiff")
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
			state[Enums.StKey.velocity_x] = 0
			change_state.call("AngelStandParryWhiff")


func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.GroundThrowOK:
			return false
		Enums.StateProperty.BlockingOK:
			return true
		_:
			return super.has_property(state,property)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.ParryHurt):
		anim.stop(true)
		anim.play("AngelCrouchParryCatch")
		state[Enums.StKey.hitStopFrame] = Util.PARRY_HIT_STOP - 1
		state[Enums.StKey.velocity_y] = 0
		state[Enums.StKey.velocity_x] = 0
	else:
		super.reaction(state, interpreter, event_cause)
