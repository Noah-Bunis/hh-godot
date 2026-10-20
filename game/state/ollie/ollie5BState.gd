extends "res://game/state/ollie/mainstates/ollieAttackState.gd"

class_name Ollie5BState

func _init():
	endFrame = 29
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -1376256, Enums.StKey.Hurt1PosY : -12976128,
			Enums.StKey.Hurt1ScaleX : 864860, Enums.StKey.Hurt1ScaleY : 1253366,
			},
		4 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -983040, Enums.StKey.Hurt1PosY : -15990784,
			Enums.StKey.Hurt1ScaleX : 792031, Enums.StKey.Hurt1ScaleY : 1034044,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 19529730, Enums.StKey.Hit1PosY : -12451841,
			Enums.StKey.Hit1ScaleX : 1405564, Enums.StKey.Hit1ScaleY : 378195,
			Enums.StKey.Hit2PosX : -17629182, Enums.StKey.Hit2PosY : -19529730,
			Enums.StKey.Hit2ScaleX : 493329, Enums.StKey.Hit2ScaleY : 591914,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -11141120, Enums.StKey.Hurt1PosY : -15990784,
			Enums.StKey.Hurt1ScaleX : 1052528, Enums.StKey.Hurt1ScaleY : 553247,
			Enums.StKey.Hurt2PosX : 22609922, Enums.StKey.Hurt2PosY : -14155776,
			Enums.StKey.Hurt2ScaleX : 1267979, Enums.StKey.Hurt2ScaleY : -348575,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.hitstun: 24,
			Enums.StKey.blockstun: 20,
			Enums.StKey.counter_hitstun: 5,
			},
		18 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -983040, Enums.StKey.Hurt1PosY : -15990784,
			Enums.StKey.Hurt1ScaleX : 792031, Enums.StKey.Hurt1ScaleY : 1034044,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("5B")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 7):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*20

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand6C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand6A"
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
