extends OgaAttackState

class_name OgaSnapbackState

var voice = preload("res://game/assets/voice/oga/oga_dete koi.wav")

func _init():
	endFrame = 20
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -16449536, Enums.StKey.Hurt1PosY : -28573704,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -19333118, Enums.StKey.Hurt2PosY : -17498110,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : -15204352, Enums.StKey.Hurt3PosY : -9240577,
			Enums.StKey.Hurt3ScaleX : 1114917, Enums.StKey.Hurt3ScaleY : 997624,
			},
		3 : {
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
		6 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -3473408, Enums.StKey.Hurt1PosY : -35651584,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -3145728, Enums.StKey.Hurt2PosY : -27656192,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : -2097152, Enums.StKey.Hurt3PosY : -10223617,
			Enums.StKey.Hurt3ScaleX : 1114917, Enums.StKey.Hurt3ScaleY : 997624,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 18350082, Enums.StKey.Hit1PosY : -26279940,
			Enums.StKey.Hit1ScaleX : 4368064, Enums.StKey.Hit1ScaleY : -1247742,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*65,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*45,
			Enums.StKey.burst_OK: false,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.hitstun: 60,
			Enums.StKey.counter_hitstun: 120,
			Enums.StKey.attack_damage: 80,
			Enums.StKey.min_damage: 18,
			Enums.StKey.hitstop: 12,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*65,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*55,
			},
		14 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -3473408, Enums.StKey.Hurt1PosY : -35651584,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -3145728, Enums.StKey.Hurt2PosY : -27656192,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : -2097152, Enums.StKey.Hurt3PosY : -10223617,
			Enums.StKey.Hurt3ScaleX : 1114917, Enums.StKey.Hurt3ScaleY : 997624,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Snapback")
	state[Enums.StKey.super_meter] -= Util.LEVEL_ONE_SUPER

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		SyncManager.play_sound("OgaVoice", voice, {"bus": "Voice"})
		SyncManager.play_sound("OgaVoiceReverb", voice, {"bus": "ReverbVoice"})

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "BoostCancel"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "BoostCancel"):
			if (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCallSuper"
	else:
		if (boost_OK(state, interpreter)):
			change_state.call("BoostCancel")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
