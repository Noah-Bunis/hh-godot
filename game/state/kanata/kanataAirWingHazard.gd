extends "res://game/state/kanata/mainstates/kanataAirAttackState.gd"

class_name KanataAirWingHazardState

var Voice = preload("res://game/assets/voice/kanata/amk_bashx3.wav")

func _init():
	endFrame = 30
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 589824, Enums.StKey.Hurt1PosY : -12910592,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 6553600, Enums.StKey.Hurt2PosY : -22282238,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : -1245183, Enums.StKey.Hurt3PosY : -22216702,
			Enums.StKey.Hurt3ScaleX : 497627, Enums.StKey.Hurt3ScaleY : 523538,
			},
		4 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable: true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : 0,
			Enums.StKey.Hit1ScaleX : 18338272, Enums.StKey.Hit1ScaleY : 18338272,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop: 0,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
		},
		5 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 14614530, Enums.StKey.Hit1PosY : -24182786,
			Enums.StKey.Hit1ScaleX : 1083881, Enums.StKey.Hit1ScaleY : 995508,
			Enums.StKey.Hit2PosX : 40435712, Enums.StKey.Hit2PosY : -19136510,
			Enums.StKey.Hit2ScaleX : 1520696, Enums.StKey.Hit2ScaleY : 910074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 589824, Enums.StKey.Hurt1PosY : -12910592,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 6553600, Enums.StKey.Hurt2PosY : -22282238,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : -1245183, Enums.StKey.Hurt3PosY : -22216702,
			Enums.StKey.Hurt3ScaleX : 497627, Enums.StKey.Hurt3ScaleY : 523538,
			Enums.StKey.hit_box_colliding_frame : 1,
			Enums.StKey.burst_OK: false,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*30,
			Enums.StKey.hitstun : 150,
			Enums.StKey.attack_damage:65,
			Enums.StKey.min_damage:5,
			Enums.StKey.chip_damage:5,
			Enums.StKey.hitstop: 8,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*30,
			},
		11 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 14614530, Enums.StKey.Hit1PosY : -24182786,
			Enums.StKey.Hit1ScaleX : 1083881, Enums.StKey.Hit1ScaleY : 995508,
			Enums.StKey.Hit2PosX : 40435712, Enums.StKey.Hit2PosY : -19136510,
			Enums.StKey.Hit2ScaleX : 1520696, Enums.StKey.Hit2ScaleY : 910074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 589824, Enums.StKey.Hurt1PosY : -12910592,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 6553600, Enums.StKey.Hurt2PosY : -22282238,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : -1245183, Enums.StKey.Hurt3PosY : -22216702,
			Enums.StKey.Hurt3ScaleX : 497627, Enums.StKey.Hurt3ScaleY : 523538,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.burst_OK: false,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*50,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*60,
			Enums.StKey.hitstun : 120,
			Enums.StKey.attack_damage:100,
			Enums.StKey.min_damage:8,
			Enums.StKey.chip_damage:8,
			Enums.StKey.hitstop: 10,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 180,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*50,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*100,
			},
		22 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 589824, Enums.StKey.Hurt1PosY : -12910592,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 6553600, Enums.StKey.Hurt2PosY : -22282238,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : -1245183, Enums.StKey.Hurt3PosY : -22216702,
			Enums.StKey.Hurt3ScaleX : 497627, Enums.StKey.Hurt3ScaleY : 523538,
		},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("WingHazard")
	state[Enums.StKey.super_meter] -= Util.LEVEL_TWO_SUPER

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 4):
		SyncManager.play_sound("KanataVoice", Voice, {"bus": "Voice"})
		SyncManager.play_sound("KanataVoiceReverb", Voice, {"bus": "ReverbVoice"})
	

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AirBoostCancel"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "AirBoostCancel"):
			if (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AirAssistCallSuper"
	else:
		if (boost_OK(state, interpreter)):
			change_state.call("AirBoostCancel")

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
#	if (state[Enums.StKey.frame] > 5 and state[Enums.StKey.doubleJump] > 0 and state[Enums.StKey.hitStopFrame] > 0):
#		if (interpreter.is_tapping_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
#			state[Enums.StKey.cancelState] = "ForwardMidAirPreJump"
#		elif (interpreter.is_tapping_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
#			state[Enums.StKey.cancelState] = "MidAirPreJump"
#		elif (interpreter.is_tapping_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
#			state[Enums.StKey.cancelState] = "BackwardMidAirPreJump"

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
#	if (state[Enums.StKey.frame] > 5):
#		if (state[Enums.StKey.hitStopFrame] > 0):
#			if (state[Enums.StKey.airDash] > 0 and interpreter.is_air_dashing(true, state[Enums.StKey.leftface])):
#				state[Enums.StKey.cancelState] = "ForwardAirDash"
#			elif (state[Enums.StKey.airDash] > 0 and interpreter.is_air_dashing(false, state[Enums.StKey.leftface])):
#				state[Enums.StKey.cancelState] = "BackwardAirDash"
