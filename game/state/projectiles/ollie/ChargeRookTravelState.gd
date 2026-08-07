extends ActiveProjectileState

class_name ChargeRookTravelState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		3 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame: 254,
			Enums.StKey.chip_damage: 12,
			Enums.StKey.min_damage: 12,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*50,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*20,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.hitstop: 20,
			Enums.StKey.hitstun: 60,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*50,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*20,
			},
		30 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Travel")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*80
