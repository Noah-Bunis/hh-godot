extends SubaruAttackState

class_name Subaru5CState

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 3407872, Enums.StKey.Hurt1PosY : -18219010,
			Enums.StKey.Hurt1ScaleX : 1116767, Enums.StKey.Hurt1ScaleY : 218114,
			Enums.StKey.Hurt2PosX : 3997696, Enums.StKey.Hurt2PosY : -10092544,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 2490368, Enums.StKey.Hurt3PosY : -3866624,
			Enums.StKey.Hurt3ScaleX : 916621, Enums.StKey.Hurt3ScaleY : -393975,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 16056320, Enums.StKey.Hit1PosY : -13238273,
			Enums.StKey.Hit1ScaleX : 1219317, Enums.StKey.Hit1ScaleY : -661855,
			Enums.StKey.Hit2PosX : 15663104, Enums.StKey.Hit2PosY : -14286847,
			Enums.StKey.Hit2ScaleX : 1613615, Enums.StKey.Hit2ScaleY : -321020,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 3407872, Enums.StKey.Hurt1PosY : -18219010,
			Enums.StKey.Hurt1ScaleX : 1116767, Enums.StKey.Hurt1ScaleY : 218114,
			Enums.StKey.Hurt2PosX : 3997696, Enums.StKey.Hurt2PosY : -10092544,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 2490368, Enums.StKey.Hurt3PosY : -3866624,
			Enums.StKey.Hurt3ScaleX : 916621, Enums.StKey.Hurt3ScaleY : -393975,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 52,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*12,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			Enums.StKey.counter_hitstun: 10,
			},
		12 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 3407872, Enums.StKey.Hurt1PosY : -18219010,
			Enums.StKey.Hurt1ScaleX : 1116767, Enums.StKey.Hurt1ScaleY : 218114,
			Enums.StKey.Hurt2PosX : 3997696, Enums.StKey.Hurt2PosY : -10092544,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 2490368, Enums.StKey.Hurt3PosY : -3866624,
			Enums.StKey.Hurt3ScaleX : 916621, Enums.StKey.Hurt3ScaleY : -393975,
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
