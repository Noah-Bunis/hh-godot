extends KurokamiGroundAssistCallState

class_name KurokamiGroundAssistCall2State

func _init():
	CallSound = preload("res://game/assets/voice/flayon/mxf_thats_right.wav")
	endFrame = Util.BASE_ASSIST_RECOVERY
	
	anim_data = {
		0: {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14471104,
			Enums.StKey.Hurt1ScaleX : 622078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		1 : {
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14471104,
			Enums.StKey.Hurt1ScaleX : 622078, Enums.StKey.Hurt1ScaleY : 1436954,
			Enums.StKey.Summon : "assist2",
			Enums.StKey.counterOK : false,
			},
	}
