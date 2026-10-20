extends AssistAirAttackState

class_name AssistOllieAssistAirAttack2State

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 71827464, Enums.StKey.Hit1PosY : -3670016,
			Enums.StKey.Hit1ScaleX : 5079656, Enums.StKey.Hit1ScaleY : 667651,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*30,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.min_damage: 13,
			Enums.StKey.hitstun: 60,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*45,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*65,
			},
		18 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
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
