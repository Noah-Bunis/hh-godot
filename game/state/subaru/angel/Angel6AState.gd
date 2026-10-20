extends AngelAttackState

class_name Angel6AState

func _init():
	endFrame = 18
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.Hurt2PosX : 458752, Enums.StKey.Hurt2PosY : -4915200,
			Enums.StKey.Hurt2ScaleX : 848843, Enums.StKey.Hurt2ScaleY : 585187,
			Enums.StKey.Hurt3PosX : 1835008, Enums.StKey.Hurt3PosY : -13107199,
			Enums.StKey.Hurt3ScaleX : 806255, Enums.StKey.Hurt3ScaleY : 411904,
			},
		4 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.Hurt2PosX : 458752, Enums.StKey.Hurt2PosY : -4915200,
			Enums.StKey.Hurt2ScaleX : 848843, Enums.StKey.Hurt2ScaleY : 585187,
			Enums.StKey.hit_box_colliding_frame : 254,
			
			},
		7 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 5046272, Enums.StKey.Hit1PosY : -20185090,
			Enums.StKey.Hit1ScaleX : 1595559, Enums.StKey.Hit1ScaleY : 527799,
			Enums.StKey.Hit2PosX : 7274494, Enums.StKey.Hit2PosY : -18350080,
			Enums.StKey.Hit2ScaleX : 997940, Enums.StKey.Hit2ScaleY : 747094,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.hitstun: 30,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*35,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 20,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*45,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			Enums.StKey.attack_damage: 40,
			},
		11 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.Hurt2PosX : -3997696, Enums.StKey.Hurt2PosY : -9895936,
			Enums.StKey.Hurt2ScaleX : 848843, Enums.StKey.Hurt2ScaleY : 585187,
			Enums.StKey.Hurt3PosX : -9437185, Enums.StKey.Hurt3PosY : -19857406,
			Enums.StKey.Hurt3ScaleX : 806255, Enums.StKey.Hurt3ScaleY : 411904,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Angel6A")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AngelStand6C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AngelCrouch3C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AngelCrouch2C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "AngelCrouch2B"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AngelStand5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "AngelStand5B"
