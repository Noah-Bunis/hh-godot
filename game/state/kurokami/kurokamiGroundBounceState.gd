extends HurtGroundBounceState

class_name KurokamiHurtGroundBounceState

func _init() -> void:
#	HurtSound = preload("res://game/assets/voice/oga/oga_hanase.wav")
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 196607, Enums.StKey.Hurt1PosY : -9830400,
			Enums.StKey.Hurt1ScaleX : 995833, Enums.StKey.Hurt1ScaleY : 994631,
			Enums.StKey.Summon : "knockdowndust",
			},
	}
