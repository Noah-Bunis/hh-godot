extends WakeupState

class_name KanataWakeupState

func _init():
	endFrame = 19
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,
			Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt3Disable : true,
			},
	}