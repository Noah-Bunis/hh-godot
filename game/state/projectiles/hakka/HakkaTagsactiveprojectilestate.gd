extends ActiveProjectileState

class_name HakkaTagsActiveProjectileState

func _init():
	endFrame = 80
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		2 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false,
			Enums.StKey.chip_damage: 4,
			Enums.StKey.min_damage: 4,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.meter_build: SGFixed.ONE*100,
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.hitstop : 7,
			},
		60 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = SGFixed.ONE*10
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.projectile_hp] = 4

func reaction(state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
