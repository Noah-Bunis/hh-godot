extends KurokamiJumpState

class_name KurokamiJumpFallState

func _init():
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			},
	}

func enter(state: Dictionary) -> void:
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.accel_y] = Util.GRAVITY
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.cancelState] = ""
	state[Enums.StKey.hitCount] = 0
	state[Enums.StKey.comboTime] = 0
	state[Enums.StKey.burst_OK] = true
	state[Enums.StKey.kara_OK] = true
	state[Enums.StKey.ground_bounce] = 0
	state[Enums.StKey.wall_bounce] = 0
	state[Enums.StKey.counterOK] = false
	state[Enums.StKey.hitStopFrame] = -1
	state[Enums.StKey.leftfaceOK] = false
	anim.speed_scale = 1
	anim.stop(true)
	anim.play("JumpFall")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	var speed = Util.fixed_abs(state[Enums.StKey.velocity_x])
	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(speed, 536)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] -= SGFixed.mul(speed, 1536)
