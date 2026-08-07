extends PointStateFactory

class_name OgaStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Intro": preload("res://game/state/oga/ogaIntroState.gd"),
		
		"Stand": OgaStandState,
		"Crouch": OgaCrouchState,
		"ForwardWalk": OgaForwardWalk,
		"BackwardWalk": OgaBackWalk,
		"Run": OgaRunState,
		"BackDash": OgaBackdashState,
		"Skid": SubaruSkidState,
		
		"Jump": OgaJumpState,
		"ForwardJump": OgaForwardJumpState,
		"BackwardJump": OgaBackwardJumpState,
		"MidAirJump": OgaMidAirJumpState,
		"ForwardMidAirJump": OgaForwardMidAirJumpState,
		"BackwardMidAirJump": OgaBackwardMidAirJumpState,
		"SuperJump": OgaSuperJumpState,
		"ForwardSuperJump": OgaForwardSuperJumpState,
		"BackwardSuperJump": OgaBackwardSuperJumpState,
		
		"AirTech": preload("res://game/state/oga/ogaAirTech.gd"),
		"ForwardAirTech": preload("res://game/state/oga/ogaForwardAirTech.gd"),
		"BackAirTech": preload("res://game/state/oga/ogaBackwardAirTech.gd"),
		
		"JumpFall": OgaJumpFallState,
		
		"ForwardAirDash": OgaForwardAirDashState,
		"BackwardAirDash": OgaBackwardAirDashState,
		
		"Stand5A": Oga5AState,
		"Stand5B": Oga5BState,
		"Stand5C": Oga5CState,
		"Crouch2A": Oga2AState,
		"Crouch2B": Oga2BState,
		"Crouch2C": Oga2CState,
		"StandcB": OgaCBState,
		"Stand6A": Oga6AState,
		"Stand6C": Oga6CState,
		"Crouch3C": Oga3CState,
		"Jump5A": OgajAState,
		"Jump5B": OgajBState,
		"Jump5C": OgajCState,
		"Jump8C": Ogaj8CState,
		"Jump2C": preload("res://game/state/oga/ogaAirDivekick.gd"), 
		
		"LightRiderKick": preload("res://game/state/oga/ogaGroundRiderKick.gd"),
		"MediumRiderKick": preload("res://game/state/oga/ogaGroundMediumRiderKick.gd"),
		"HeavyRiderKick": preload("res://game/state/oga/ogaGroundHeavyRiderKick.gd"),
		"LightDP": preload("res://game/state/oga/ogaLightDP.gd"),
		"MediumDP": preload("res://game/state/oga/ogaMediumDP.gd"),
		"HeavyDP": preload("res://game/state/oga/ogaHeavyDP.gd"),
		"AirTurnKickLight": preload("res://game/state/oga/ogaAirTurnKickLight.gd"),
		"AirTurnKick": preload("res://game/state/oga/ogaAirTurnKick.gd"),
		"AirTurnKickHeavy": preload("res://game/state/oga/ogaAirTurnKickHeavy.gd"),
		"AirRiderKickLight": preload("res://game/state/oga/ogaAirRiderKickLight.gd"),
		"AirRiderKick": preload("res://game/state/oga/ogaAirRiderKick.gd"),
		"AirRiderKickHeavy": preload("res://game/state/oga/ogaAirRiderKickHeavy.gd"),
		
		"GroundThrowWhiff": OgaGroundThrowWhiffState,
		"GroundBackThrowWhiff": OgaGroundBackThrowWhiffState,
		"AirThrowWhiff": OgaAirThrowWhiffState,
		"AirBackThrowWhiff": OgaAirBackThrowWhiffState,
		"GroundThrowHit": OgaGroundThrowHitState,
		"AirThrowHit": OgaAirThrowHitState,
		"AirBackThrowHit": OgaBackAirThrowHitState,
		
		"GroundAssistCall2": OgaGroundAssistCall2State,
		"GroundAssistCallSuper": OgaGroundAssistCallSuperState,
		"GroundAssistCall": OgaGroundAssistCallState,
		"AirAssistCall": OgaAirAssistCallState,
		"AirAssistCall2": OgaAirAssistCall2State,
		"AirAssistCallSuper": OgaAirAssistCallSuperState,
		
		"StandParryWhiff": OgaStandParryWhiffState,
		"CrouchParryWhiff": OgaCrouchParryWhiffState,
		"AirParryWhiff": OgaAirParryWhiffState,
		"RedStandParryWhiff": OgaRedStandParryWhiffState,
		"RedCrouchParryWhiff": OgaRedCrouchParryWhiffState,
		"RedAirParryWhiff": OgaRedAirParryWhiffState,
		"StandParryCatch": preload("res://game/state/oga/ogaStandParryCatchState.gd"),
		"CrouchParryCatch": preload("res://game/state/oga/ogaCrouchParryCatchState.gd"),
		"AirParryCatch": preload("res://game/state/oga/ogaAirParryCatchState.gd"),

		"Snapback": OgaSnapbackState,
		"SlashMode": OgaSlashModeState,
		
		"HurtLaunch": OgaHurtLaunchState,
		"GroundBounce": preload("res://game/state/oga/ogaHurtGroundBounceState.gd"),
		"WallBounce": preload("res://game/state/oga/ogaHurtWallBounceState.gd"),
		"HurtAir": OgaHurtAirState,
		"HurtStand": OgaHurtGroundState,
		"HurtCrouch": OgaHurtCrouchState,
		
		"StandBlock": OgaStandBlockState,
		"CrouchBlock": OgaCrouchBlockState,
		"AirBlock": OgaAirBlockState,
		"JustStandBlock": preload("res://game/state/oga/ogaStandJustBlockState.gd"),
		"JustCrouchBlock": preload("res://game/state/oga/ogaCrouchJustBlockState.gd"),
		"JustAirBlock": preload("res://game/state/oga/ogaAirJustBlockState.gd"),
		"StandFDStance": preload("res://game/state/oga/ogaStandFDState.gd"),
		"CrouchFDStance": preload("res://game/state/oga/ogaCrouchFDState.gd"),
		"AirFDStance": preload("res://game/state/oga/ogaAirFDState.gd"),
		
		"Wakeup": OgaWakeupState,
		"KO": preload("res://game/state/oga/ogaKO.gd"),
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
	elif (Global.level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M632146, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "SlashMode"
	elif (Global.level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M63214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "Snapback"
	elif (Global.level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "HeavyDP"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "LightDP"
	elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "MediumDP"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "LightRiderKick"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "MediumRiderKick"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "HeavyRiderKick"
	elif (interpreter.is_dashing(true, state[Enums.StKey.leftface])):
		return "Run"
	elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
		return "BackDash"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Stand6C"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "Stand6A"
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
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "AirTurnKickLight"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "AirTurnKick"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "AirTurnKickHeavy"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "AirRiderKickLight"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "AirRiderKick"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		return "AirRiderKickHeavy"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])) 
			and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "AirParryWhiff"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "Jump8C"
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
