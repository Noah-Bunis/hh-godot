extends SubaruCrouchAttackState

class_name Subaru2BState

func _init():
	endFrame = 25
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -8000000,
			Enums.StKey.Hurt1ScaleX : 705536, Enums.StKey.Hurt1ScaleY : 805536,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -10316198,
			Enums.StKey.Hurt2ScaleX : 342394, Enums.StKey.Hurt2ScaleY : 1096324,
			},
		9 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 17104898, Enums.StKey.Hit1PosY : -1376256,
			Enums.StKey.Hit1ScaleX : 1170480, Enums.StKey.Hit1ScaleY : -167990,
			Enums.StKey.Hit2PosX : 9633793, Enums.StKey.Hit2PosY : -3014657,
			Enums.StKey.Hit2ScaleX : 711968, Enums.StKey.Hit2ScaleY : -321020,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -8000000,
			Enums.StKey.Hurt1ScaleX : 705536, Enums.StKey.Hurt1ScaleY : 805536,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -10316198,
			Enums.StKey.Hurt2ScaleX : 342394, Enums.StKey.Hurt2ScaleY : 1096324,
			Enums.StKey.Hurt3PosX : 13500000, Enums.StKey.Hurt3PosY : -3500000,
			Enums.StKey.Hurt3ScaleX : 1265536, Enums.StKey.Hurt3ScaleY : 365536,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Low,
			Enums.StKey.attack_damage: 38,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		10 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -8000000,
			Enums.StKey.Hurt1ScaleX : 705536, Enums.StKey.Hurt1ScaleY : 805536,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -10316198,
			Enums.StKey.Hurt2ScaleX : 342394, Enums.StKey.Hurt2ScaleY : 1096324,
			Enums.StKey.Hurt3PosX : 13500000, Enums.StKey.Hurt3PosY : -3500000,
			Enums.StKey.Hurt3ScaleX : 1265536, Enums.StKey.Hurt3ScaleY : 365536,
			},
		15 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -8000000,
			Enums.StKey.Hurt1ScaleX : 705536, Enums.StKey.Hurt1ScaleY : 805536,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -10316198,
			Enums.StKey.Hurt2ScaleX : 342394, Enums.StKey.Hurt2ScaleY : 1096324,
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
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
