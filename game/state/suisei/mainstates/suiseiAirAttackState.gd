extends AirAttackState

class_name SuiseiAirAttackState

const WhiffSound = preload("res://game/assets/sfx/Whiff.wav")

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			#
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			},
	}

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("whiff", WhiffSound, {"bus": "Sound"})

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		common_jump_transitions(state, interpreter)
	if (state[Enums.StKey.frame] == 0):
		if (state[Enums.StKey.kara_OK]):
			# Kara Cancel section
			state[Enums.StKey.kara_OK] = false
			if (boost_OK(state, interpreter)):
				change_state.call("AirBoostCancel")
			elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
				if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
						interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
						interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
					change_state.call("AirBackThrowWhiff")
				else:
					change_state.call("AirThrowWhiff")
			elif ((interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
					interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) or 
					interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])) 
					and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
				change_state.call("AirParryWhiff")
			elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
				change_state.call("AirFDStance")
			elif (state[Enums.StKey.airDash] > -1 and interpreter.is_button_dashing(true, state[Enums.StKey.leftface])):
				change_state.call("ForwardAirDash")
			elif (state[Enums.StKey.airDash] > -1 and interpreter.is_button_dashing(false, state[Enums.StKey.leftface])):
				change_state.call("BackwardAirDash")
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

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.doubleJump] > 0 and state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_tapping_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "ForwardMidAirPreJump"
		elif (interpreter.is_tapping_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "MidAirPreJump"
		elif (interpreter.is_tapping_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "BackwardMidAirPreJump"

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "YoruMatsuyo"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "LightYoruMatsuyo"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirCaramelThrust"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirCaramelThrust"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AirSuiseiToSuicopath"

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])
				and interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Jump6B"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Jump5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Jump5A"
