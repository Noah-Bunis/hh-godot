extends KurokamiAttackState

class_name Kurokami5CState

func _init():
	endFrame = 36
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -546271, Enums.StKey.Hurt1PosY : -15362432,
			Enums.StKey.Hurt1ScaleX : 745784, Enums.StKey.Hurt1ScaleY : 1465625,
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 17629186, Enums.StKey.Hit1PosY : -12760254,
			Enums.StKey.Hit1ScaleX : 1526496, Enums.StKey.Hit1ScaleY : 1350290,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1546271, Enums.StKey.Hurt1PosY : -10362432,
			Enums.StKey.Hurt1ScaleX : 745784, Enums.StKey.Hurt1ScaleY : 1065625,
			Enums.StKey.Hurt2PosX : 8500000, Enums.StKey.Hurt2PosY : -10087936,
			Enums.StKey.Hurt2ScaleX : 603537, Enums.StKey.Hurt2ScaleY : 971143,
			Enums.StKey.Hurt3PosX : 17629186, Enums.StKey.Hurt3PosY : -12760254,
			Enums.StKey.Hurt3ScaleX : 1626496, Enums.StKey.Hurt3ScaleY : 1450290,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		17 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1546271, Enums.StKey.Hurt1PosY : -10362432,
			Enums.StKey.Hurt1ScaleX : 745784, Enums.StKey.Hurt1ScaleY : 1065625,
			Enums.StKey.Hurt2PosX : 8500000, Enums.StKey.Hurt2PosY : -10087936,
			Enums.StKey.Hurt2ScaleX : 603537, Enums.StKey.Hurt2ScaleY : 971143,
			Enums.StKey.Hurt3PosX : 12420000, Enums.StKey.Hurt3PosY : -4187392,
			Enums.StKey.Hurt3ScaleX : 978601, Enums.StKey.Hurt3ScaleY : 396011,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("5C")

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
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
