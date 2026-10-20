extends AssistAirAttackState

class_name SanaAirPilotState

func _init():
	endFrame = 10

	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
		},
		2 : {
			Enums.StKey.Hit1Disable : true, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			Enums.StKey.Summon : "move_sana",
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
	super.handle_input(state, interpreter)
	if (state[Enums.StKey.frame] == 3 and interpreter.is_button_down(Enums.InputFlags.DHold)):
		state[Enums.StKey.frame] = 1

	
	if (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*17 # -SGFixed.ONE*15
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*17 # SGFixed.ONE*15
	else:
		state[Enums.StKey.velocity_x] = 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		pass
	elif (event_cause == Enums.Reaction.ForceTagOut):
		exit_state()
	else:
		super.reaction(state, interpreter, event_cause)
