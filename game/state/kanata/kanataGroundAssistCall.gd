extends GroundAssistCallState

class_name KanataGroundAssistCallState

func _init():
	CallSound = preload("res://game/assets/voice/kanata/amk_Hey~.wav")
	endFrame = Util.BASE_ASSIST_RECOVERY
	
	anim_data = {
		0: {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		1 : {
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			Enums.StKey.Summon : "assist",
			Enums.StKey.counterOK : false,
			},
	}

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (level_3_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M63214, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("KanataSuperFiftyKGWhiff")
		elif (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("KanataWingStanceC")