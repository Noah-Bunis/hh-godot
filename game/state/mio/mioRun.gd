extends MioIdleState

class_name MioRunState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 524288, Enums.StKey.Hurt1PosY : -15532031,
			Enums.StKey.Hurt1ScaleX : 555414, Enums.StKey.Hurt1ScaleY : 748084,
			Enums.StKey.Hurt2PosX : 6422528, Enums.StKey.Hurt2PosY : -15597570,
			Enums.StKey.Hurt2ScaleX : 510595, Enums.StKey.Hurt2ScaleY : -912293,
			Enums.StKey.Hurt3PosX : -65535, Enums.StKey.Hurt3PosY : -7995392,
			Enums.StKey.Hurt3ScaleX : 1279494, Enums.StKey.Hurt3ScaleY : -793638,
			},
		1 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 524288, Enums.StKey.Hurt1PosY : -15532031,
			Enums.StKey.Hurt1ScaleX : 555414, Enums.StKey.Hurt1ScaleY : 748084,
			Enums.StKey.Hurt2PosX : 6422528, Enums.StKey.Hurt2PosY : -15597570,
			Enums.StKey.Hurt2ScaleX : 510595, Enums.StKey.Hurt2ScaleY : -912293,
			Enums.StKey.Hurt3PosX : -65535, Enums.StKey.Hurt3PosY : -7995392,
			Enums.StKey.Hurt3ScaleX : 1279494, Enums.StKey.Hurt3ScaleY : -793638,
		},
	}
	
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*10, state[Enums.StKey.velocity_x])
	state[Enums.StKey.accel_x] = 55536
	state[Enums.StKey.leftfaceOK] = true
	anim.play("Run")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(state[Enums.StKey.velocity_x], 436)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] -= SGFixed.mul(state[Enums.StKey.velocity_x], 1036)

	if (state[Enums.StKey.frame] >= 12):
		SyncManager.play_sound("step", Global.StepSound, {"bus": "Sound"})
		state[Enums.StKey.frame] = 1
	if (state[Enums.StKey.velocity_x] > SGFixed.ONE*45):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*45

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.leftfaceOK] = false
		
		if (state[Enums.StKey.kara_OK]):
			# Kara Cancel section
			if (boost_OK(state, interpreter)):
				change_state.call("BoostCancel")
			elif (interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
				if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
						interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
						interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
					change_state.call("GroundBackThrowWhiff")
				else:
					change_state.call("GroundThrowWhiff")
			elif (interpreter.is_blocking(state[Enums.StKey.leftface]) and interpreter.is_button_down(Enums.InputFlags.BHold | Enums.InputFlags.CHold)):
				if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
					change_state.call("CrouchFDStance")
				else:
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
