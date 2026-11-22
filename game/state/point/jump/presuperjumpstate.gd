extends IdleState

class_name PreSuperJumpState

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -393216, Enums.StKey.Hurt1PosY : -16449537,
			Enums.StKey.Hurt1ScaleX : 536711, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : -262142, Enums.StKey.Hurt2PosY : -3014656,
			Enums.StKey.Hurt2ScaleX : 924253, Enums.StKey.Hurt2ScaleY : -367041,
			Enums.StKey.Hurt3PosX : -458752, Enums.StKey.Hurt3PosY : -9568257,
			Enums.StKey.Hurt3ScaleX : 608053, Enums.StKey.Hurt3ScaleY : -670102,
			},
		4 : {
			Enums.StKey.Summon : "superjumpdust",
			Enums.StKey.Hurt1Disable : false,
			Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt3Disable : false,
		},
	}
	endFrame = 4  # endFrame + 1 = X frame jump squat

func enter(state: Dictionary) -> void:
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.cancelState] = ""
	state[Enums.StKey.hitCount] = 0
	state[Enums.StKey.comboTime] = 0
	state[Enums.StKey.burst_OK] = true
	state[Enums.StKey.kara_OK] = true
	state[Enums.StKey.ground_bounce] = 0
	state[Enums.StKey.wall_bounce] = 0
	state[Enums.StKey.counterOK] = false
	state[Enums.StKey.hitStopFrame] = -1
	state[Enums.StKey.leftfaceOK] = false
	state[Enums.StKey.doubleJump] -= 1
	anim.stop(true)
	anim.play("PreJump")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	anim.play()

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], 18768)
		change_state.call("SuperJump")
	
	special_cancel(state, interpreter)
	meter_cancel(state, interpreter)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		Enums.StateProperty.GroundThrowOK:
			return false
		_:
			return false
