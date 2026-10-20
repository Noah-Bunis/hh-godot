extends "res://game/state/kanata/mainstates/kanataAttackState.gd"

class_name Kanata6AState

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt3PosX : 5111808, Enums.StKey.Hurt3PosY : -6225920,
			Enums.StKey.Hurt3ScaleX : 1150714, Enums.StKey.Hurt3ScaleY : -810479,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt3PosX : -410041, Enums.StKey.Hurt3PosY : -3538944,
			Enums.StKey.Hurt3ScaleX : 1171536, Enums.StKey.Hurt3ScaleY : -410041,
			Enums.StKey.hit_box_colliding_frame : 254,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit2PosX : 12369344, Enums.StKey.Hit2PosY : -23855108,
			Enums.StKey.Hit2ScaleX : 876525, Enums.StKey.Hit2ScaleY : 1036496,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt3PosX : -410041, Enums.StKey.Hurt3PosY : -3638944,
			Enums.StKey.Hurt3ScaleX : 1171536, Enums.StKey.Hurt3ScaleY : 610041,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.hitstop : 9,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 20,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*2,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 50,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*1,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*40,
			Enums.StKey.min_damage: 5,
			},
		12 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2949120, Enums.StKey.Hurt1PosY : -10354688,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : -10420224, Enums.StKey.Hurt2PosY : -16318464,
			Enums.StKey.Hurt2ScaleX : 834792, Enums.StKey.Hurt2ScaleY : -665103,
			Enums.StKey.Hurt3PosX : 5111808, Enums.StKey.Hurt3PosY : -6225920,
			Enums.StKey.Hurt3ScaleX : 1150714, Enums.StKey.Hurt3ScaleY : -810479,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("6A")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
#		if (interpreter.is_dashing(true, state[Enums.StKey.leftface])):
#			state[Enums.StKey.cancelState] = "Run"
#		elif (interpreter.is_dashing(false, state[Enums.StKey.leftface])):
#			state[Enums.StKey.cancelState] = "BackDash"
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
		elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "StandcB"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
