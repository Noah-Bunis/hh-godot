extends AssistAirAttackState

class_name OkakoroJustJumpState

func _init():
	endFrame = 200
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			},
		5 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.Hit1PosX : 131072, Enums.StKey.Hit1PosY : -12512768,
			Enums.StKey.Hit1ScaleX : 2050735, Enums.StKey.Hit1ScaleY : 992530,
			Enums.StKey.min_damage:6,
			Enums.StKey.chip_damage:5,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.hitstun: 60,
			Enums.StKey.hitstop: 4,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.launch_dir_x : SGFixed.ONE*0,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*75,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -0,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*75,
			},
		60 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("EXJump")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_y] = 0
		state[Enums.StKey.velocity_x] = 0
		state[Enums.StKey.accel_y] = -95536
	elif (state[Enums.StKey.frame] == 40):
		state[Enums.StKey.accel_y] = 0
	elif (state[Enums.StKey.frame] == 60):
		state[Enums.StKey.accel_y] = Util.GRAVITY

func tag_cancel(state: Dictionary, interpreter: InputInterpreter):
	super.tag_cancel(state, interpreter)
	if (state["tag_attack"] == 2 or state["tag_attack"] == 1 or state["tag_attack"] == 3):
		change_state.call("AssistAirAttack2")

func combo_pushback(comboTime: int) -> int:
	return 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] > 8 and state[Enums.StKey.hitStopFrame] <= 0):
			change_state.call("LandAttackRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
