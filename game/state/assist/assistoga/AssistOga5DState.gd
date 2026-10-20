extends AssistAirAttackState

class_name AssistOga5DState

func _init():
	endFrame = 70
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -8337728,
			Enums.StKey.Hit1ScaleX : 486985, Enums.StKey.Hit1ScaleY : 1074037,
			},
		6 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,
#			Enums.StKey.Hurt1PosX : 10354688, Enums.StKey.Hurt1PosY : -27000832,
#			Enums.StKey.Hurt1ScaleX : 2058119, Enums.StKey.Hurt1ScaleY : -699443,
#			Enums.StKey.Hurt2PosX : -589824, Enums.StKey.Hurt2PosY : -28246016,
#			Enums.StKey.Hurt2ScaleX : 826534, Enums.StKey.Hurt2ScaleY : -679323,
#			Enums.StKey.Hurt3PosX : -2490366, Enums.StKey.Hurt3PosY : -12976128,
#			Enums.StKey.Hurt3ScaleX : 896890, Enums.StKey.Hurt3ScaleY : -1310808,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 13893632, Enums.StKey.Hit1PosY : -19379392,
			Enums.StKey.Hit1ScaleX : 1456925, Enums.StKey.Hit1ScaleY : 683934,
			Enums.StKey.hitstop: 8,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.min_damage: 12,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x: -SGFixed.ONE*18,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*35,
			Enums.StKey.hitstun: 60,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*18,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*35,
			},
		8 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -8337728,
			Enums.StKey.Hit1ScaleX : 486985, Enums.StKey.Hit1ScaleY : 1074037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = SGFixed.ONE*20
	state[Enums.StKey.accel_y] = Util.GRAVITY
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.stop(true)
	anim.play("AssistAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*30

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] > 8 and state[Enums.StKey.hitStopFrame] <= 0):
			change_state.call("LandAttackRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
