extends SubaruAirAssistCallState

class_name SubaruAirAssistCallSuperState

func _init():
	CallSound = preload("res://game/assets/voice/subaru/SubaruOra.wav")
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
			Enums.StKey.Summon : "airassistSuper",
			},
	}

func battery_meter(state: Dictionary) -> void:
	state[Enums.StKey.assist_meter] -= Util.ASSIST_STOCK*2
	state[Enums.StKey.sync_rate] = SGFixed.mul(state[Enums.StKey.sync_rate], 5536)
