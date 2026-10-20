extends ActiveProjectileState

class_name SubaruEXBatterSetEnhancedBallActiveProjectileState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		2 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 2,
			Enums.StKey.min_damage: 6,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.hitstun : 60,
			Enums.StKey.hitstop : 8,
			Enums.StKey.hit_box_colliding_frame : 1,
			Enums.StKey.meter_build: 0,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*50,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*60,
			Enums.StKey.counter_hitstun: 40,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*50,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
		50 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.accel_y] = 155536
	state[Enums.StKey.projectile_hp] = 5


func reaction(state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.StrikeHurt):
		state[Enums.StKey.frame] = 2
