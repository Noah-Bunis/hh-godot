extends OgaAttackState

class_name OgaCrouchParryWhiffState

const ParryWhiffSound = Global.AirTechSound

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 786432, Enums.StKey.Hurt1PosY : -16318464,
			Enums.StKey.Hurt1ScaleX : 885503, Enums.StKey.Hurt1ScaleY : 1619164,
			Enums.StKey.counterOK : true,
			},
		Util.PARRY_WINDOW : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 786432, Enums.StKey.Hurt1PosY : -16318464,
			Enums.StKey.Hurt1ScaleX : 885503, Enums.StKey.Hurt1ScaleY : 1619164,
			Enums.StKey.Summon : "ParryWhiff",
			},
	}
# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("CrouchParry")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	if (state[Enums.StKey.frame] == Util.PARRY_WINDOW):
		SyncManager.play_sound("parrywhiff", ParryWhiffSound, {"bus": "Sound"})
		state[Enums.StKey.super_meter] -= Util.PARRY_METER_COST
	super.physics_tick(state)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.ParryHurt):
		change_state.call("CrouchParryCatch")
	else:
		super.reaction(state, interpreter, event_cause)

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.LowParry:
			return state[Enums.StKey.frame] < Util.PARRY_WINDOW
		_:
			return super.has_property(state,property)
