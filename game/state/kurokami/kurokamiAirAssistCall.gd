extends AirAssistCallState

class_name KurokamiAirAssistCallState

func _init():
	CallSound = preload("res://game/assets/voice/flayon/mxf_thats_right.wav")
	endFrame = Util.BASE_AIR_ASSIST_RECOVERY
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -17000000,
			Enums.StKey.Hurt1ScaleX : 1005536, Enums.StKey.Hurt1ScaleY : 1005536,
			},
		1 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -17000000,
			Enums.StKey.Hurt1ScaleX : 1005536, Enums.StKey.Hurt1ScaleY : 1005536,
			Enums.StKey.Summon : "airassist",
			},
	}

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (level_2_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("AirStomp")
