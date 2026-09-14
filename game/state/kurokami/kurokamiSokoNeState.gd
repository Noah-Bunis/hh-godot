extends KurokamiAttackState

class_name KurokamiSokoNeState

func _init():
	endFrame = 41
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -19087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			Enums.StKey.Hurt2PosX : 262144, Enums.StKey.Hurt2PosY : -3538944,
			Enums.StKey.Hurt2ScaleX : 783139, Enums.StKey.Hurt2ScaleY : 370037,
			},
		17 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "kurokamiflamepillar",
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -19087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			Enums.StKey.Hurt2PosX : 262144, Enums.StKey.Hurt2PosY : -3538944,
			Enums.StKey.Hurt2ScaleX : 783139, Enums.StKey.Hurt2ScaleY : 370037,
			Enums.StKey.Hurt3PosX : 9562144, Enums.StKey.Hurt3PosY : -25538944,
			Enums.StKey.Hurt3ScaleX : 383139, Enums.StKey.Hurt3ScaleY : 370037,
			}
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("SokoNe")
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.hitStopFrame] = 0

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
