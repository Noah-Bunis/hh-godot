extends SuicopathAttackState

class_name SuicopathScissorsState

var Voice = preload("res://game/assets/voice/suisei/sui_bokoboko ni shiteruyo.wav")

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		1 : {
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
		2 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1PosX : 9240576, Enums.StKey.Hit1PosY : -17595266,
			Enums.StKey.Hit1ScaleX : 778531, Enums.StKey.Hit1ScaleY : 775360,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*20,
			Enums.StKey.hitstun : 80,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.min_damage: 5,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.hitstop: 5,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.counter_launch_dir_y : -SGFixed.ONE*20,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			Enums.StKey.hit_box_colliding_frame : 100,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1PosX : 9240576, Enums.StKey.Hit1PosY : -19595266,
			Enums.StKey.Hit1ScaleX : 1578531, Enums.StKey.Hit1ScaleY : 1775360,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.hitstun : 70,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.min_damage: 5,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.hitstop: 12,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*2,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
		},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Suicopath3C")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.super_meter] -= Util.LEVEL_ONE_SUPER

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*50
		SyncManager.play_sound("SuicopathVoice", Voice, {"bus": "Voice"})
		SyncManager.play_sound("SuicopathVoiceReverb", Voice, {"bus": "ReverbVoice"})
	

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AngelBoostCancel"
		elif (assist_ok(state, interpreter)):
			if (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AngelGroundAssistCallSuper"
	else:
		if (boost_OK(state, interpreter)):
			change_state.call("AngelBoostCancel")

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
