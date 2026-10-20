extends AssistAirAttackState

class_name SoraAssistAirAttackState

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
		8 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 9, 
			Enums.StKey.Hit1PosX : 12189696, Enums.StKey.Hit1PosY : -15925248,
			Enums.StKey.Hit1ScaleX : 1134105, Enums.StKey.Hit1ScaleY : 1114853,
			Enums.StKey.hitstun : 60,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*60,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.min_damage:10,
			Enums.StKey.chip_damage:10,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 200,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*60,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*80,
#			Enums.StKey.counter_hitstun: 5,
			},
		16 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
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
	anim.play("AssistAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*20
		state[Enums.StKey.drag_x] = Util.FRICTION
