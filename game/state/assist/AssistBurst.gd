extends AssistAirAttackState

class_name AssistBurstState

func _init():
	endFrame = 240
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		1 : {
			Enums.StKey.Summon : "burst",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		13 : { 
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -18087934,
			Enums.StKey.Hit1ScaleX : 2557910, Enums.StKey.Hit1ScaleY : 1982050,
			Enums.StKey.Hit2PosX : 0, Enums.StKey.Hit2PosY : -17956864,
			Enums.StKey.Hit2ScaleX : 1786620, Enums.StKey.Hit2ScaleY : 2721142,
			Enums.StKey.attack_damage: 0,
			Enums.StKey.chip_damage: 0,
			Enums.StKey.min_damage: 0,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*45,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 0,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.counter_launch_dir_y : -SGFixed.ONE*45,
			Enums.StKey.hitstun: 30,
			},
		24 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.drag_x] = Util.FD_FRICTION
	state[Enums.StKey.cancelState] = ""
	state[Enums.StKey.leftfaceOK] = true
	state[Enums.StKey.hitStopFrame] = 0 # whiff cancel OK
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.hitstun] = 0
	anim.stop(true)
	anim.play("Burst")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		state[Enums.StKey.velocity_x] = 0
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 50
		state[Enums.StKey.accel_y] = Util.GRAVITY
	elif (state[Enums.StKey.frame] == 10):
		state[Enums.StKey.velocity_y] = 0
		state[Enums.StKey.accel_y] = 0
	elif (state[Enums.StKey.frame] == 44):
		state[Enums.StKey.accel_y] = Util.GRAVITY

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		change_state.call("AssistAirExit")

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.AirThrowOK:
			return true
		Enums.StateProperty.GroundThrowOK:
			return false
		Enums.StateProperty.BlockingOK:
			return false
		_:
			return super.has_property(state,property)

func tag_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state["tag_attack"] == 12 or state["tag_attack"] == 13):
		change_state.call("AssistBurst")
