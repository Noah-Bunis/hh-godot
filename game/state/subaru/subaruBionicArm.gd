extends SubaruAttackState

class_name SubaruBionicArmState

var CallSound = preload("res://game/assets/voice/subaru/sbr_shriek2.wav")

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		5 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
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
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1PosX : 12386304, Enums.StKey.Hit1PosY : -14483457,
			Enums.StKey.Hit1ScaleX : 2889128, Enums.StKey.Hit1ScaleY : -1424716,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*75,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.hitstun : 80,
			Enums.StKey.attack_damage: 110,
			Enums.StKey.min_damage: 36,
			Enums.StKey.chip_damage: 10,
			Enums.StKey.hitstop: 20,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*90,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1PosX : 12386304, Enums.StKey.Hit1PosY : -14483457,
			Enums.StKey.Hit1ScaleX : 2889128, Enums.StKey.Hit1ScaleY : -1424716,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*75,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.hitstun : 80,
			Enums.StKey.attack_damage:85,
			Enums.StKey.min_damage:40,
			Enums.StKey.chip_damage:10,
			Enums.StKey.hitstop: 12,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*90,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		37 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
		},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("BionicArm")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.super_meter] -= Util.LEVEL_TWO_SUPER

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] >= 6 and state[Enums.StKey.frame] < 37):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*70
	elif (state[Enums.StKey.frame] == 5):
		SyncManager.play_sound("SubaruVoice", CallSound, {"bus": "Voice"})
		SyncManager.play_sound("SubaruVoiceReverb", CallSound, {"bus": "ReverbVoice"})

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

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
