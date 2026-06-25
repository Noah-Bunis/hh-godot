extends KurokamiCrouchAttackState

class_name Kurokami2BState

func _init():
	endFrame = 32
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 971143,
			Enums.StKey.Hurt2PosX : 5046271, Enums.StKey.Hurt2PosY : -5362432,
			Enums.StKey.Hurt2ScaleX : 745784, Enums.StKey.Hurt2ScaleY : 665625,
			},
		9 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 9629186, Enums.StKey.Hit1PosY : -3760254,
			Enums.StKey.Hit1ScaleX : 2226496, Enums.StKey.Hit1ScaleY : 350290,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 971143,
			Enums.StKey.Hurt2PosX : 5046271, Enums.StKey.Hurt2PosY : -5362432,
			Enums.StKey.Hurt2ScaleX : 745784, Enums.StKey.Hurt2ScaleY : 665625,
			Enums.StKey.Hurt3PosX : 15092544, Enums.StKey.Hurt3PosY : -7187392,
			Enums.StKey.Hurt3ScaleX : 1578601, Enums.StKey.Hurt3ScaleY : 696011,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_damage: 28,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 9629186, Enums.StKey.Hit1PosY : -11760254,
			Enums.StKey.Hit1ScaleX : 2226496, Enums.StKey.Hit1ScaleY : 550290,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 971143,
			Enums.StKey.Hurt2PosX : 5046271, Enums.StKey.Hurt2PosY : -5362432,
			Enums.StKey.Hurt2ScaleX : 745784, Enums.StKey.Hurt2ScaleY : 665625,
			Enums.StKey.Hurt3PosX : 15092544, Enums.StKey.Hurt3PosY : -7187392,
			Enums.StKey.Hurt3ScaleX : 1578601, Enums.StKey.Hurt3ScaleY : 696011,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_damage: 32,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		15 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 971143,
			Enums.StKey.Hurt2PosX : 5046271, Enums.StKey.Hurt2PosY : -5362432,
			Enums.StKey.Hurt2ScaleX : 745784, Enums.StKey.Hurt2ScaleY : 665625,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("2B")

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
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Crouch2A"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"
		

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

