extends GroundAssistCallState

class_name MioGroundAssistCallState

func _init():
	endFrame = Util.BASE_ASSIST_RECOVERY
	CallSound = preload("res://game/assets/voice/mio/MioAssistCall.wav")
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14471104,
			Enums.StKey.Hurt1ScaleX : 622078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		1 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14471104,
			Enums.StKey.Hurt1ScaleX : 622078, Enums.StKey.Hurt1ScaleY : 1436954,
			Enums.StKey.Summon : "assist",
			},
	}

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M41236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("Super1")