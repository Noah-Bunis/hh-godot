extends PointStateFactory

class_name SuiseiStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Intro": SuiseiIntroState,
		
		"Stand": preload("res://game/state/suisei/suiseiStandState.gd"),
		"Crouch": preload("res://game/state/suisei/mainstates/suiseiCrouchState.gd"),
		"ForwardWalk": preload("res://game/state/suisei/suiseiforwardwalk.gd"),
		"BackwardWalk": preload("res://game/state/suisei/suiseibackwalk.gd"),
		"Run": preload("res://game/state/suisei/suiseiRun.gd"),
		"Skid": preload("res://game/state/suisei/suiseiSkid.gd"),
		
		"Jump": preload("res://game/state/suisei/suiseiJump.gd"),
		"ForwardJump": preload("res://game/state/suisei/suiseiForwardJump.gd"),
		"BackwardJump": preload("res://game/state/suisei/suiseiBackJump.gd"),
		"MidAirJump": preload("res://game/state/suisei/suiseiMidAirJump.gd"),
		"ForwardMidAirJump": preload("res://game/state/suisei/suiseiMidAirForwardJump.gd"),
		"BackwardMidAirJump": preload("res://game/state/suisei/suiseiMidAirBackJump.gd"),
		"SuperJump": preload("res://game/state/suisei/suiseiSuperJump.gd"),
		"ForwardSuperJump": preload("res://game/state/suisei/suiseiForwardSuperJump.gd"),
		"BackwardSuperJump": preload("res://game/state/suisei/suiseiBackwardSuperJump.gd"),
		
		"AirTech": preload("res://game/state/suisei/suiseiAirTechState.gd"),
		"ForwardAirTech": preload("res://game/state/suisei/suiseiForwardAirTechState.gd"),
		"BackAirTech": preload("res://game/state/suisei/suiseiBackwardAirTechState.gd"),
		
		"JumpFall": preload("res://game/state/suisei/suiseiJumpFall.gd"),
		
		"ForwardAirDash": preload("res://game/state/suisei/suiseiFairDash.gd"),
		"BackwardAirDash": preload("res://game/state/suisei/suiseiBairDash.gd"),
		
		"Stand5A": preload("res://game/state/suisei/suisei5AState.gd"),
		"Stand5B": preload("res://game/state/suisei/suisei5BState.gd"),
		"Crouch2A": preload("res://game/state/suisei/suisei2AState.gd"),
		"Crouch2B": preload("res://game/state/suisei/suisei2BState.gd"),
		"StandcB": preload("res://game/state/suisei/suiseiCBState.gd"),
		"Stand6A": preload("res://game/state/suisei/suisei6AState.gd"),
		"Jump5A": preload("res://game/state/suisei/suiseiJAState.gd"),
		"Jump5B": preload("res://game/state/suisei/suiseiJBState.gd"),
		"Jump6B": preload("res://game/state/suisei/suiseiJ6BState.gd"),
		
#		"GroundThrowWhiff": GroundThrowWhiffState,
#		"AirThrowWhiff": AirThrowWhiffState,
		"GroundThrowHit": preload("res://game/state/suisei/suiseiGroundThrowHit.gd"),
		"AirThrowHit": preload("res://game/state/suisei/suiseiAirThrowHit.gd"),
#		"GroundBackThrowWhiff": GroundBackThrowWhiffState,
#		"AirBackThrowWhiff": AirBackThrowWhiffState,
		"GroundBackThrowHit": preload("res://game/state/suisei/suiseiGroundBackThrowHit.gd"),
		"AirBackThrowHit": preload("res://game/state/suisei/suiseiBackAirThrowHit.gd"),
		
		"StandParryCatch": preload("res://game/state/suisei/suiseiStandParryCatchState.gd"),
		"CrouchParryCatch": preload("res://game/state/suisei/suiseiCrouchParryCatchState.gd"),
		"AirParryCatch": preload("res://game/state/suisei/suiseiAirParryCatchState.gd"),
	
		"GroundAssistCall2": preload("res://game/state/suisei/suiseiGroundAssistCall2.gd"),
		"GroundAssistCallSuper": preload("res://game/state/suisei/suiseiGroundAssistCallSuper.gd"),
		"GroundAssistCall": preload("res://game/state/suisei/suiseiGroundAssistCall.gd"),
		"AirAssistCall": preload("res://game/state/suisei/suiseiAirAssistCall.gd"),
		"AirAssistCall2": preload("res://game/state/suisei/suiseiAirAssistCall2.gd"),
		"AirAssistCallSuper": preload("res://game/state/suisei/suiseiAirAssistCallSuper.gd"),

		"YoruMatsuyo": preload("res://game/state/suisei/suiseiYoruMatsuyo.gd"),
		"GatoKick": preload("res://game/state/suisei/suiseiGatoKickState.gd"),
		"GatoDive": preload("res://game/state/suisei/suiseiGatoDiveState.gd"),
		"Pendulum": preload("res://game/state/suisei/suiseiPendulumState.gd"),
		"LightYoruMatsuyo": preload("res://game/state/suisei/suiseiLightYoruMatsuyo.gd"),
		"CaramelThrust": preload("res://game/state/suisei/suiseiCaramelThrust.gd"),
		"AirCaramelThrust": preload("res://game/state/suisei/suiseiAirCaramelThrust.gd"),
		
		"LandingRecovery": preload("res://game/state/subaru/subaruLandingRecovery.gd"),
		
		"Wakeup": preload("res://game/state/suisei/suiseiWakeup.gd"),
		"HurtLaunch": preload("res://game/state/suisei/suiseiHurtLaunch.gd"),
		"GroundBounce": preload("res://game/state/suisei/suiseiGroundBounceState.gd"), 
		"KO": SuiseiKOState,
		
		"AngelStand": preload("res://game/state/suisei/suicopath/SuicopathStandState.gd"),
		"AngelCrouch": preload("res://game/state/suisei/suicopath/mainstates/SuicopathCrouchState.gd"),
		"AngelForwardWalk": preload("res://game/state/suisei/suicopath/Suicopathforwardwalk.gd"),
		"AngelBackwardWalk": preload("res://game/state/suisei/suicopath/Suicopathbackwalk.gd"),
		
		"AngelJumpFall": preload("res://game/state/suisei/suicopath/SuicopathJumpFall.gd"),
		
		"AngelStand5A": preload("res://game/state/suisei/suicopath/Suicopath5AState.gd"),
		"AngelStand5B": preload("res://game/state/suisei/suicopath/Suicopath5BState.gd"),
		"AngelCrouch2A": preload("res://game/state/suisei/suicopath/Suicopath2AState.gd"),
		"AngelCrouch2B": preload("res://game/state/suisei/suicopath/Suicopath2BState.gd"),
		"AngelStandcB": preload("res://game/state/suisei/suicopath/SuicopathCBState.gd"),
		"AngelStand6A": preload("res://game/state/suisei/suicopath/Suicopath6AState.gd"),
		"AngelJump5A": preload("res://game/state/suisei/suicopath/SuicopathJAState.gd"),
		"AngelJump5B": preload("res://game/state/suisei/suicopath/SuicopathJBState.gd"),
		"AngelJump2B": preload("res://game/state/suisei/suicopath/SuicopathJ2BState.gd"),
		"AngelJump2B2": preload("res://game/state/suisei/suicopath/SuicopathJ2B2State.gd"),
		
		"AngelGroundAssistCall2": preload("res://game/state/suisei/suicopath/SuicopathGroundAssistCall2.gd"),
		"AngelGroundAssistCallSuper": preload("res://game/state/suisei/suicopath/SuicopathGroundAssistCallSuper.gd"),
		"AngelGroundAssistCall": preload("res://game/state/suisei/suicopath/SuicopathGroundAssistCall.gd"),
		"AngelAirAssistCall": preload("res://game/state/suisei/suicopath/SuicopathAirAssistCall.gd"),
		"AngelAirAssistCall2": preload("res://game/state/suisei/suicopath/SuicopathAirAssistCall2.gd"),
		"AngelAirAssistCallSuper": preload("res://game/state/suisei/suicopath/SuicopathAirAssistCallSuper.gd"),
		
		"AngelWakeup": preload("res://game/state/suisei/suicopath/SuicopathWakeup.gd"),
		"AngelHurtLaunch": preload("res://game/state/suisei/suicopath/universal/reaction/Suicopathhurtlaunchstate.gd"),

		"AngelBackDash": preload("res://game/state/suisei/suicopath/universal/SuicopathbackdashState.gd"),
		
		"AngelGroundThrowWhiff": preload("res://game/state/suisei/suicopath/universal/SuicopaththrowWhiff.gd"),
		"AngelAirThrowWhiff": preload("res://game/state/suisei/suicopath/universal/SuicopathAirthrowWhiff.gd"),
		"AngelGroundThrowHit": preload("res://game/state/suisei/suicopath/universal/SuicopathGroundThrowHit.gd"),
		"AngelAirThrowHit": preload("res://game/state/suisei/suicopath/universal/SuicopathAirthrowHit.gd"),
		"AngelGroundBackThrowWhiff": preload("res://game/state/suisei/suicopath/universal/SuicopathBackThrowWhiff.gd"),
		"AngelAirBackThrowWhiff": preload("res://game/state/suisei/suicopath/universal/SuicopathAirBackthrowWhiff.gd"),
		"AngelGroundBackThrowHit": preload("res://game/state/suisei/suicopath/universal/SuicopathGroundBackThrowHit.gd"),
		"AngelAirBackThrowHit": preload("res://game/state/suisei/suicopath/universal/SuicopathAirBackthrowHit.gd"),
		
		"AngelKnockdown": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathKnockdownState.gd"),
		"AngelHurtOTG": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathHurtOTGState.gd"),
		"AngelHurtCrouch": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathHurtCrouchState.gd"),
		"AngelStandBlock": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathStandBlock.gd"),
		"AngelCrouchBlock": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathCrouchBlockState.gd"),
		"AngelAirBlock": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathAirBlock.gd"),
		"AngelJustStandBlock": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathStandJustBlock.gd"),
		"AngelJustCrouchBlock": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathCrouchJustBlockState.gd"),
		"AngelJustAirBlock": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathAirJustBlock.gd"),
		"AngelStandFDStance": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathStandFDStanceState.gd"),
		"AngelCrouchFDStance": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathCrouchFDStanceState.gd"),
		"AngelAirFDStance": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathAirFDStanceState.gd"),
		"AngelStandParryWhiff": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathParryStandWhiffState.gd"),
		"AngelCrouchParryWhiff": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathParryCrouchWhiffState.gd"),
		"AngelAirParryWhiff": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathParryAirWhiffState.gd"),
		
		"AngelRedStandParryWhiff": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathRedParryStandWhiffState.gd"),
		"AngelRedCrouchParryWhiff": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathRedParryCrouchWhiffState.gd"),
		"AngelRedAirParryWhiff": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathRedParryAirWhiffState.gd"),
		"AngelStandParryCatch": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathParryStandCatchState.gd"),
		"AngelCrouchParryCatch": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathParryCrouchCatchState.gd"),
		"AngelAirParryCatch": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathParryAirCatchState.gd"),
		
		"AngelAirTech": preload("res://game/state/suisei/suicopath/SuicopathJumpFall.gd"),
		"AngelForwardAirTech": preload("res://game/state/suisei/suicopath/SuicopathJumpFall.gd"),
		"AngelBackAirTech": preload("res://game/state/suisei/suicopath/SuicopathJumpFall.gd"),
		
		"AngelBurst": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathBurst.gd"),
		"AngelAssistGuardCancel": preload("res://game/state/suisei/suicopath/universal/SuicopathAssistGuardCancel.gd"),
		"AngelAirAssistGuardCancel": preload("res://game/state/suisei/suicopath/universal/SuicopathAirAssistGuardCancel.gd"),
		"AngelAssistWeakGuardCancel": preload("res://game/state/suisei/suicopath/universal/SuicopathAssistWeakGuardCancel.gd"),
		"AngelAirAssistWeakGuardCancel": preload("res://game/state/suisei/suicopath/universal/SuicopathAirAssistWeakGuardCancel.gd"),
		"AngelBoostCancel": preload("res://game/state/suisei/suicopath/universal/SuicopathBoostCancelState.gd"),
		"AngelAirBoostCancel": preload("res://game/state/suisei/suicopath/universal/SuicopathAirBoostCancelState.gd"),
		
		"AngelHurtStand": preload("res://game/state/suisei/suicopath/universal/reaction/Suicopathhurtgroundstate.gd"),
		"AngelHurtAir": preload("res://game/state/suisei/suicopath/universal/reaction/Suicopathhurtairstate.gd"),
		"AngelHurtThrow": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathThrowHurt.gd"),
		"AngelHurtAirThrow": preload("res://game/state/suisei/suicopath/universal/reaction/SuicopathAirThrowHurt.gd"),
		"AngelGroundBounce": preload("res://game/state/suisei/suicopath/universal/reaction/Suicopathhurtgroundbouncestate.gd"),
		"AngelWallBounce": preload("res://game/state/suisei/suicopath/universal/reaction/Suicopathhurtwallbouncestate.gd"),
		"AngelKO": SuicopathKOState,
		
		"Scissors": preload("res://game/state/suisei/suicopath/SuicopathScissors.gd"),
		"Chainsaws": preload("res://game/state/suisei/suicopath/SuicopathChainHurricane.gd"),
		
		"AngelInstall" : preload("res://game/state/suisei/suiseiToSuicopathState.gd"),
		"AirSuiseiToSuicopath" : preload("res://game/state/suisei/suiseiToSuicopathAirState.gd"),
		"Stand5C": preload("res://game/state/suisei/suiseiToSuicopathState.gd"),
		"Jump5C": preload("res://game/state/suisei/suiseiToSuicopathAirState.gd"),
		
		"AngelUninstall": preload("res://game/state/suisei/suicopath/SuicopathToSuiseiState.gd"),
		"AirSuicopathToSuisei" : preload("res://game/state/suisei/suicopath/SuicopathToSuiseiAirState.gd"),
	}
	
	merge_state_dictionary(new_states)

func angel_common_idle_transitions(state: Dictionary, interpreter: InputInterpreter) -> String:
	if (Global.burst_OK(state, interpreter)):
		return "AngelBurst"
	elif (Global.boost_OK(state, interpreter)):
		return "AngelBoostCancel"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			return "AngelGroundBackThrowWhiff"
		else:
			return "AngelGroundThrowWhiff"
	elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BHold | Enums.InputFlags.CHold)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "AngelCrouchFDStance"
		else:
			return "AngelStandFDStance"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "AngelCrouchParryWhiff"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "AngelStandParryWhiff"
	elif (Global.level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M632146, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "Chainsaws"
	elif (Global.level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M63214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "Scissors"
	elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
		return "AngelBackDash"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "AngelStand6A"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "AngelCrouch2B"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "AngelCrouch2A"
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "AngelUninstall"
	elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
			interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "AngelStandcB"
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "AngelStand5B"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "AngelStand5A"
	elif (Global.assist_ok(state, interpreter)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "AngelGroundAssistCall2"
		elif (Global.level_1_OK(state) and Global.super_assist_meter_ok(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			return "AngelGroundAssistCallSuper"
		else:
			return "AngelGroundAssistCall"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])):
		return "AngelForwardWalk"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface])):
		return "AngelBackwardWalk"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])):
		return "AngelCrouch"
	else:
		return "AngelStand"

func angel_common_jump_transitions_default(state: Dictionary, interpreter: InputInterpreter) -> String:
	if (Global.burst_OK(state, interpreter)):
		return "AngelBurst"
	elif (Global.boost_OK(state, interpreter)):
		return "AngelAirBoostCancel"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			return "AngelAirBackThrowWhiff"
		else:
			return "AngelAirThrowWhiff"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])) 
			and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		return "AirParryWhiff"
	elif (Global.assist_ok(state, interpreter)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "AngelAirAssistCall2"
		elif (Global.level_1_OK(state) and Global.super_assist_meter_ok(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			return "AngelAirAssistCallSuper"
		else:
			return "AngelAirAssistCall"
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "AirSuicopathToSuisei"
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "AngelJump2B"
	elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "AngelJump5B"
	elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "AngelJump5A"
	else:
		return ""

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
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "YoruMatsuyo"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "LightYoruMatsuyo"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "CaramelThrust"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "CaramelThrust"
	elif (interpreter.is_stick_dashing(true, state[Enums.StKey.leftface]) and state[Enums.StKey.stateName] != "Run"):
		return "Run"
	elif (interpreter.is_button_dashing(true, state[Enums.StKey.leftface])):
		return "Run"
	elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
		return "BackDash"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			interpreter.is_button_down(Enums.InputFlags.ADown)):
		return "Stand6A"
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
		return "AngelInstall"
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
		elif (Global.level_1_OK(state) and Global.super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
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
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "YoruMatsuyo"
	elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "LightYoruMatsuyo"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		return "AirCaramelThrust"
	elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		return "AirCaramelThrust"
	elif (state[Enums.StKey.airDash] > -1 and interpreter.is_stick_air_dashing(true, state[Enums.StKey.leftface]) and 
			state[Enums.StKey.stateName] != "ForwardAirDash"):
		return "ForwardAirDash"
	elif (state[Enums.StKey.airDash] > -1 and interpreter.is_stick_air_dashing(false, state[Enums.StKey.leftface]) and 
			state[Enums.StKey.stateName] != "BackwardAirDash"):
		return "BackwardAirDash"
	elif (state[Enums.StKey.airDash] > -1 and interpreter.is_button_dashing(true, state[Enums.StKey.leftface])):
		return "ForwardAirDash"
	elif (state[Enums.StKey.airDash] > -1 and interpreter.is_button_dashing(false, state[Enums.StKey.leftface])):
		return "BackwardAirDash"
	elif (Global.assist_ok(state, interpreter)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			return "AirAssistCall2"
		elif (Global.level_1_OK(state) and Global.super_assist_meter_ok(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			return "AirAssistCallSuper"
		else:
			return "AirAssistCall"
	elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		return "AirSuiseiToSuicopath"
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])
			and interpreter.is_button_down(Enums.InputFlags.BDown)):
		return "Jump6B"
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
