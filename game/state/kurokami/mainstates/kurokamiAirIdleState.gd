extends AirState

class_name KurokamiAirIdleState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.kara_OK] = true

#func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	#if (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface]) and
		#not (interpreter.is_button_down(Enums.InputFlags.AHold) or
		#interpreter.is_button_down(Enums.InputFlags.BHold) or
		#interpreter.is_button_down(Enums.InputFlags.CHold) or
		#interpreter.is_button_down(Enums.InputFlags.DHold))):
		#pass
	#else:
		#common_idle_transitions(state, interpreter)

