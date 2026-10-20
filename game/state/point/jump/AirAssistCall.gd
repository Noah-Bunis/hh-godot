extends AirAttackState

class_name AirAssistCallState

var CallSound
func _init():
	endFrame = Util.BASE_AIR_ASSIST_RECOVERY
	CallSound = preload("res://game/assets/voice/mio/MioAssistCall.wav")
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -17000000,
			Enums.StKey.Hurt1ScaleX : 1005536, Enums.StKey.Hurt1ScaleY : 1005536,
			},
		1 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -17000000,
			Enums.StKey.Hurt1ScaleX : 1005536, Enums.StKey.Hurt1ScaleY : 1005536,
			Enums.StKey.Summon : "airassist",
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.hitStopFrame] = 0
	state[Enums.StKey.throw_protect] = 0
	anim.play("AirAssist")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], 48536)
		state[Enums.StKey.velocity_y] = Util.fixed_min(SGFixed.mul(state[Enums.StKey.velocity_y], 45536), SGFixed.ONE*-20)
		state[Enums.StKey.accel_y] = 101072
		state[Enums.StKey.old_sync_rate] = state[Enums.StKey.sync_rate]
		battery_meter(state)
		SyncManager.play_sound("call", CallSound, {"bus": "Voice"})
	elif (state[Enums.StKey.frame] == 23):
		state[Enums.StKey.accel_y] = Util.GRAVITY

func battery_meter(state: Dictionary) -> void:
	state[Enums.StKey.super_meter] += SGFixed.ONE*1500
	state[Enums.StKey.assist_meter] -= Util.ASSIST_STOCK
	state[Enums.StKey.sync_rate] = SGFixed.mul(state[Enums.StKey.sync_rate], 35536)

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)
	if (state[Enums.StKey.frame] > 2 and state[Enums.StKey.frame] >= Util.sync_rate_quality(endFrame, state[Enums.StKey.old_sync_rate])):
		common_jump_transitions(state, interpreter)

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.frame] > 1):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AirBoostCancel"
		elif (state[Enums.StKey.frame] >= Util.ASSIST_CANCEL_LOCKOUT):
			super.meter_cancel(state, interpreter)
	if (burst_OK(state, interpreter)):
		change_state.call("Burst")

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass


func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand and state[Enums.StKey.frame] <= 2):
		pass
	else:
		super.reaction(state, interpreter, event_cause)
