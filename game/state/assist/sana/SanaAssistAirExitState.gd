extends AssistAirExitState

class_name SanaAssistAirExitState

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	self.enforce_min_height(state)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		pass
	elif (event_cause == Enums.Reaction.ForceTagOut):
		exit_state()
	else:
		super.reaction(state, interpreter, event_cause)

func enforce_min_height(state: Dictionary):
	if (state["_pos_y"] <= Util.MAX_FLIGHT_HEIGHT):
		state[Enums.StKey.velocity_y] = -SGFixed.mul(state["_pos_y"] - Util.MAX_FLIGHT_HEIGHT, 536)
