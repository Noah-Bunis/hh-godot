extends OgaCrouchAttackState

class_name Oga2AState

func _init():
	endFrame = 12
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -6881280, Enums.StKey.Hurt1PosY : -27390912,
			Enums.StKey.Hurt1ScaleX : 1001320, Enums.StKey.Hurt1ScaleY : 476368,
			Enums.StKey.Hurt2PosX : -2359295, Enums.StKey.Hurt2PosY : -10747904,
			Enums.StKey.Hurt2ScaleX : 843346, Enums.StKey.Hurt2ScaleY : -1101378,
			Enums.StKey.Hurt3PosX : -10944512, Enums.StKey.Hurt3PosY : -22740992,
			Enums.StKey.Hurt3ScaleX : 770410, Enums.StKey.Hurt3ScaleY : -441327,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 10485760, Enums.StKey.Hit1PosY : -2555904,
			Enums.StKey.Hit1ScaleX : 986282, Enums.StKey.Hit1ScaleY : 224295,
			Enums.StKey.Hit2PosX : 7274496, Enums.StKey.Hit2PosY : -5308416,
			Enums.StKey.Hit2ScaleX : 524421, Enums.StKey.Hit2ScaleY : -394854,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 10027009, Enums.StKey.Hurt1PosY : -4325377,
			Enums.StKey.Hurt1ScaleX : 808592, Enums.StKey.Hurt1ScaleY : -374143,
			Enums.StKey.Hurt2PosX : -2359295, Enums.StKey.Hurt2PosY : -10747904,
			Enums.StKey.Hurt2ScaleX : 843346, Enums.StKey.Hurt2ScaleY : -1101378,
			Enums.StKey.Hurt3PosX : -10747904, Enums.StKey.Hurt3PosY : -4980736,
			Enums.StKey.Hurt3ScaleX : 770410, Enums.StKey.Hurt3ScaleY : -441327,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.attack_damage: 15,
			Enums.StKey.hitstun: Util.DEFAULT_LIGHT_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_LIGHT_BLOCKSTUN,
			Enums.StKey.guard: Enums.GuardType.Low,
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
			Enums.StKey.Hurt1PosX : 10027009, Enums.StKey.Hurt1PosY : -4325377,
			Enums.StKey.Hurt1ScaleX : 808592, Enums.StKey.Hurt1ScaleY : -374143,
			Enums.StKey.Hurt2PosX : -2359295, Enums.StKey.Hurt2PosY : -10747904,
			Enums.StKey.Hurt2ScaleX : 843346, Enums.StKey.Hurt2ScaleY : -1101378,
			Enums.StKey.Hurt3PosX : -10747904, Enums.StKey.Hurt3PosY : -4980736,
			Enums.StKey.Hurt3ScaleX : 770410, Enums.StKey.Hurt3ScaleY : -441327,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("2A")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 8):
		state[Enums.StKey.hitStopFrame] = 0

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
