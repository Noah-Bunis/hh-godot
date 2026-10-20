extends SubaruAttackState

class_name Subaru5BState

func _init():
	endFrame = 27
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 5505024, Enums.StKey.Hurt1PosY : -2883584,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : -3145727, Enums.StKey.Hurt2PosY : -8978431,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : 774072,
			Enums.StKey.Hurt3PosX : -1376256, Enums.StKey.Hurt3PosY : -6553600,
			Enums.StKey.Hurt3ScaleX : 537867, Enums.StKey.Hurt3ScaleY : 688237,
			},
		7 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 21037056, Enums.StKey.Hit1PosY : -13828095,
			Enums.StKey.Hit1ScaleX : 1507117, Enums.StKey.Hit1ScaleY : 268088,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 18612226, Enums.StKey.Hurt1PosY : -15663102,
			Enums.StKey.Hurt1ScaleX : 1565087, Enums.StKey.Hurt1ScaleY : 263318,
			Enums.StKey.Hurt2PosX : 7405568, Enums.StKey.Hurt2PosY : -7143424,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : 774072,
			Enums.StKey.Hurt3PosX : 65536, Enums.StKey.Hurt3PosY : -3932160,
			Enums.StKey.Hurt3ScaleX : 591882, Enums.StKey.Hurt3ScaleY : 447191,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.hitstun: 18,
			Enums.StKey.counter_hitstun: 5,
			},
		10 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 18612226, Enums.StKey.Hurt1PosY : -15663102,
			Enums.StKey.Hurt1ScaleX : 1565087, Enums.StKey.Hurt1ScaleY : 303318,
			Enums.StKey.Hurt2PosX : 7405568, Enums.StKey.Hurt2PosY : -7143424,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : 774072,
			Enums.StKey.Hurt3PosX : 65536, Enums.StKey.Hurt3PosY : -3932160,
			Enums.StKey.Hurt3ScaleX : 591882, Enums.StKey.Hurt3ScaleY : 447191,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("5B")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand6C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch3C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch2C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Crouch2B"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"
