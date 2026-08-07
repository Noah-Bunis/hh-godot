extends State

class_name NeutralState

func handle_input(_state: Dictionary, _interpreter: InputInterpreter) -> void:
	pass

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
