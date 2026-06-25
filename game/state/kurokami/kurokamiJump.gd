extends KurokamiAirIdleState

class_name KurokamiJumpState

const JUMP_SPEED := SGFixed.ONE*-55

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = JUMP_SPEED
	state[Enums.StKey.accel_y] = Util.GRAVITY
	anim.play("Jump")
	SyncManager.play_sound("jump", Global.JumpSound, {"bus": "Sound"})

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	common_jump_transitions_default(state, interpreter)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return true
		Enums.StateProperty.GroundThrowOK:
			return false
		_:
			return super.has_property(state,property)
