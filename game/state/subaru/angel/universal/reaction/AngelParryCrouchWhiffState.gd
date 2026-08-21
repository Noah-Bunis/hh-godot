extends AngelAttackState

class_name AngelCrouchParryWhiffState

const ParryWhiffSound = Global.AirTechSound

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			#
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 786432, Enums.StKey.Hurt1PosY : -8454144,
			Enums.StKey.Hurt1ScaleX : 305194, Enums.StKey.Hurt1ScaleY : 951940,
			Enums.StKey.Hurt2PosX : 917504, Enums.StKey.Hurt2PosY : -7208960,
			Enums.StKey.Hurt2ScaleX : 668398, Enums.StKey.Hurt2ScaleY : -793234,
			Enums.StKey.Hurt3PosX : 4390912, Enums.StKey.Hurt3PosY : -13172735,
			Enums.StKey.Hurt3ScaleX : 302121, Enums.StKey.Hurt3ScaleY : -600552,
			Enums.StKey.counterOK : true,
			},
		Util.PARRY_WINDOW : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			
			Enums.StKey.Summon : "ParryWhiff",
			},
	}
# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.hitstun] = 0
	anim.play("AngelCrouchParry")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	if (state[Enums.StKey.frame] == Util.PARRY_WINDOW):
		SyncManager.play_sound("parrywhiff", ParryWhiffSound, {"bus": "Sound"})
		state[Enums.StKey.super_meter] -= Util.PARRY_METER_COST
	super.physics_tick(state)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.ParryHurt):
		change_state.call("AngelCrouchParryCatch")
	else:
		super.reaction(state, interpreter, event_cause)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.LowParry:
			return state[Enums.StKey.frame] < Util.PARRY_WINDOW
		_:
			return super.has_property(state,property)
