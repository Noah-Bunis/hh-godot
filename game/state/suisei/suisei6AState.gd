extends SuiseiAttackState

class_name Suisei6AState

func _init():
	endFrame = 35
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.Hurt2PosX : 458752, Enums.StKey.Hurt2PosY : -4915200,
			Enums.StKey.Hurt2ScaleX : 848843, Enums.StKey.Hurt2ScaleY : -585187,
			Enums.StKey.Hurt3PosX : 1835008, Enums.StKey.Hurt3PosY : -13107199,
			Enums.StKey.Hurt3ScaleX : 806255, Enums.StKey.Hurt3ScaleY : -411904,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.Hurt2PosX : 458752, Enums.StKey.Hurt2PosY : -4915200,
			Enums.StKey.Hurt2ScaleX : 848843, Enums.StKey.Hurt2ScaleY : -585187,
			},
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 12058625, Enums.StKey.Hit1PosY : -21889026,
			Enums.StKey.Hit1ScaleX : 1220205, Enums.StKey.Hit1ScaleY : 646265,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2097152, Enums.StKey.Hurt1PosY : -2555901,
			Enums.StKey.Hurt1ScaleX : 1244010, Enums.StKey.Hurt1ScaleY : 402320,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.hit_box_colliding_frame : 254,
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -16842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 1634821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : -8060928, Enums.StKey.Hurt3PosY : -17956864,
			Enums.StKey.Hurt3ScaleX : 376905, Enums.StKey.Hurt3ScaleY : 376155,
			},
		21 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 8585215, Enums.StKey.Hit1PosY : -20316160,
			Enums.StKey.Hit1ScaleX : 1220205, Enums.StKey.Hit1ScaleY : 646265,
			Enums.StKey.Hit2PosX : 17235968, Enums.StKey.Hit2PosY : -10354688,
			Enums.StKey.Hit2ScaleX : 1139031, Enums.StKey.Hit2ScaleY : 231125,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -16842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 1634821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : 10813440, Enums.StKey.Hurt3PosY : -17104894,
			Enums.StKey.Hurt3ScaleX : 1204535, Enums.StKey.Hurt3ScaleY : 816641,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.meter_build: SGFixed.ONE*1000,
			Enums.StKey.hit_box_colliding_frame : 254,
			},
		25 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -16842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 1634821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : -8060928, Enums.StKey.Hurt3PosY : -17956864,
			Enums.StKey.Hurt3ScaleX : 376905, Enums.StKey.Hurt3ScaleY : 376155,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("6A")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 19):
		SyncManager.play_sound("whiff", WhiffSound, {"bus": "Sound"})

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Crouch2B"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
