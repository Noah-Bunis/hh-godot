extends PointStateFactory

class_name MioStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Intro": preload("res://game/state/mio/mioIntroState.gd"),
		
		"Stand": MioStandState,
		"Crouch": MioCrouchState,
		"ForwardWalk": MioForwardWalkState,
		"BackwardWalk": MioBackwardWalkState,
		"Run": MioRunState,
		"Skid": MioSkidState,
		
		"Jump": MioJumpState,
		"ForwardJump": MioForwardJumpState,
		"BackwardJump": MioBackwardJumpState,
		"SuperJump": MioSuperJumpState,
		"ForwardSuperJump": MioForwardSuperJumpState,
		"BackwardSuperJump": MioBackwardSuperJumpState,
		"MidAirJump": MioMidAirJumpState,
		"ForwardMidAirJump": MioForwardMidAirJumpState,
		"BackwardMidAirJump": MioBackwardMidAirJumpState,
		
		"JumpFall": MioJumpFallState,
		
		"BackDash": MioBackDashState,
		"ForwardAirDash": MioForwardAirDashState,
		"BackwardAirDash": MioBackwardAirDashState,
		
		"AirTech": preload("res://game/state/mio/mioAirTechState.gd"),
		"ForwardAirTech": preload("res://game/state/mio/mioForwardAirTechState.gd"),
		"BackAirTech": preload("res://game/state/mio/mioBackwardAirTechState.gd"),
		
		"StandBlock": preload("res://game/state/mio/mioStandBlockState.gd"),
		"CrouchBlock": preload("res://game/state/mio/mioCrouchBlockState.gd"),
		"AirBlock": preload("res://game/state/mio/mioAirBlockState.gd"),
		"JustStandBlock": preload("res://game/state/mio/mioStandJustBlockState.gd"),
		"JustCrouchBlock": preload("res://game/state/mio/mioCrouchJustBlockState.gd"),
		"JustAirBlock": preload("res://game/state/mio/mioAirJustBlockState.gd"),
		"StandFDStance": StandFDStanceState,
		"CrouchFDStance": CrouchFDStanceState,
		"AirFDStance": AirFDStanceState,
		"StandParryWhiff": StandParryWhiffState,
		"CrouchParryWhiff": CrouchParryWhiffState,
		"AirParryWhiff": AirParryWhiffState,
		"RedStandParryWhiff": RedStandParryWhiffState,
		"RedCrouchParryWhiff": RedCrouchParryWhiffState,
		"RedAirParryWhiff": RedAirParryWhiffState,
		"StandParryCatch": preload("res://game/state/mio/mioStandParryCatchState.gd"),
		"CrouchParryCatch": preload("res://game/state/mio/mioCrouchParryCatchState.gd"),
		"AirParryCatch": preload("res://game/state/mio/mioAirParryCatchState.gd"),
		
		"GroundAssistCall2": MioGroundAssistCall2State,
		"GroundAssistCallSuper": MioGroundAssistCallSuperState,
		"GroundAssistCall": MioGroundAssistCallState,
		"AirAssistCall": MioAirAssistCallState,
		"AirAssistCall2": MioAirAssistCall2State,
		"AirAssistCallSuper": MioAirAssistCallSuperState,

		"GroundThrowHit": preload("res://game/state/mio/mioGroundThrowHit.gd"),
		"AirThrowHit": MioAirThrowHitState,
		"AirBackThrowHit": MioAirBackThrowHitState,
		
		"Stand5A": Mio5AState,
		"Stand5B": Mio5BState,
		"Stand5C": Mio5CState,
		"Crouch2A": Mio2AState,
		"Crouch2B": Mio2BState,
		"Crouch2C": Mio2CState,
		"StandcB": MiocBState,
		"Stand6A": Mio6AState,
		"Stand6C": Mio6CState,
		"Crouch3C": Mio3CState,
		"Jump5A": MiojAState,
		"Jump5B": MiojBState,
		"Jump5C": MiojCState,
		"Jump2C": Mioj2CState,
		"Super1": MioSuperTarotState,
		
		"ChargeStart": MioChargeStartState,
		"Charge": MioChargeState,
		"Summon": MioSummonState,
		"Unsummon": MioUnsummonState,
		"MioAirCards": preload("res://game/state/mio/mioaircards.gd"),
		
		"LandingRecovery": preload("res://game/state/mio/mioLandingRecovery.gd"),
		
		"HurtLaunch": preload("res://game/state/mio/mioHurtLaunchState.gd"),
		"KO": preload("res://game/state/mio/mioKO.gd"),
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
	elif (Global.level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M41236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "Super1"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "MioAirCards"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "MioAirCards"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "MioAirCards"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "ChargeStart"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "ChargeStart"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "ChargeStart"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "Unsummon"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "Unsummon"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "Unsummon"
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
	elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
			interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "StandcB"
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "Stand5B"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "Stand6A"
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
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "MioAirCards"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "MioAirCards"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "MioAirCards"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Jump2C"
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
