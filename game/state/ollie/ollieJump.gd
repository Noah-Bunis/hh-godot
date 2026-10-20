extends "res://game/state/ollie/mainstates/ollieAirIdleState.gd"

class_name OllieJumpState

const JUMP_SPEED := SGFixed.ONE*-50

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 65536, Enums.StKey.Hurt1PosY : -15597568,
			Enums.StKey.Hurt1ScaleX : 638999, Enums.StKey.Hurt1ScaleY : 1587430,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = JUMP_SPEED
	state[Enums.StKey.accel_y] = Util.OLLIE_GRAVITY
	anim.play("Jump")
	SyncManager.play_sound("jump", Global.JumpSound, {"bus": "Sound"})

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface])):
			state[Enums.StKey.velocity_y] = SGFixed.mul(state[Enums.StKey.velocity_y], 49536)
	common_jump_transitions_default(state, interpreter)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return true
		Enums.StateProperty.GroundThrowOK:
			return false
		_:
			return super.has_property(state,property)
