extends AirState

class_name AirReactionState

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 196607, Enums.StKey.Hurt1PosY : -9830400,
			Enums.StKey.Hurt1ScaleX : 995833, Enums.StKey.Hurt1ScaleY : 994631,
			Enums.StKey.Hurt2PosX : 196607, Enums.StKey.Hurt2PosY : -9830400,
			Enums.StKey.Hurt2ScaleX : 995833, Enums.StKey.Hurt2ScaleY : 994631,
			Enums.StKey.Hurt3PosX : 196607, Enums.StKey.Hurt3PosY : -9830400,
			Enums.StKey.Hurt3ScaleX : 995833, Enums.StKey.Hurt3ScaleY : 994631,
			},
	}

func enter(state: Dictionary) -> void:
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.accel_y] = Util.gravity_scaling(Util.JUGGLE_GRAVITY, state[Enums.StKey.comboTime])
	state[Enums.StKey.cancelState] = ""
	state[Enums.StKey.leftfaceOK] = false
	state[Enums.StKey.hitstun] += Util.BONUS_JUGGLE_HITSTUN

	self._player.deprioritize_z_index()

	anim.speed_scale = 1
	anim.stop(true)
	anim.play("JumpFall")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.comboTime] += 1
	if (state[Enums.StKey.hitStopFrame] == 1):
		# last frame and transition out of hitstop
		if (not state[Enums.StKey.cancelState].is_empty()):
			change_state.call(state[Enums.StKey.cancelState])
	elif (state[Enums.StKey.hitStopFrame] <= 0):
		# business as usual
		state[Enums.StKey.hitstun] -= 1

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.hitstun] <= 0):
		state[Enums.StKey.throw_protect] = Util.THROW_PROTECT_FRAME
		air_tech(state, interpreter)

	if (state[Enums.StKey.hitStopFrame] == 0 and not state[Enums.StKey.cancelState].is_empty()):
		# is out of hitstop, and cancellable
		# delay cancel state
		anim.stop(true)
		change_state.call(state[Enums.StKey.cancelState])
	
	meter_cancel(state, interpreter)

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (burst_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "Burst"

func air_tech(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (interpreter.is_button_down(Enums.InputFlags.AHold) or
			interpreter.is_button_down(Enums.InputFlags.BHold) or
			interpreter.is_button_down(Enums.InputFlags.CHold) or
			interpreter.is_button_down(Enums.InputFlags.DHold)):
		if (interpreter.is_low_blocking(state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface]) or 
				interpreter.is_holding_a_direction(Enums.Numpad.N5, state[Enums.StKey.leftface])):
			change_state.call("AirTech")
		elif (interpreter.is_blocking(state[Enums.StKey.leftface])):
			change_state.call("BackAirTech")
		elif (interpreter.is_blocking(not state[Enums.StKey.leftface])):
			change_state.call("ForwardAirTech")
		else:
			change_state.call("AirTech")
			printerr("Air Teched How??")
