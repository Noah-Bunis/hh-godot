extends KurokamiJumpState

class_name KurokamiMidAirJumpState

const MID_AIR_JUMP_SPEED := SGFixed.ONE*-50

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = MID_AIR_JUMP_SPEED
	state[Enums.StKey.leftfaceOK] = true

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)

