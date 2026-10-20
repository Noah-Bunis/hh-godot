extends AssistAttackState

class_name FubukiAssistAttackState

func _init():
	endFrame = 70
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 874037,
			},
		22 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 874037,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 27656194, Enums.StKey.Hit1PosY : -8650752,
			Enums.StKey.Hit1ScaleX : 3994068, Enums.StKey.Hit1ScaleY : -820144,
			Enums.StKey.min_damage:8,
			Enums.StKey.chip_damage:8,
			Enums.StKey.attack_damage: 45,
			Enums.StKey.hitstun: 20, 
#			Enums.StKey.counter_hitstun: 5,
			},
		24 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -6337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 574037,
			},
		32 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -6337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 574037,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : -36569096, Enums.StKey.Hit1PosY : -9306112,
			Enums.StKey.Hit1ScaleX : 5788561, Enums.StKey.Hit1ScaleY : -928867,
			Enums.StKey.min_damage:8,
			Enums.StKey.chip_damage: 8,
			Enums.StKey.attack_damage: 45,
			Enums.StKey.hitstun: 35,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*55,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: 0,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*50,
			},
		36 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -9337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 874037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.stop(true)
	anim.play("AssistAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 12):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*20
		state[Enums.StKey.drag_x] = Util.FRICTION
	if (state[Enums.StKey.frame] == 24):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*150
		state[Enums.StKey.drag_x] = Util.FRICTION+(SGFixed.ONE*5)
