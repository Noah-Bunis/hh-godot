extends AssistAirAttackState

class_name HakkaAssistAirAttack2State

var voice = preload("res://game/assets/voice/hakka/bzn_helicopter1.wav")

func _init():
	endFrame = 200
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
		11 : { 
			Enums.StKey.Hit1Disable : false, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX: -1048576, Enums.StKey.Hit1PosY : -20905984,
			Enums.StKey.Hit1ScaleX : 2592796, Enums.StKey.Hit1ScaleY : 981041,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*25,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*50,
			Enums.StKey.hitstun : 35,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.min_damage: 12,
			Enums.StKey.chip_damage: 10,
			Enums.StKey.hitstop : 11,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*70,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*50,
			},
		16 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = -SGFixed.ONE*50
	state[Enums.StKey.accel_y] = Util.GRAVITY
	anim.stop(true)
	anim.play("AssistAttack2")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*30
	elif (state[Enums.StKey.frame] == 7):
		SyncManager.play_sound("HakkaVoice", voice, {"bus": "Voice"})
	
