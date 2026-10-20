extends ActiveProjectileState

class_name SubaruBatterSetEnhancedBallActiveProjectileState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		2 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.min_damage: 6,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.attack_damage: 25,
			Enums.StKey.hitstun : 20,
			Enums.StKey.hitstop : 8,
			Enums.StKey.hit_box_colliding_frame : 1,
			Enums.StKey.meter_build: 0,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*30,
			Enums.StKey.counter_hitstun: 40,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
#			Enums.StKey.hitstun: 25,
			},
		50 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.accel_y] = 165536
	state[Enums.StKey.projectile_hp] = 3


func reaction(state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.StrikeHurt):
		state[Enums.StKey.frame] = 2
	elif (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
	
