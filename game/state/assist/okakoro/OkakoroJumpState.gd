extends AssistAirAttackState

class_name OkakoroJumpState

func _init():
	endFrame = 200
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -16337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 1074037,
			Enums.StKey.Hurt2PosX : -6605536, Enums.StKey.Hurt2PosY : -27993090,
			Enums.StKey.Hurt2ScaleX : 1208108, Enums.StKey.Hurt2ScaleY : 1007212,
			},
		5 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -16337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 1074037,
			Enums.StKey.Hurt2PosX : -6605536, Enums.StKey.Hurt2PosY : -27993090,
			Enums.StKey.Hurt2ScaleX : 1208108, Enums.StKey.Hurt2ScaleY : 1007212,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 131072, Enums.StKey.Hit1PosY : -20512768,
			Enums.StKey.Hit1ScaleX : 850735, Enums.StKey.Hit1ScaleY : 992530,
			Enums.StKey.min_damage:2,
			Enums.StKey.chip_damage:2,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*58,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.hitstun: 45,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*1,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*65,
			},
		20 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -16337728,
			Enums.StKey.Hurt1ScaleX : 986985, Enums.StKey.Hurt1ScaleY : 1074037,
			Enums.StKey.Hurt2PosX : -6605536, Enums.StKey.Hurt2PosY : -27993090,
			Enums.StKey.Hurt2ScaleX : 1208108, Enums.StKey.Hurt2ScaleY : 1007212,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.accel_y] = Util.GRAVITY
	anim.stop(true)
	anim.play("Jump")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*60
		state[Enums.StKey.velocity_x] = SGFixed.ONE*30

func tag_cancel(state: Dictionary, interpreter: InputInterpreter):
	super.tag_cancel(state, interpreter)
	if (state["tag_attack"] == 2 or state["tag_attack"] == 1 or state["tag_attack"] == 3):
		change_state.call("AssistAirAttack2")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] > 8 and state[Enums.StKey.hitStopFrame] <= 0):
			change_state.call("LandAttackRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
