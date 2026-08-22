extends PointStateFactory

class_name KurokamiStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Intro": preload("res://game/state/kurokami/kurokamiIntroState.gd"),
		
		"Stand": preload("res://game/state/kurokami/kurokamiStandState.gd"),
		"Crouch": preload("res://game/state/kurokami/mainstates/kurokamiCrouchState.gd"),
		"ForwardWalk": preload("res://game/state/kurokami/kurokamiforwardwalk.gd"),
		"BackwardWalk": preload("res://game/state/kurokami/kurokamibackwalk.gd"),
		"Run": preload("res://game/state/kurokami/kurokamiRun.gd"),
		"Skid": preload("res://game/state/kurokami/kurokamiSkid.gd"),
		
		"StandBlock": preload("res://game/state/kurokami/kurokamiStandBlockState.gd"),
		"CrouchBlock": preload("res://game/state/kurokami/kurokamiCrouchBlockState.gd"),
		"AirBlock": preload("res://game/state/kurokami/kurokamiAirBlockState.gd"),
		"JustStandBlock": preload("res://game/state/kurokami/kurokamiStandJustBlockState.gd"),
		"JustCrouchBlock": preload("res://game/state/kurokami/kurokamiCrouchJustBlockState.gd"),
		"JustAirBlock": preload("res://game/state/kurokami/kurokamiAirJustBlockState.gd"),
		"StandParryCatch": preload("res://game/state/kurokami/kurokamiStandParryCatchState.gd"),
		"CrouchParryCatch": preload("res://game/state/kurokami/kurokamiCrouchParryCatchState.gd"),
		"AirParryCatch": preload("res://game/state/kurokami/kurokamiAirParryCatchState.gd"),
		
		"Jump": preload("res://game/state/kurokami/kurokamiJump.gd"),
		"ForwardJump": preload("res://game/state/kurokami/kurokamiForwardJump.gd"),
		"BackwardJump": preload("res://game/state/kurokami/kurokamiBackJump.gd"),
		"SuperJump": preload("res://game/state/kurokami/kurokamiSuperJump.gd"),
		"ForwardSuperJump": preload("res://game/state/kurokami/kurokamiForwardSuperJump.gd"),
		"BackwardSuperJump": preload("res://game/state/kurokami/kurokamiBackwardSuperJump.gd"),
		
		"JumpFall": preload("res://game/state/kurokami/kurokamiJumpFall.gd"),
		
		"AirTech": preload("res://game/state/kurokami/kurokamiAirTechState.gd"),
		"ForwardAirTech": preload("res://game/state/kurokami/kurokamiForwardAirTechState.gd"),
		"BackAirTech": preload("res://game/state/kurokami/kurokamiBackwardAirTechState.gd"),
		
		"ForwardAirDash": preload("res://game/state/kurokami/kurokamiFairDash.gd"),
		"BackwardAirDash": preload("res://game/state/kurokami/kurokamiBairDash.gd"),

		"BackDash": preload("res://game/state/kurokami/kurokamiBackdashState.gd"),
		
		"Stand5A": preload("res://game/state/kurokami/kurokami5AState.gd"),
		"Stand5B": preload("res://game/state/kurokami/kurokami5BState.gd"),
		"Stand5C": preload("res://game/state/kurokami/kurokami5CState.gd"),
		"Crouch2A": preload("res://game/state/kurokami/kurokami2AState.gd"),
		"Crouch2B": preload("res://game/state/kurokami/kurokami2BState.gd"),
		"Crouch2C": preload("res://game/state/kurokami/kurokami2CState.gd"),
		"StandcB": preload("res://game/state/kurokami/kurokami5BState.gd"),
		"Stand6C": preload("res://game/state/kurokami/kurokami6CState.gd"),
		"Crouch3C": preload("res://game/state/kurokami/kurokami3CState.gd"),
		"Jump5A": preload("res://game/state/kurokami/kurokamiJAState.gd"),
		"Jump5B": preload("res://game/state/kurokami/kurokamiJBState.gd"),
		"Jump5C": preload("res://game/state/kurokami/kurokamiJCState.gd"),
		"Jump3A": preload("res://game/state/kurokami/kurokamiJ3AState.gd"),
		"Jump3B": preload("res://game/state/kurokami/kurokamiJ3BState.gd"),
		"Jump3C": preload("res://game/state/kurokami/kurokamiJ3CState.gd"),
		
		"GroundAssistCall2": preload("res://game/state/kurokami/kurokamiGroundAssistCall2.gd"),
		"GroundAssistCallSuper": preload("res://game/state/kurokami/kurokamiGroundAssistCallSuper.gd"),
		"GroundAssistCall": preload("res://game/state/kurokami/kurokamiGroundAssistCall.gd"),
		"AirAssistCall": preload("res://game/state/kurokami/kurokamiAirAssistCall.gd"),
		"AirAssistCall2": preload("res://game/state/kurokami/kurokamiAirAssistCall2.gd"),
		"AirAssistCallSuper": preload("res://game/state/kurokami/kurokamiAirAssistCallSuper.gd"),

		"Tetsuzanko": preload("res://game/state/kurokami/kurokamiTetsuzankoState.gd"),
		"LightTetsuzanko": preload("res://game/state/kurokami/kurokamiLightTetsuzankoState.gd"),
		
		"LandingRecovery": preload("res://game/state/kurokami/kurokamiLandingRecovery.gd"),
		
		"Wakeup": preload("res://game/state/kurokami/kurokamiWakeup.gd"),
		"HurtLaunch": preload("res://game/state/kurokami/kurokamiHurtLaunch.gd"),
		"GroundBounce": preload("res://game/state/kurokami/kurokamiGroundBounceState.gd"), 
		"KO": preload("res://game/state/kurokami/kurokamiKO.gd"),
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
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "Tetsuzanko"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "LightTetsuzanko"
	elif (interpreter.is_stick_dashing(true, state[Enums.StKey.leftface]) and state[Enums.StKey.stateName] != "Run"):
		return "Run"
	elif (interpreter.is_button_dashing(true, state[Enums.StKey.leftface])):
		return "Run"
	elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
		return "BackDash"
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
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and state["_pos_y"] <= Util.MIN_IAD_HEIGHT):
			return "Jump3C"
		else:
			return "Jump5C"
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and state["_pos_y"] <= Util.MIN_IAD_HEIGHT):
			return "Jump3B"
		else:
			return "Jump5B"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and state["_pos_y"] <= Util.MIN_IAD_HEIGHT):
			return "Jump3A"
		else:
			return "Jump5A"
	else:
		return ""
