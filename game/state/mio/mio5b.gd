extends MioAttackState

class_name Mio5BState

func _init():
	endFrame = 25
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt2PosX : 983040, Enums.StKey.Hurt2PosY : -22413310,
			Enums.StKey.Hurt2ScaleX : 430035, Enums.StKey.Hurt2ScaleY : -705015,
			Enums.StKey.Hurt3PosX : 5898240, Enums.StKey.Hurt3PosY : -11010049,
			Enums.StKey.Hurt3ScaleX : 561893, Enums.StKey.Hurt3ScaleY : -1088870,
			},
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 11796481, Enums.StKey.Hit1PosY : -15925248,
			Enums.StKey.Hit1ScaleX : 1260160, Enums.StKey.Hit1ScaleY : -252545,
			Enums.StKey.Hit2PosX : 17498114, Enums.StKey.Hit2PosY : -23068672,
			Enums.StKey.Hit2ScaleX : 995742, Enums.StKey.Hit2ScaleY : 475488,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 11599873, Enums.StKey.Hurt1PosY : -20185090,
			Enums.StKey.Hurt1ScaleX : 509506, Enums.StKey.Hurt1ScaleY : 263272,
			Enums.StKey.Hurt2PosX : 983040, Enums.StKey.Hurt2PosY : -22413310,
			Enums.StKey.Hurt2ScaleX : 430035, Enums.StKey.Hurt2ScaleY : -705015,
			Enums.StKey.Hurt3PosX : 5898240, Enums.StKey.Hurt3PosY : -11010049,
			Enums.StKey.Hurt3ScaleX : 561893, Enums.StKey.Hurt3ScaleY : -1088870,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 4,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_hitstun: 5,
			},
		15 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt2PosX : 983040, Enums.StKey.Hurt2PosY : -22413310,
			Enums.StKey.Hurt2ScaleX : 430035, Enums.StKey.Hurt2ScaleY : -705015,
			Enums.StKey.Hurt3PosX : 5898240, Enums.StKey.Hurt3PosY : -11010049,
			Enums.StKey.Hurt3ScaleX : 561893, Enums.StKey.Hurt3ScaleY : -1088870,
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

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	super.special_cancel(state, interpreter)
