extends SuicopathAttackState

class_name SuicopathStandParryWhiffState

const ParryWhiffSound = Global.AirTechSound

func _init():
	endFrame = 40
	
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
#			Enums.StKey.Hurt1PosX : -655359, Enums.StKey.Hurt1PosY : -28114944,
#			Enums.StKey.Hurt1ScaleX : 276315, Enums.StKey.Hurt1ScaleY : 303423,
			Enums.StKey.Hurt2PosX : 1572864, Enums.StKey.Hurt2PosY : -24641536,
			Enums.StKey.Hurt2ScaleX : 1185327, Enums.StKey.Hurt2ScaleY : 1324647,
			Enums.StKey.Hurt3PosX : -1441792, Enums.StKey.Hurt3PosY : -5898240,
			Enums.StKey.Hurt3ScaleX : 1098168, Enums.StKey.Hurt3ScaleY : 626962,
			Enums.StKey.counterOK : true,
			},
		Util.PARRY_WINDOW : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "ParryWhiff",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			},
	}
# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.hitstun] = 0
	anim.play("AngelStandParry")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	if (state[Enums.StKey.frame] == Util.PARRY_WINDOW):
		SyncManager.play_sound("parrywhiff", ParryWhiffSound, {"bus": "Sound"})
		state[Enums.StKey.super_meter] -= Util.PARRY_METER_COST
	super.physics_tick(state)

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		common_idle_transitions(state, interpreter)
	elif (state[Enums.StKey.frame] == endFrame - 1):
		state[Enums.StKey.leftfaceOK] = true
	if (state[Enums.StKey.frame] == 0):
		if (state[Enums.StKey.kara_OK]):
			# Kara Cancel section
			state[Enums.StKey.kara_OK] = false
		state[Enums.StKey.leftfaceOK] = false
		if (burst_OK(state, interpreter)):
			change_state.call("AngelBurst")
	
	if (state[Enums.StKey.hitStopFrame] == 0 and not state[Enums.StKey.cancelState].is_empty()):
		# is out of hitstop, and cancellable
		# delay cancel state
		anim.stop(true)
		change_state.call(state[Enums.StKey.cancelState])
	
	gatling_cancel(state, interpreter)
	special_cancel(state, interpreter)
	jump_cancel(state, interpreter)
	meter_cancel(state, interpreter)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.ParryHurt):
		change_state.call("AngelStandParryCatch")
	else:
		super.reaction(state, interpreter, event_cause)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.HighParry:
			return state[Enums.StKey.frame] < Util.PARRY_WINDOW
		_:
			return super.has_property(state,property)
