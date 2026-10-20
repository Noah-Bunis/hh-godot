extends AssistAttackState

class_name AssistSuiseiAssistAttackState

func _init():
	endFrame = 34
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			},
		4 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Summon: "rundust",
			},
		5 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 14240576, Enums.StKey.Hit1PosY : -19595266,
			Enums.StKey.Hit1ScaleX : 1278530, Enums.StKey.Hit1ScaleY : 875360,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*35,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*45,
			Enums.StKey.chip_damage: 8,
			Enums.StKey.min_damage:8,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 60,
			Enums.StKey.hitstop: 10,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 90,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*45,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*45,
			},
		24 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -16842752,
			Enums.StKey.Hurt1ScaleX : 480251, Enums.StKey.Hurt1ScaleY : 1634821,
			Enums.StKey.Hurt2PosX : 1769472, Enums.StKey.Hurt2PosY : -5177345,
			Enums.StKey.Hurt2ScaleX : 670493, Enums.StKey.Hurt2ScaleY : 534448,
			Enums.StKey.Hurt3PosX : 14240576, Enums.StKey.Hurt3PosY : -17595266,
			Enums.StKey.Hurt3ScaleX : 1278530, Enums.StKey.Hurt3ScaleY : 675360,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = 0
	anim.stop(true)
	anim.play("AssistAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*55, state[Enums.StKey.velocity_x])
	elif (state[Enums.StKey.frame] == 14):
		state[Enums.StKey.drag_x] = Util.FD_FRICTION
