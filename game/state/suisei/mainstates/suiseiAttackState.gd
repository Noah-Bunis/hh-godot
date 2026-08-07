extends AttackState

class_name SuiseiAttackState

const WhiffSound = preload("res://game/assets/sfx/Whiff.wav")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("whiff", WhiffSound, {"bus": "Sound"})

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.super_jump()):
			if (interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "ForwardPreSuperJump"
			elif (interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "PreSuperJump"
			elif (interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "BackwardPreSuperJump"
		elif (interpreter.is_tapping_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "ForwardPreJump"
		elif (interpreter.is_tapping_direction(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "PreJump"
		elif (interpreter.is_tapping_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "BackwardPreJump"

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "YoruMatsuyo"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "LightYoruMatsuyo"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "CaramelThrust"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "CaramelThrust"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AngelInstall"

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand6A"
		elif (state[Enums.StKey.distance_to_opponent] <= Util.PROXY_NORMAL and
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "StandcB"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"
