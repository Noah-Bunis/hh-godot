extends AirAssistCallState

class_name MioAirAssistCallSuperState

func _init():
	endFrame = Util.BASE_ASSIST_RECOVERY
	CallSound = preload("res://game/assets/voice/mio/MioAssistCall.wav")
	
	anim_data = {
		0: {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
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
			Enums.StKey.Summon : "airassistSuper",
			},
	}

func battery_meter(state: Dictionary) -> void:
	state[Enums.StKey.assist_meter] -= Util.ASSIST_STOCK*2
	state[Enums.StKey.sync_rate] = SGFixed.mul(state[Enums.StKey.sync_rate], 5536)
