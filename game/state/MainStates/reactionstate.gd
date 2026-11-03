extends State

class_name ReactionState

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
#			Enums.StKey.Hurt1PosX : -655359, Enums.StKey.Hurt1PosY : -28114944,
#			Enums.StKey.Hurt1ScaleX : 276315, Enums.StKey.Hurt1ScaleY : 303423,
			Enums.StKey.Hurt2PosX : 65536, Enums.StKey.Hurt2PosY : -18284544,
			Enums.StKey.Hurt2ScaleX : 630035, Enums.StKey.Hurt2ScaleY : -705015,
			Enums.StKey.Hurt3PosX : 327680, Enums.StKey.Hurt3PosY : -5963776,
			Enums.StKey.Hurt3ScaleX : 630035, Enums.StKey.Hurt3ScaleY : -599184,
			},
	}

func enter(state: Dictionary) -> void:
#	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.cancelState] = ""
	state[Enums.StKey.kara_OK] = true
	state[Enums.StKey.leftfaceOK] = false

	self._player.deprioritize_z_index()
	
	anim.speed_scale = 1
	anim.stop(true)
	anim.play("Idle")

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
		common_idle_transitions(state, interpreter)

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
