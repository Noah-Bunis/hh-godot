extends OgaAttackState

class_name Oga6AState

func _init():
	endFrame = 31
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -10745600,
			Enums.StKey.Hurt1ScaleX : 1273239, Enums.StKey.Hurt1ScaleY : 1063361,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -7745600,
			Enums.StKey.Hurt1ScaleX : 1273239, Enums.StKey.Hurt1ScaleY : 863361,
			},
		9 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1048576, Enums.StKey.Hurt1PosY : -2555904,
			Enums.StKey.Hurt1ScaleX : 1152422, Enums.StKey.Hurt1ScaleY : 549360,
			Enums.StKey.Hurt2PosX : 3014656, Enums.StKey.Hurt2PosY : -19464192,
			Enums.StKey.Hurt2ScaleX : 813700, Enums.StKey.Hurt2ScaleY : -1564074,
			Enums.StKey.Hurt3PosX : 7602176, Enums.StKey.Hurt3PosY : -38797312,
			Enums.StKey.Hurt3ScaleX : 443515, Enums.StKey.Hurt3ScaleY : 1025355,
			Enums.StKey.Hit1PosX : 11337728, Enums.StKey.Hit1PosY : -29884416,
			Enums.StKey.Hit1ScaleX : 482445, Enums.StKey.Hit1ScaleY : 2036643,
			Enums.StKey.attack_damage: 48,
			},
		14 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1048576, Enums.StKey.Hurt1PosY : -2555904,
			Enums.StKey.Hurt1ScaleX : 1152422, Enums.StKey.Hurt1ScaleY : 549360,
			Enums.StKey.Hurt2PosX : 3014656, Enums.StKey.Hurt2PosY : -19464192,
			Enums.StKey.Hurt2ScaleX : 813700, Enums.StKey.Hurt2ScaleY : -1564074,
			Enums.StKey.Hurt3PosX : 7602176, Enums.StKey.Hurt3PosY : -38797312,
			Enums.StKey.Hurt3ScaleX : 443515, Enums.StKey.Hurt3ScaleY : 1025355,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("6A")

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
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Crouch2A"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"
