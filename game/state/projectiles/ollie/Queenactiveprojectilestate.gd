extends ActiveProjectileState

class_name QueenActiveProjectileState

func _init():
	endFrame = 2
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,
			Enums.StKey.chip_damage: 20,
			Enums.StKey.min_damage: 20,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.attack_damage: 70,
			Enums.StKey.hitstun: 30,
			},
		1 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,
			Enums.StKey.chip_damage: 20,
			Enums.StKey.min_damage: 20,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.attack_damage: 70,
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.hitstun: 30,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.projectile_hp] = 10

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		change_state.call("Travel")
	if (interpreter.is_button_down(Enums.InputFlags.DHold)):
		state[Enums.StKey.frame] = 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
