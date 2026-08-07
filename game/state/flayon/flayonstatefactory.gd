extends PointStateFactory

class_name FlayonStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Intro": preload("res://game/state/flayon/flayonIntroState.gd"),
		
		"Stand": FlayonStandState,
		"Crouch": FlayonCrouchState,
		"ForwardWalk": FlayonForwardWalk,
		"BackwardWalk": FlayonBackWalk,
		"Run": FlayonRunState,
		"Skid": FlayonSkidState,
		
		"StandBlock": preload("res://game/state/flayon/flayonStandBlockState.gd"),
		"CrouchBlock": preload("res://game/state/flayon/flayonCrouchBlockState.gd"),
		"AirBlock": preload("res://game/state/flayon/flayonAirBlockState.gd"),
		"JustStandBlock": preload("res://game/state/flayon/flayonStandJustBlockState.gd"),
		"JustCrouchBlock": preload("res://game/state/flayon/flayonCrouchJustBlockState.gd"),
		"JustAirBlock": preload("res://game/state/flayon/flayonAirJustBlockState.gd"),
		"StandParryCatch": preload("res://game/state/flayon/flayonStandParryCatchState.gd"),
		"CrouchParryCatch": preload("res://game/state/flayon/flayonCrouchParryCatchState.gd"),
		"AirParryCatch": preload("res://game/state/flayon/flayonAirParryCatchState.gd"),
		
		"Jump": FlayonJumpState,
		"ForwardJump": FlayonForwardJumpState,
		"BackwardJump": FlayonBackwardJumpState,
		"MidAirJump": FlayonMidAirJumpState,
		"ForwardMidAirJump": FlayonForwardMidAirJumpState,
		"BackwardMidAirJump": FlayonBackwardMidAirJumpState,
		"SuperJump": FlayonSuperJumpState,
		"ForwardSuperJump": FlayonForwardSuperJumpState,
		"BackwardSuperJump": FlayonBackwardSuperJumpState,
		
		"JumpFall": FlayonJumpFallState,
		
		"AirTech": preload("res://game/state/flayon/flayonAirTechState.gd"),
		"ForwardAirTech": preload("res://game/state/flayon/flayonForwardAirTechState.gd"),
		"BackAirTech": preload("res://game/state/flayon/flayonBackwardAirTechState.gd"),
		
		"ForwardAirDash": FlayonForwardAirDashState,
		"BackwardAirDash": FlayonBackwardAirDashState,

		"BackDash": FlayonBackDashState,
		
		"Stand5A": Flayon5AState,
		"Stand5B": Flayon5BState,
		"Stand5C": Flayon5CState,
		"Crouch2A": Flayon2AState,
		"Crouch2B": Flayon2BState,
		"Crouch2C": Flayon2CState,
		"StandcB": Flayon5BState,
		"Stand6A": Flayon5AState,
		"Stand6C": Flayon6CState,
		"Crouch3C": Flayon3CState,
		"Jump5A": FlayonjAState,
		"Jump5B": FlayonjBState,
		"Jump5C": FlayonjCState,
		"Jump2C": Flayonj2CState,
		"Jump6C": preload("res://game/state/flayon/flayonJ6CState.gd"),
		
		"GroundAssistCall2": FlayonGroundAssistCall2State,
		"GroundAssistCallSuper": FlayonGroundAssistCallSuperState,
		"GroundAssistCall": FlayonGroundAssistCallState,
		"AirAssistCall": FlayonAirAssistCallState,
		"AirAssistCall2": FlayonAirAssistCall2State,
		"AirAssistCallSuper": FlayonAirAssistCallSuperState,

		"AirGrapple": FlayonAirGrappleState,
		"Grapple": FlayonGrappleState,
		"GrappleFollowup": FlayonGrappleFollowupState,

		"FlightEnter": FlayonFlightEnterState,
		"AirFlightEnter": FlayonAirFlightEnterState,
		"Flight": FlayonFlightState,
		"FlightExit": FlayonFlightExitState,
		"FlightNoFuel": FlayonFlightNoFuelState,
		"FlightForwardAirdash": FlayonFlightForwardAirdashState,
		"FlightBackwardAirdash": FlayonFlightBackwardAirdashState,
		"FlightUpwardAirdash": FlayonFlightUpwardAirdashState,
		"FlightDownwardAirdash": FlayonFlightDownwardAirdashState,

		"Flight5A": FlayonFlightAState,
		"Flight5B": FlayonFlightBState,
		"Flight5C": FlayonFlightCState,
		"Flight2C": FlayonFlight2CState,
		"Flight2CEarly": FlayonFlight2CEarlyState,
		"Flight2CIncrease": FlayonFlight2CIncreaseState,
		"Flight5BEarly": FlayonFlightBEarlyState,
		"Flight5CEarly": FlayonFlightCEarlyState,
		"Flight5BIncrease": FlayonFlightBIncreaseState,
		"Flight5CIncrease": FlayonFlightCIncreaseState,
		"Flight8C": FlayonFlight8CState,

		"RyukenShiki": preload("res://game/state/flayon/flayonLightDPState.gd"),

		"AirStomp": FlayonAirStompState,
		"DeusExMachina": FlayonRTrusState,
		
		"LandingRecovery": preload("res://game/state/flayon/flayonLandingRecovery.gd"),
		
		"Wakeup": FlayonWakeupState,
		"HurtLaunch": FlayonHurtLaunchState,
		"GroundBounce": preload("res://game/state/flayon/flayonGroundBounceState.gd"), 
		"KO":  preload("res://game/state/flayon/flayonKO.gd"),
	}
	
	merge_state_dictionary(new_states)

func common_idle_transitions(state: Dictionary, interpreter: InputInterpreter) -> String:
	if (Global.burst_OK(state, interpreter)):
		return "Burst"
	elif (Global.boost_OK(state, interpreter)):
		return "BoostCancel"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			return "GroundBackThrowWhiff"
		else:
			return "GroundThrowWhiff"
	elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BHold | Enums.InputFlags.CHold)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "CrouchFDStance"
		else:
			return "StandFDStance"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "CrouchParryWhiff"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "StandParryWhiff"
	elif (Global.level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "DeusExMachina"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "RyukenShiki"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "RyukenShiki"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "Grapple"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "FlightEnter"
	elif (interpreter.is_stick_dashing(true, state[Enums.StKey.leftface]) and state[Enums.StKey.stateName] != "Run"):
		return "Run"
	elif (interpreter.is_button_dashing(true, state[Enums.StKey.leftface])):
		return "Run"
	elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
		return "BackDash"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Stand6C"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
			interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Crouch3C"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Crouch2C"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "Crouch2B"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "Crouch2A"
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Stand5C"
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "Stand5B"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "Stand5A"
	elif (Global.assist_ok(state, interpreter)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "GroundAssistCall2"
		elif (Global.level_1_OK(state) and Global.super_assist_meter_ok(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			return "GroundAssistCallSuper"
		else:
			return "GroundAssistCall"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])):
		return "ForwardWalk"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface])):
		return "BackwardWalk"
	elif (interpreter.super_jump()):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
			return "ForwardPreSuperJump"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			return "PreSuperJump"
		else:
			return "BackwardPreSuperJump"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		return "ForwardPreJump"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
		return "PreJump"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		return "BackwardPreJump"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])):
		return "Crouch"
	else:
		return "Stand"


func common_jump_transitions_default(state: Dictionary, interpreter: InputInterpreter) -> String:
	if (Global.burst_OK(state, interpreter)):
		return "Burst"
	elif (Global.boost_OK(state, interpreter)):
		return "AirBoostCancel"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			return "AirBackThrowWhiff"
		else:
			return "AirThrowWhiff"
	elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BHold | Enums.InputFlags.CHold)):
		return "AirFDStance"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])) 
			and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "AirParryWhiff"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Jump2C"
	elif (Global.level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "AirStomp"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "RyukenShiki"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "RyukenShiki"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "AirGrapple"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface]) or 
			interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "AirFlightEnter"
	elif (state[Enums.StKey.airDash] > 0 and interpreter.is_air_dashing(true, state[Enums.StKey.leftface])):
		return "ForwardAirDash"
	elif (state[Enums.StKey.airDash] > 0 and interpreter.is_air_dashing(false, state[Enums.StKey.leftface])):
		return "BackwardAirDash"
	elif (Global.assist_ok(state, interpreter)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "AirAssistCall2"
		elif (Global.level_1_OK(state) and Global.super_assist_meter_ok(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			return "AirAssistCallSuper"
		else:
			return "AirAssistCall"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			return "Jump6C"
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Jump5C"
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "Jump5B"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "Jump5A"
	elif (state[Enums.StKey.doubleJump] > 0 and interpreter.is_tap_jumping() and interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		return "ForwardMidAirPreJump"
	elif (state[Enums.StKey.doubleJump] > 0 and interpreter.is_tap_jumping() and interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
		return "MidAirPreJump"
	elif (state[Enums.StKey.doubleJump] > 0 and interpreter.is_tap_jumping() and interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		return "BackwardMidAirPreJump"
	else:
		return ""
