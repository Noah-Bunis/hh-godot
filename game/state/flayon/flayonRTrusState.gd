extends FlayonAttackState

class_name FlayonRTrusState

var VoiceSound = preload("res://game/assets/voice/flayon/mxf_deus_ex_machina.wav")

func _init():
	endFrame = 45
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		8 : {
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
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 3,
			Enums.StKey.Hit1PosX : 8629186, Enums.StKey.Hit1PosY : -15760254,
			Enums.StKey.Hit1ScaleX : 1526496, Enums.StKey.Hit1ScaleY : 1350290,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*75,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*80,
			Enums.StKey.chip_damage: 8,
			Enums.StKey.min_damage: 22,
			Enums.StKey.attack_damage: 55,
			Enums.StKey.hitstop: 22,
			Enums.StKey.hitstun: 120,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*75,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*80,
			},
		17 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 7929855, Enums.StKey.Hurt1PosY : -15990784,
			Enums.StKey.Hurt1ScaleX : 257090, Enums.StKey.Hurt1ScaleY : 604574,
			Enums.StKey.Hurt2PosX : 2949120, Enums.StKey.Hurt2PosY : -9240575,
			Enums.StKey.Hurt2ScaleX : 401098, Enums.StKey.Hurt2ScaleY : -853100,
			Enums.StKey.Hurt3PosX : 1245184, Enums.StKey.Hurt3PosY : -4259840,
			Enums.StKey.Hurt3ScaleX : 783139, Enums.StKey.Hurt3ScaleY : -370037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.super_meter] -= Util.LEVEL_TWO_SUPER
	anim.play("RTrus")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 7):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*25, state[Enums.StKey.velocity_x])
		SyncManager.play_sound("FlayonVoice", VoiceSound, {"bus": "Voice"})
		SyncManager.play_sound("FlayonVoiceReverb", VoiceSound, {"bus": "ReverbVoice"})


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

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func combo_pushback(comboTime: int) -> int:
	return 0
