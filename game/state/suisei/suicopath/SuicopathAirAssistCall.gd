extends SuicopathAirAttackState

class_name SuicopathAirAssistCallState

var CallSound = preload("res://game/assets/voice/suisei/sui_mama.wav")
func _init():
	endFrame = Util.BASE_AIR_ASSIST_RECOVERY
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1769472, Enums.StKey.Hurt1PosY : -15728636,
			Enums.StKey.Hurt1ScaleX : 1142691, Enums.StKey.Hurt1ScaleY : 1549402,
			},
		1 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1769472, Enums.StKey.Hurt1PosY : -15728636,
			Enums.StKey.Hurt1ScaleX : 1142691, Enums.StKey.Hurt1ScaleY : 1549402,
			Enums.StKey.Summon : "airassist",
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.hitStopFrame] = 0
	state[Enums.StKey.throw_protect] = 0
	anim.play("AngelAirAssist")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], 48536)
		state[Enums.StKey.velocity_y] = Util.fixed_min(SGFixed.mul(state[Enums.StKey.velocity_y], 25536), SGFixed.ONE*-20)
		state[Enums.StKey.accel_y] = 101072
		state[Enums.StKey.old_sync_rate] = state[Enums.StKey.sync_rate]
		battery_meter(state)
		SyncManager.play_sound("SuicopathVoice", CallSound, {"bus": "Voice"})
		SyncManager.play_sound("SuicopathVoiceReverb", CallSound, {"bus": "ReverbVoice"})
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

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.frame] > 1):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AngelAirBoostCancel"
		elif (state[Enums.StKey.frame] >= Util.ASSIST_CANCEL_LOCKOUT):
			super.meter_cancel(state, interpreter)
	if (burst_OK(state, interpreter)):
		change_state.call("AngelBurst")

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
