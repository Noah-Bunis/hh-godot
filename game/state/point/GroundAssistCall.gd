extends AttackState

class_name GroundAssistCallState

var CallSound

func _init():
	endFrame = Util.BASE_ASSIST_RECOVERY
	CallSound = preload("res://game/assets/voice/mio/MioAssistCall.wav")
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14471104,
			Enums.StKey.Hurt1ScaleX : 622078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		1 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -14471104,
			Enums.StKey.Hurt1ScaleX : 622078, Enums.StKey.Hurt1ScaleY : 1436954,
			Enums.StKey.Summon : "assist",
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.drag_x] = 85536
	state[Enums.StKey.hitStopFrame] = 0
	state[Enums.StKey.throw_protect] = 0
	anim.play("GroundAssist")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.old_sync_rate] = state[Enums.StKey.sync_rate]
		battery_meter(state)
		SyncManager.play_sound("Call", CallSound, {"bus": "Voice"})
	super.physics_tick(state)

func battery_meter(state: Dictionary) -> void:
	state[Enums.StKey.super_meter] += SGFixed.ONE*1500
	state[Enums.StKey.assist_meter] -= Util.ASSIST_STOCK
	state[Enums.StKey.sync_rate] = SGFixed.mul(state[Enums.StKey.sync_rate], 35536)

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.CDown, state[Enums.StKey.leftface])):
			change_state.call("Super1")

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)
	if (state[Enums.StKey.frame] > 2 and state[Enums.StKey.frame] >= Util.sync_rate_quality(endFrame, state[Enums.StKey.old_sync_rate])):
		common_idle_transitions(state, interpreter)

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.frame] > 1):
		super.meter_cancel(state, interpreter)
	if (burst_OK(state, interpreter)):
		change_state.call("Burst")

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
