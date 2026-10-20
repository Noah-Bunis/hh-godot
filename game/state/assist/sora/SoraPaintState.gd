extends AssistAttackState

class_name SoraPaintState

func _init():
	endFrame = 25
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			},
		10 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 7995393, Enums.StKey.Hit1PosY : -18874368,
			Enums.StKey.Hit1ScaleX : 716121, Enums.StKey.Hit1ScaleY : -2239832,
			Enums.StKey.min_damage:10,
			Enums.StKey.chip_damage:10,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.hitstun: 50,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : SGFixed.ONE*45,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*60,
			},
		14 : { 
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
	anim.play("Paint")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
#		state[Enums.StKey.velocity_y] = -SGFixed.ONE*50
		state[Enums.StKey.velocity_x] = SGFixed.ONE*15

#func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
#	if (event_cause == Enums.Reaction.GroundLand):
#		if (state[Enums.StKey.frame] > 8 and state[Enums.StKey.hitStopFrame] <= 0):
#			change_state.call("LandAttackRecovery")
#	else:
#		.reaction(state, interpreter, event_cause)
