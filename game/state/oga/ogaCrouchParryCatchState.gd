extends CrouchParryCatchState

class_name OgaCrouchParryCatchState

func _init():
	endFrame = Util.PARRY_HIT_STOP
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true, 
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 786432, Enums.StKey.Hurt1PosY : -16318464,
			Enums.StKey.Hurt1ScaleX : 885503, Enums.StKey.Hurt1ScaleY : 1619164,
			},
	}



func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (level_1_OK(state) and 
				interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "Snapback"
		elif (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "HeavyDP"
		elif (level_2_OK(state) and 
				interpreter.special_input_button(Enums.SpecialInput.M632146, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "SlashMode"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "LightRiderKick"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "MediumRiderKick"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "HeavyRiderKick"
		elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "LightDP"
		elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "MediumDP"

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand6C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand6A"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch3C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch2C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Crouch2B"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Crouch2A"
		elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "StandcB"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"
