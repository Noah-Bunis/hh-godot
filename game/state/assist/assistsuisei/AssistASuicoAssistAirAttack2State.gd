extends AssistAirAttackState

class_name AssistASuicoAssistAirAttack2State

func _init():
	endFrame = 20
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			},
		5 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -15124159,
			Enums.StKey.Hit1ScaleX : 1361402, Enums.StKey.Hit1ScaleY : 861402,
			Enums.StKey.Hit2PosX : 0, Enums.StKey.Hit2PosY : -15124159,
			Enums.StKey.Hit2ScaleX : 861402, Enums.StKey.Hit2ScaleY : 1361402,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.hitstun: 50,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x: -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*60,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
		10 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("ASuicoAssistAttack2")
