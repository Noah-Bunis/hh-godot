extends AngelAirAttackState

class_name AngelAirStarBallState

func _init():
	endFrame = 12
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			},
		8 : {
			Enums.StKey.Summon : "subarustarball",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 1572864, Enums.StKey.Hurt3PosY : -10485762,
			Enums.StKey.Hurt3ScaleX : 554342, Enums.StKey.Hurt3ScaleY : -1021119,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("AngelLightHadoken")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.hitStopFrame] = 0
	elif (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], SGFixed.HALF)
		state[Enums.StKey.velocity_y] = SGFixed.ONE*-10
		state[Enums.StKey.accel_y] = SGFixed.ONE
	elif (state[Enums.StKey.frame] == 23):
		state[Enums.StKey.accel_y] = Util.GRAVITY

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
