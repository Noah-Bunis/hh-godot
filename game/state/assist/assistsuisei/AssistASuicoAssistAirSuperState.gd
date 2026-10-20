extends AssistASuicoBaseAirAttackState

class_name AssistASuicoAirSuperState

func _init():
	endFrame = 200
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Summon : "meterDump",
			},
		5 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : 0,
			Enums.StKey.Hit1ScaleX : 18338272, Enums.StKey.Hit1ScaleY : 18338272,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
			},
		6 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : -4849664, Enums.StKey.Hurt1PosY : -12058623,
			Enums.StKey.Hurt1ScaleX : 536711, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 1310719, Enums.StKey.Hurt2PosY : -19660802,
			Enums.StKey.Hurt2ScaleX : 924253, Enums.StKey.Hurt2ScaleY : -367041,
			},
		11 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 1245184, Enums.StKey.Hit1PosY : -11141124,
			Enums.StKey.Hit1ScaleX : 2371656, Enums.StKey.Hit1ScaleY : 646127,
			Enums.StKey.Hit2PosX : 5373952, Enums.StKey.Hit2PosY : -24641534,
			Enums.StKey.Hit2ScaleX : 1674376, Enums.StKey.Hit2ScaleY : 608322,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : -13303809, Enums.StKey.Hurt1PosY : -14352385,
			Enums.StKey.Hurt1ScaleX : 880511, Enums.StKey.Hurt1ScaleY : 485238,
			Enums.StKey.Hurt2PosX : 3866624, Enums.StKey.Hurt2PosY : -22937602,
			Enums.StKey.Hurt2ScaleX : 2004285, Enums.StKey.Hurt2ScaleY : 411488,
			Enums.StKey.hit_box_colliding_frame : 20,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.attack_damage: 70,
			Enums.StKey.min_damage: 40,
			Enums.StKey.chip_damage: 7,
			Enums.StKey.hitstun: 80,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : SGFixed.ONE*80,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*80,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("ASuicoAssistAirSuper")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*3
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*120
	if (state[Enums.StKey.frame] == 15):
		state[Enums.StKey.accel_y] = Util.GRAVITY

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] > 2 and state[Enums.StKey.hitStopFrame] <= 0):
			change_state.call("ASuicoKnockdown")
	else:
		super.reaction(state, interpreter, event_cause)
