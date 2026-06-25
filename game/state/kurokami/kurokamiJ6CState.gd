extends KurokamiAirAttackState

class_name Kurokamij6CState

var voice = preload("res://game/assets/voice/flayon/mxf_grunt.wav")

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1071143,
			},
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit2PosX : 8007743, Enums.StKey.Hit2PosY : -14468802,
			Enums.StKey.Hit2ScaleX : 1562388, Enums.StKey.Hit2ScaleY : 722388, #572388 #264530
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1071143,
			
			Enums.StKey.hitstun : 23,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*25,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*55,
			Enums.StKey.hitstop: 10,
			Enums.StKey.min_damage:6,
			Enums.StKey.chip_damage:3,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 20,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*25,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*55,
			},
		15 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1071143,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("j6C")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*25, state[Enums.StKey.velocity_x])
		state[Enums.StKey.accel_y] = 0
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*2
		SyncManager.play_sound("kurokamiVoice", voice, {"bus": "Voice"})
	elif (state[Enums.StKey.frame] == 10):
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], 30000)
		state[Enums.StKey.accel_y] = Util.GRAVITY
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*20

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
	
