extends AirAssistCallState

class_name OgaAirAssistCallState

func _init():
	CallSound = preload("res://game/assets/voice/oga/oga_hmph.wav")
	endFrame = Util.BASE_AIR_ASSIST_RECOVERY
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt2PosX : -327680, Enums.StKey.Hurt2PosY : -17170432,
			Enums.StKey.Hurt2ScaleX : 896391, Enums.StKey.Hurt2ScaleY : -1190856,
			},
		1 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt2PosX : -327680, Enums.StKey.Hurt2PosY : -17170432,
			Enums.StKey.Hurt2ScaleX : 896391, Enums.StKey.Hurt2ScaleY : -1190856,
			Enums.StKey.Summon : "airassist",
			},
	}
