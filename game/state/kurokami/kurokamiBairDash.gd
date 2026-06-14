extends KurokamiAirIdleState

class_name KurokamiBackwardAirDashState

func _init():
	endFrame = 10
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 1222078, Enums.StKey.Hurt1ScaleY : 836954,
			},
		4 : {
			Enums.StKey.Summon : "bairdash",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 1222078, Enums.StKey.Hurt1ScaleY : 836954,
		},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.accel_y] = Util.GRAVITY - SGFixed.ONE
	state[Enums.StKey.airDash] -= 1
	anim.stop(true)
	anim.play("BackwardAirDash")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == Util.AIR_DASH_STARTUP):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*28
		state[Enums.StKey.accel_y] = 0
		state[Enums.StKey.velocity_y] = 0
		SyncManager.play_sound("airdash", Global.AirdashSound, {"bus": "Sound"})
	elif (state[Enums.StKey.frame] < Util.AIR_DASH_STARTUP):
		if (state[Enums.StKey.velocity_y] < 0 and state["_pos_y"] >= Util.MIN_IAD_HEIGHT):
			state[Enums.StKey.velocity_y] -= SGFixed.mul(state["_pos_y"] - Util.MIN_IAD_HEIGHT, 8536)
		elif (state[Enums.StKey.frame] == Util.EARLY_AIR_DASH_STARTUP):
			state[Enums.StKey.accel_y] = 0
			state[Enums.StKey.velocity_y] = 0
			if (state[Enums.StKey.velocity_x] > 0):
				state[Enums.StKey.velocity_x] = 0

	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += -SGFixed.mul(state[Enums.StKey.velocity_x], 536)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(state[Enums.StKey.velocity_x], 2836)

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		change_state.call("JumpFall")
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], SGFixed.HALF)
	elif (state[Enums.StKey.frame] == endFrame - 1):
		state[Enums.StKey.leftfaceOK] = true
	elif (boost_OK(state, interpreter)):
		change_state.call("AirBoostCancel")
		state[Enums.StKey.velocity_y] = 0
	elif (state[Enums.StKey.frame] >= Util.AIR_DASH_CANCEL_FRAME):
		if (common_jump_transitions_default(state, interpreter)):
			state[Enums.StKey.velocity_y] = -SGFixed.ONE*8
			state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], SGFixed.HALF)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		_:
			return super.has_property(state,property)

