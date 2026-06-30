extends FlayonFlightBaseState

class_name FlayonFlightUpwardAirdashState

func _init():
	endFrame = 12
	
	anim_data = {
		0 : {
			Enums.StKey.Summon : "jumpdust",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("FlightUpwardAirdash")
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.super_meter] -= SGFixed.ONE*700

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.super_meter] -= Util.FLIGHT_METER_DRAIN
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = 0
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*27
	elif (state[Enums.StKey.frame] == 2):
		state[Enums.StKey.hitStopFrame] = 0
		SyncManager.play_sound("airdash", Global.AirdashSound, {"bus": "Sound"})
	
func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	super.special_cancel(state,interpreter)
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_air_dashing_four_way(Enums.Numpad.N8, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = ""
