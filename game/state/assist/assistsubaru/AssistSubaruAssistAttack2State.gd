extends AssistAttackState

class_name AssistSubaruAssistAttack2State

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
		7 : { 
			Enums.StKey.Hit1Disable : false, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX: 10158081, Enums.StKey.Hit1PosY : -24379394,
			Enums.StKey.Hit1ScaleX : 848976, Enums.StKey.Hit1ScaleY : 1548125,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.hitstun : 35,
			Enums.StKey.hitstop : 12,
			Enums.StKey.attack_damage:60,
			Enums.StKey.min_damage: 12,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		13 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("AssistAttack2")
