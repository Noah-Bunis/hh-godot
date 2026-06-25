extends KurokamiAirTechState

class_name KurokamiBackwardAirTechState

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.accel_x] = -SGFixed.ONE*3

func physics_tick(state: Dictionary) -> void:
	if (state[Enums.StKey.frame] == 4):
		SyncManager.play_sound("airtech", Global.AirTechSound, {"bus": "Sound"})
	elif (state[Enums.StKey.frame] == 8):
		state[Enums.StKey.accel_y] = Util.GRAVITY
	elif (state[Enums.StKey.frame] == endFrame - 5):
		state[Enums.StKey.accel_x] = 0
	elif (state[Enums.StKey.frame] == endFrame - 1):
		state[Enums.StKey.drag_x] = Util.SLIPPERY_FRICTION

