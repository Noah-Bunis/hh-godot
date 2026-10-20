extends AssistAttackState

class_name AssistOgaDPState

var voice = preload("res://game/assets/voice/oga/oga_hanase.wav")
var sound = preload("res://game/assets/sfx/Parry8Bit.wav")

func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		13 : {
			Enums.StKey.Hit1Disable : false, 
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 3014656, Enums.StKey.Hit1PosY : -40108028,
			Enums.StKey.Hit1ScaleX : 1582990, Enums.StKey.Hit1ScaleY : 5404026,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*80,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 40,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.attack_damage: 70,
			Enums.StKey.min_damage: 12,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*80,
			},
		17 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.drag_x] = Util.ICE_FRICTION
	anim.stop(true)
	anim.play("DP")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("ogaDPVoice", voice, {"bus": "Voice"})
	if (state[Enums.StKey.frame] == 11):
		SyncManager.play_sound("ogaDPSound", sound, {"bus": "Sound"})
