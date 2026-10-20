extends OgaAttackState

class_name OgaSlashModeState

var voice = preload("res://game/assets/voice/oga/oga_HAAA.wav")

func _init():
	endFrame = 95
	
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
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 1, 
			Enums.StKey.Hit1PosX : 13893632, Enums.StKey.Hit1PosY : -11730948,
			Enums.StKey.Hit1ScaleX : 2980910, Enums.StKey.Hit1ScaleY : -1776345,
			Enums.StKey.attack_type: Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.burst_OK: false,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstun: 22, 
			Enums.StKey.hitstop: 6,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.attack_damage: 40,
			},
		13 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		14 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false, 
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.Hit1PosX : 13893632, Enums.StKey.Hit1PosY : -11730948,
			Enums.StKey.Hit1ScaleX : 2980910, Enums.StKey.Hit1ScaleY : -1776345,
			Enums.StKey.launch_dir_x : SGFixed.ONE,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*50,
			Enums.StKey.burst_OK: false,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: 22, 
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*55,
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -27983874,
			Enums.StKey.Hurt1ScaleX : 952224, Enums.StKey.Hurt1ScaleY : 2793184,
			Enums.StKey.Hurt2PosX : -1507327, Enums.StKey.Hurt2PosY : -16711681,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : 983039, Enums.StKey.Hurt3PosY : -4521985,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			},
		25 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false, 
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.Hit1PosX : 3014656, Enums.StKey.Hit1PosY : -40108028,
			Enums.StKey.Hit1ScaleX : 2282990, Enums.StKey.Hit1ScaleY : -5404026,
			Enums.StKey.launch_dir_x : 0,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*30,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.burst_OK: false,
			Enums.StKey.hitstun: 22, 
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*0,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*55,
			},
		35 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.counterOK : true,
			},
		39 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false, 
			Enums.StKey.hit_box_colliding_frame : 25,
			Enums.StKey.Hit1PosX : 3014656, Enums.StKey.Hit1PosY : -40108028,
			Enums.StKey.Hit1ScaleX : 2282990, Enums.StKey.Hit1ScaleY : -5404026,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*80,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.burst_OK: false,
			Enums.StKey.hitstun: 120,
			Enums.StKey.counter_hitstun: 180,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.min_damage: 20,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*120,
			},
		40 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 7536640, Enums.StKey.Hurt1PosY : -23461888,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -1507327, Enums.StKey.Hurt2PosY : -16711681,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : 983039, Enums.StKey.Hurt3PosY : -4521985,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			},
		69 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 7536640, Enums.StKey.Hurt1PosY : -23461888,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -1507327, Enums.StKey.Hurt2PosY : -16711681,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : 983039, Enums.StKey.Hurt3PosY : -4521985,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("SlashMode")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.super_meter] -= Util.LEVEL_TWO_SUPER

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		SyncManager.play_sound("OgaVoice", voice, {"bus": "Voice"})
		SyncManager.play_sound("OgaVoiceReverb", voice, {"bus": "ReverbVoice"})
	elif (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*90
	if (state[Enums.StKey.frame] > 5 and state[Enums.StKey.frame] < 20):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*30
	elif (state[Enums.StKey.frame] == 20):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*35

func combo_pushback(comboTime: int) -> int:
	return 0

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
