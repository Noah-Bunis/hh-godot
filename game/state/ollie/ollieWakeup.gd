extends WakeupState

class_name OllieWakeupState

func _init():
	endFrame = 25
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,
			Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 196607, Enums.StKey.Hurt1PosY : -9830400,
			Enums.StKey.Hurt1ScaleX : 995833, Enums.StKey.Hurt1ScaleY : 994631,
			Enums.StKey.Hurt2PosX : 196607, Enums.StKey.Hurt2PosY : -9830400,
			Enums.StKey.Hurt2ScaleX : 995833, Enums.StKey.Hurt2ScaleY : 994631,
			Enums.StKey.Hurt3PosX : 196607, Enums.StKey.Hurt3PosY : -9830400,
			Enums.StKey.Hurt3ScaleX : 995833, Enums.StKey.Hurt3ScaleY : 994631,
			# Enums.StKey.Hit1PosX : 2025, Enums.StKey.Hit1PosY : -13828096,
			},
	}
