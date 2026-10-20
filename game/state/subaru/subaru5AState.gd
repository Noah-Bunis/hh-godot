extends SubaruAttackState

class_name Subaru5AState

func _init():
	endFrame = 20
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -8000000,
			Enums.StKey.Hurt1ScaleX : 705536, Enums.StKey.Hurt1ScaleY : 805536,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -12316198,
			Enums.StKey.Hurt2ScaleX : 542394, Enums.StKey.Hurt2ScaleY : 1096324,
			},
		7 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 7405568, Enums.StKey.Hit1PosY : -16646144,
			Enums.StKey.Hit1ScaleX : 657665, Enums.StKey.Hit1ScaleY : 734906,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6553600, Enums.StKey.Hurt1PosY : -21561344,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : 7077888, Enums.StKey.Hurt2PosY : -15073280,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 851968, Enums.StKey.Hurt3PosY : -4521984,
			Enums.StKey.Hurt3ScaleX : 397190, Enums.StKey.Hurt3ScaleY : -382619,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.hitstop: 8,
			Enums.StKey.hitstun: Util.DEFAULT_LIGHT_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_LIGHT_BLOCKSTUN,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_launch_dir_x: Util.BASE_SHORT_STRIKE_X_PUSHBACK,
			Enums.StKey.counter_launch_dir_y: Util.BASE_AIR_Y_PUSHBACK,
			Enums.StKey.block_dir_x : Util.BASE_STRIKE_X_PUSHBACK,
			Enums.StKey.block_dir_y : Util.BASE_AIR_Y_PUSHBACK,
			Enums.StKey.launch_dir_x: Util.BASE_STRIKE_X_PUSHBACK,
			Enums.StKey.launch_dir_y: Util.BASE_AIR_Y_PUSHBACK,
			},
		10 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6553600, Enums.StKey.Hurt1PosY : -21561344,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : 7077888, Enums.StKey.Hurt2PosY : -15073280,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 851968, Enums.StKey.Hurt3PosY : -4521984,
			Enums.StKey.Hurt3ScaleX : 397190, Enums.StKey.Hurt3ScaleY : -382619,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.play("5A")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.velocity_x] = Util.fixed_max(state[Enums.StKey.velocity_x], SGFixed.ONE*30)
#	if (state[Enums.StKey.frame] == 8):
#		state[Enums.StKey.hitStopFrame] = 0

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
