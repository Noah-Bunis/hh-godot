extends OgaAirParryWhiffState

class_name OgaRedAirParryWhiffState

func _init():
	endFrame = 100
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1966080, Enums.StKey.Hurt1PosY : -34799612,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : 4063232, Enums.StKey.Hurt2PosY : -24182784,
			Enums.StKey.Hurt2ScaleX : 896391, Enums.StKey.Hurt2ScaleY : -1190856,
			Enums.StKey.Hurt3PosX : 2949120, Enums.StKey.Hurt3PosY : -14483456,
			Enums.StKey.Hurt3ScaleX : 519088, Enums.StKey.Hurt3ScaleY : 1416473,
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "RedParryFlash",
			},
		Util.RED_PARRY_WINDOW - 1 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1966080, Enums.StKey.Hurt1PosY : -34799612,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : 4063232, Enums.StKey.Hurt2PosY : -24182784,
			Enums.StKey.Hurt2ScaleX : 896391, Enums.StKey.Hurt2ScaleY : -1190856,
			Enums.StKey.Hurt3PosX : 2949120, Enums.StKey.Hurt3PosY : -14483456,
			Enums.StKey.Hurt3ScaleX : 519088, Enums.StKey.Hurt3ScaleY : 1416473,
			Enums.StKey.Summon : "ParryWhiff",
			},
	}

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.RedParry:
			return true
		Enums.StateProperty.LowParry:
			return state[Enums.StKey.frame] < Util.RED_PARRY_WINDOW - 1
		Enums.StateProperty.HighParry:
			return state[Enums.StKey.frame] < Util.RED_PARRY_WINDOW - 1
		_:
			return super.has_property(state,property)

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		common_jump_transitions(state, interpreter)
	if (state[Enums.StKey.frame] == 0):
		if (state[Enums.StKey.kara_OK]):
			# Kara Cancel section
			state[Enums.StKey.kara_OK] = false
		if (burst_OK(state, interpreter)):
			change_state.call("Burst")
	if (state[Enums.StKey.hitStopFrame] == 0 and not state[Enums.StKey.cancelState].is_empty()):
		# is out of hitstop, and cancellable
		# delay cancel state
		anim.stop(true)
		change_state.call(state[Enums.StKey.cancelState])
	
	special_cancel(state, interpreter)
	gatling_cancel(state, interpreter)
	jump_cancel(state, interpreter)
	meter_cancel(state, interpreter)

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
