extends ActiveProjectileState

class_name AirKnightTravelState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		3 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame: 254,
			Enums.StKey.chip_damage: 8,
			Enums.StKey.min_damage: 8,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 20,
			Enums.StKey.blockstun: 20,
			},
		80 : {
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
		state[Enums.StKey.velocity_x] = SGFixed.ONE*70
		state[Enums.StKey.velocity_y] = SGFixed.ONE*40
	elif (state[Enums.StKey.frame] > 3):
		state[Enums.StKey.velocity_x] -= SGFixed.ONE*4
		state[Enums.StKey.velocity_y] -= SGFixed.ONE*4
