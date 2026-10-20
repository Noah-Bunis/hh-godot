extends ActiveProjectileState

class_name SubaruStarBallActiveProjectileState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		6 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 2,
			Enums.StKey.min_damage: 2,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hit_box_colliding_frame : 1,
			},
		60 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = SGFixed.ONE*8
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.projectile_hp] = 1
	state[Enums.StKey.accel_y] = 65536

func reaction(state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.StrikeHurt):
		state[Enums.StKey.frame] = 5
	elif (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
	
