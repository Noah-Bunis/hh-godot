extends ActiveProjectileState

class_name SubaruEXBatterSetBallActiveProjectileState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		10 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 2,
			Enums.StKey.min_damage: 5,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.hitstop: 8,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.meter_build: 0,
			},
		50 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = SGFixed.ONE*1
	state[Enums.StKey.velocity_y] = -SGFixed.ONE*50
	state[Enums.StKey.accel_y] = 165536
	state[Enums.StKey.projectile_hp] = 4

func reaction(_state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.StrikeHurt):
		change_state.call("EnhancedActive")
	elif (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
	
