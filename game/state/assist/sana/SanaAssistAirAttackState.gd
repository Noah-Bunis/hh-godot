extends AssistAirAttackState

class_name SanaAssistAirAttackState

func _init():
	endFrame = 12
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
		10 : {
			Enums.StKey.Summon : "move_pilot",
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("AssistAttack")

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 11 and interpreter.is_button_down(Enums.InputFlags.DHold)):
		state[Enums.StKey.frame] = 9
	super.handle_input(state, interpreter)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.ForceTagOut):
		exit_state()
	else:
		super.reaction(state, interpreter, event_cause)
