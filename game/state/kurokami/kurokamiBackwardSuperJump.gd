extends KurokamiSuperJumpState

class_name KurokamiBackwardSuperJumpState

const X_JUMP_SPEED := -SGFixed.ONE*10

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = X_JUMP_SPEED

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 636)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] -= SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 836)
