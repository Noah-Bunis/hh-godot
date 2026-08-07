extends IdleState

class_name HatoIdleState

func _init():
	endFrame = 60
	anim_data = {
		0 : { 
			Enums.StKey.Hurt1Disable : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1PosX : -6291454, Enums.StKey.Hurt1PosY : -11730944,
			Enums.StKey.Hurt1ScaleX : 819342, Enums.StKey.Hurt1ScaleY : 1874245,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.drag_x] = Util.ICE_FRICTION

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and
		not (interpreter.is_button_down(Enums.InputFlags.AHold) or
		interpreter.is_button_down(Enums.InputFlags.BHold) or
		interpreter.is_button_down(Enums.InputFlags.CHold) or
		interpreter.is_button_down(Enums.InputFlags.DHold))):
		pass
	else:
		common_idle_transitions(state, interpreter)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.StrikeHurt):
		
		change_state.call("HurtStand")
	elif (event_cause == Enums.Reaction.BlockHurt):
		
		change_state.call("HurtStand")
	elif (event_cause == Enums.Reaction.JustBlockHurt):
		
		change_state.call("HurtStand")
	elif (event_cause == Enums.Reaction.ThrowHurt):
		change_state.call("HurtStand")
	elif (event_cause == Enums.Reaction.LaunchHurt):
		
		change_state.call("HurtStand")

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		Enums.StateProperty.GroundThrowOK:
			return false
		_:
			return false

func pilot_level_2_OK(state:Dictionary) -> bool:
	return state["pilot_meter"] >= Util.LEVEL_ONE_SUPER

func common_idle_transitions(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (pilot_level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CUp, state[Enums.StKey.leftface])):
		change_state.call("HatoCards")
	elif (interpreter.is_button_down(Enums.InputFlags.CUp)):
		change_state.call("Hato5C")
	elif (interpreter.is_button_down(Enums.InputFlags.BUp)):
		change_state.call("Hato5B")
	elif (interpreter.is_button_down(Enums.InputFlags.AUp)):
		change_state.call("Hato5A")
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		change_state.call("ForwardWalk")
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		change_state.call("BackwardWalk")
	else:
		change_state.call("Stand")
