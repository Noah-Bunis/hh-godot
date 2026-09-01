extends KurokamiAttackState

class_name KurokamiDashPunchState

var voice = preload("res://game/assets/voice/fubuki/fbk_kurokami kieroshort.wav")

func _init():
	endFrame = 33
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 458752, Enums.StKey.Hurt1PosY : -15842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 564821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : 11060928, Enums.StKey.Hurt3PosY : -10956864,
			Enums.StKey.Hurt3ScaleX : 576905, Enums.StKey.Hurt3ScaleY : 876155,
			},
		2 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 458752, Enums.StKey.Hurt1PosY : -15842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 564821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : 11060928, Enums.StKey.Hurt3PosY : -10956864,
			Enums.StKey.Hurt3ScaleX : 576905, Enums.StKey.Hurt3ScaleY : 876155,
			Enums.StKey.Summon: "rundust",
			},
		7 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 18240576, Enums.StKey.Hit1PosY : -14595266,
			Enums.StKey.Hit1ScaleX : 1678530, Enums.StKey.Hit1ScaleY : 675360,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 458752, Enums.StKey.Hurt1PosY : -15842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 564821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : 19060928, Enums.StKey.Hurt3PosY : -13956863,
			Enums.StKey.Hurt3ScaleX : 1476905, Enums.StKey.Hurt3ScaleY : 576155,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*55,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*5,
			Enums.StKey.chip_damage: 3,
			Enums.StKey.min_damage:7,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.hitstun: 27,
			Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*35,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*8,
			},
		17 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 458752, Enums.StKey.Hurt1PosY : -15842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 564821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : 11060928, Enums.StKey.Hurt3PosY : -10956864,
			Enums.StKey.Hurt3ScaleX : 576905, Enums.StKey.Hurt3ScaleY : 876155,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("DashPunch")
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*40, state[Enums.StKey.velocity_x])
		SyncManager.play_sound("KurokamiVoice", voice, {"bus": "Voice"})
	elif (state[Enums.StKey.frame] == 17):
		state[Enums.StKey.drag_x] = Util.HYPER_FRICTION

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
