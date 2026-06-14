extends KurokamiAirAttackState

class_name KurokamiFlightExitState

func _init():
	endFrame = 2
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Flight")
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.accel_x] = 0
	if (state[Enums.StKey.velocity_y] >= -SGFixed.ONE*20):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*20
	else:
		state[Enums.StKey.velocity_y] = SGFixed.mul(state[Enums.StKey.velocity_y], 35536)
	state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], 35536)

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		pass
	else:
		super.reaction(state, interpreter, event_cause)

