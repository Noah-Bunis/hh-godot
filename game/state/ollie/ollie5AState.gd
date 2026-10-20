extends "res://game/state/ollie/mainstates/ollieAttackState.gd"

class_name Ollie5AState

func _init():
	endFrame = 19
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -12255233,
			Enums.StKey.Hurt1ScaleX : 746005, Enums.StKey.Hurt1ScaleY : 1063088,
			Enums.StKey.Hurt2PosX : -3801088, Enums.StKey.Hurt2PosY : -7405568,
			Enums.StKey.Hurt2ScaleX : 837763, Enums.StKey.Hurt2ScaleY : -551149,
			Enums.StKey.Hurt3PosX : -3014656, Enums.StKey.Hurt3PosY : -20512770,
			Enums.StKey.Hurt3ScaleX : 752125, Enums.StKey.Hurt3ScaleY : -442939,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 7798784, Enums.StKey.Hit1PosY : -24051712,
			Enums.StKey.Hit1ScaleX : 1165722, Enums.StKey.Hit1ScaleY : 242820,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -12255233,
			Enums.StKey.Hurt1ScaleX : 746005, Enums.StKey.Hurt1ScaleY : 1063088,
			Enums.StKey.Hurt2PosX : 1900543, Enums.StKey.Hurt2PosY : -5308417,
			Enums.StKey.Hurt2ScaleX : 837763, Enums.StKey.Hurt2ScaleY : -519068,
			Enums.StKey.Hurt3PosX : 12058624, Enums.StKey.Hurt3PosY : -22937602,
			Enums.StKey.Hurt3ScaleX : 752125, Enums.StKey.Hurt3ScaleY : -442939,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 28,
			Enums.StKey.hitstop: 5,
			Enums.StKey.hitstun: 20,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_launch_dir_x: Util.BASE_SHORT_STRIKE_X_PUSHBACK,
			Enums.StKey.counter_launch_dir_y: Util.BASE_AIR_Y_PUSHBACK,
			Enums.StKey.block_dir_x : Util.BASE_SHORT_STRIKE_X_PUSHBACK,
			Enums.StKey.block_dir_y : Util.BASE_AIR_Y_PUSHBACK,
			Enums.StKey.launch_dir_x: Util.BASE_SHORT_STRIKE_X_PUSHBACK,
			Enums.StKey.launch_dir_y: Util.BASE_AIR_Y_PUSHBACK,
			},
		8 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -12255233,
			Enums.StKey.Hurt1ScaleX : 746005, Enums.StKey.Hurt1ScaleY : 1063088,
			Enums.StKey.Hurt2PosX : 2752512, Enums.StKey.Hurt2PosY : -5767168,
			Enums.StKey.Hurt2ScaleX : 1180219, Enums.StKey.Hurt2ScaleY : -551149,
			Enums.StKey.Hurt3PosX : 2490368, Enums.StKey.Hurt3PosY : -25427966,
			Enums.StKey.Hurt3ScaleX : 752125, Enums.StKey.Hurt3ScaleY : -442939,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("5A")

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
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Crouch2A"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"
		elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "StandcB"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"
