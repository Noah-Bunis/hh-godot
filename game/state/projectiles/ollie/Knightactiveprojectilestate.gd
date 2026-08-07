extends ActiveProjectileState

class_name KnightActiveProjectileState

func _init():
	endFrame = 2
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,
			},
		1 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,
			},
	}

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		change_state.call("Travel")
	if (interpreter.is_button_down(Enums.InputFlags.CHold)):
		state[Enums.StKey.frame] = 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")