extends "res://game/state/ollie/mainstates/ollieIdleState.gd"

class_name OllieRunState

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14107200,
			Enums.StKey.Hurt1ScaleX : 2291502, Enums.StKey.Hurt1ScaleY : 588738,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -5056321,
			Enums.StKey.Hurt2ScaleX : 892575, Enums.StKey.Hurt2ScaleY : 726926,
			},
		1 : {
			Enums.StKey.Summon : "backdashdust",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14107200,
			Enums.StKey.Hurt1ScaleX : 2291502, Enums.StKey.Hurt1ScaleY : 588738,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -5056321,
			Enums.StKey.Hurt2ScaleX : 892575, Enums.StKey.Hurt2ScaleY : 726926,
			},
		8 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14107200,
			Enums.StKey.Hurt1ScaleX : 2291502, Enums.StKey.Hurt1ScaleY : 588738,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -5056321,
			Enums.StKey.Hurt2ScaleX : 892575, Enums.StKey.Hurt2ScaleY : 726926,
		},
	}
	
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = -SGFixed.ONE*40 # Util.fixed_max(SGFixed.ONE*13, state[Enums.StKey.velocity_x])
	state[Enums.StKey.accel_x] = 205536
	state[Enums.StKey.leftfaceOK] = true
	anim.play("Run")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(state[Enums.StKey.velocity_x], 436)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] -= SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 1036)

	if (state[Enums.StKey.frame] >= 9):
		SyncManager.play_sound("step", Global.StepSound, {"bus": "Sound"})
		state[Enums.StKey.frame] = 2
	if (state[Enums.StKey.velocity_x] > SGFixed.ONE*30):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*30

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.leftfaceOK] = false
		
		if (state[Enums.StKey.kara_OK]):
			# Kara Cancel section
			if (boost_OK(state, interpreter)):
				change_state.call("BoostCancel")
			elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
				change_state.call("GroundThrowWhiff")
			elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
				change_state.call("StandFDStance")
			elif (interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
				change_state.call("CrouchParryWhiff")
			elif (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
				change_state.call("StandParryWhiff")
			elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
				change_state.call("BackDash")
		if (burst_OK(state, interpreter)):
			change_state.call("Burst")
	elif (not (interpreter.is_button_down(Enums.InputFlags.ADown) or
			interpreter.is_button_down(Enums.InputFlags.BDown) or
			interpreter.is_button_down(Enums.InputFlags.CDown) or
			interpreter.is_button_down(Enums.InputFlags.DDown))):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])):
			pass
		else:
			change_state.call("Skid")
	else:
		if (state[Enums.StKey.frame] >= Util.INPUT_BUFFER_LENIANCY):
			common_idle_transitions(state, interpreter)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		_:
			return super.has_property(state,property)

#func common_idle_transitions(state: Dictionary, interpreter: InputInterpreter) -> void:
	#if (burst_OK(state, interpreter)):
		#change_state.call("Burst")
	#elif (boost_OK(state, interpreter)):
		#change_state.call("BoostCancel")
	#elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
		#if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
				#interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
				#interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
			#change_state.call("GroundBackThrowWhiff")
		#else:
			#change_state.call("GroundThrowWhiff")
	#elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BHold | Enums.InputFlags.CHold)):
		#if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			#change_state.call("CrouchFDStance")
		#else:
			#change_state.call("StandFDStance")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		#change_state.call("CrouchParryWhiff")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BDown | Enums.InputFlags.CDown)):
		#change_state.call("StandParryWhiff")
	#elif (level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		#change_state.call("ProtonCannon")
	#elif (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		#change_state.call("EXStarBall")
	#elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
		#change_state.call("ChessA")
	#elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		#change_state.call("ChessB")
	#elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
		#change_state.call("ChessC")
	#elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
		#change_state.call("BackDash")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			#interpreter.is_button_down(Enums.InputFlags.CDown)):
		#change_state.call("Stand6C")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
			#interpreter.is_button_down(Enums.InputFlags.ADown)):
		#change_state.call("Stand6A")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
			#interpreter.is_button_down(Enums.InputFlags.CDown)):
		#change_state.call("Crouch3C")
	#elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			#interpreter.is_button_down(Enums.InputFlags.CDown)):
		#change_state.call("Crouch2C")
	#elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			#interpreter.is_button_down(Enums.InputFlags.BDown)):
		#change_state.call("Crouch2B")
	#elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
			#interpreter.is_button_down(Enums.InputFlags.ADown)):
		#change_state.call("Crouch2A")
	#elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
		#change_state.call("Stand5C")
	#elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
			#interpreter.is_button_down(Enums.InputFlags.BDown)):
		#change_state.call("StandcB")
	#elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
		#change_state.call("Stand5B")
	#elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
		#change_state.call("Stand5A")
	#elif (assist_ok(state, interpreter)):
		#if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
			#change_state.call("GroundAssistCall2")
		#elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
			#change_state.call("GroundAssistCallSuper")
		#else:
			#change_state.call("GroundAssistCall")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])):
		#change_state.call("ForwardWalk")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface])):
		#change_state.call("BackwardWalk")
	#elif (interpreter.super_jump()):
		#if (interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
			#change_state.call("ForwardPreSuperJump")
		#elif (interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			#change_state.call("PreSuperJump")
		#elif (interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
			#change_state.call("BackwardPreSuperJump")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		#change_state.call("ForwardPreJump")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
		#change_state.call("PreJump")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		#change_state.call("BackwardPreJump")
	#elif (interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			#interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])):
		#change_state.call("Crouch")
	#else:
		#change_state.call("Stand")
