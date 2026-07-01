extends AngelAttackState

class_name AngelAssistGuardCancelState

var CallSound

func _init():
	endFrame = Util.BASE_ASSIST_RECOVERY
	CallSound = Global.AirTechSound
	anim_data = {
		0 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			},
		2 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Summon : "assistGuardCancel",
			},
		13 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 327680, Enums.StKey.Hurt1PosY : -22085634,
			Enums.StKey.Hurt1ScaleX : 257090, Enums.StKey.Hurt1ScaleY : 604574,
			Enums.StKey.Hurt2PosX : 131072, Enums.StKey.Hurt2PosY : -14352384,
			Enums.StKey.Hurt2ScaleX : 401098, Enums.StKey.Hurt2ScaleY : -853100,
			Enums.StKey.Hurt3PosX : 262144, Enums.StKey.Hurt3PosY : -3538944,
			Enums.StKey.Hurt3ScaleX : 783139, Enums.StKey.Hurt3ScaleY : -370037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.hitstun] = 0
	state[Enums.StKey.drag_x] = 85536
	state[Enums.StKey.hitStopFrame] = 0
	anim.play("AngelGroundAssist")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	if (state[Enums.StKey.frame] == 2):
		state[Enums.StKey.assist_meter] -= (Util.ASSIST_STOCK*2)
		state[Enums.StKey.super_meter] -= Util.LEVEL_ONE_SUPER
		state[Enums.StKey.sync_rate] = SGFixed.mul(state[Enums.StKey.sync_rate], 5536)
		SyncManager.play_sound("Call", CallSound, {"bus": "Voice"})
	super.physics_tick(state)

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
