extends GroundAssistCallState

class_name OgaGroundAssistCallState

func _init():
	CallSound = preload("res://game/assets/voice/oga/oga_hmph.wav")
	endFrame = Util.BASE_ASSIST_RECOVERY
	
	anim_data = {
		0: {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -3801087, Enums.StKey.Hurt1PosY : -4849664,
			Enums.StKey.Hurt1ScaleX : 1319752, Enums.StKey.Hurt1ScaleY : 585786,
			Enums.StKey.Hurt2PosX : -131072, Enums.StKey.Hurt2PosY : -13500417,
			Enums.StKey.Hurt2ScaleX : 899246, Enums.StKey.Hurt2ScaleY : 941131,
			Enums.StKey.Hurt3PosX : -6422528, Enums.StKey.Hurt3PosY : -25952256,
			Enums.StKey.Hurt3ScaleX : 891698, Enums.StKey.Hurt3ScaleY : 376207,
			},
		1 : {
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -3801087, Enums.StKey.Hurt1PosY : -4849664,
			Enums.StKey.Hurt1ScaleX : 1319752, Enums.StKey.Hurt1ScaleY : 585786,
			Enums.StKey.Hurt2PosX : -131072, Enums.StKey.Hurt2PosY : -13500417,
			Enums.StKey.Hurt2ScaleX : 899246, Enums.StKey.Hurt2ScaleY : 941131,
			Enums.StKey.Hurt3PosX : -6422528, Enums.StKey.Hurt3PosY : -25952256,
			Enums.StKey.Hurt3ScaleX : 891698, Enums.StKey.Hurt3ScaleY : 376207,
			Enums.StKey.Summon : "assist",
			Enums.StKey.counterOK : false,
			},
	}

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("Snapback")
		elif (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("HeavyDP")
		elif (level_2_OK(state) and 
				interpreter.special_input_button(Enums.SpecialInput.M632146, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("SlashMode")
	if (state[Enums.StKey.frame] >= 5):
		if (assist_ok(state, interpreter)):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "GroundAssistCall"
