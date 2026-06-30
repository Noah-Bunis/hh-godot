extends ActiveProjectileState

class_name ChargeBishopTravelState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		5 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame: 254,
			Enums.StKey.chip_damage: 12,
			Enums.StKey.min_damage: 12,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15,
			Enums.StKey.launch_dir_y : SGFixed.ONE*37,
			Enums.StKey.hitstop: 12,
			Enums.StKey.hitstun: 60,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*20,
			},
		45 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Travel")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	
	if (state[Enums.StKey.frame] == 5):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*60
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*60
	elif (state[Enums.StKey.frame] == 20):
		state[Enums.StKey.velocity_y] = SGFixed.ONE*60
