extends OgaIdleState

class_name OgaRunState

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true, 
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1835008, Enums.StKey.Hurt1PosY : -13697026,
			Enums.StKey.Hurt1ScaleX : 772187, Enums.StKey.Hurt1ScaleY : 1425789,
			},
		3 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true, 
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1835008, Enums.StKey.Hurt1PosY : -13697026,
			Enums.StKey.Hurt1ScaleX : 772187, Enums.StKey.Hurt1ScaleY : 1425789,
		},
	}
	
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.leftfaceOK] = true
	anim.play("Run")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.sync_rate] += 8000
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("skid", Global.SkidSound, {"bus": "Sound"})
		state[Enums.StKey.velocity_x] += SGFixed.ONE*2
	if (state[Enums.StKey.frame] >= 3 and state[Enums.StKey.frame] < 15):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*22, state[Enums.StKey.velocity_x])
		state[Enums.StKey.drag_x] = SGFixed.ONE*1

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.leftfaceOK] = false
	if (state[Enums.StKey.frame] == 20):
		common_idle_transitions(state, interpreter)
	elif (state[Enums.StKey.frame] >= 5): 
		if (not (interpreter.is_button_down(Enums.InputFlags.ADown) or
				interpreter.is_button_down(Enums.InputFlags.BDown) or
				interpreter.is_button_down(Enums.InputFlags.CDown) or
				interpreter.is_button_down(Enums.InputFlags.DDown))):
			if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface])):
				pass
			else:
				common_idle_transitions(state, interpreter)
		else:
			common_idle_transitions(state, interpreter)
	else:
		if (boost_OK(state, interpreter)):
			change_state.call("BoostCancel")

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		_:
			return super.has_property(state,property)
