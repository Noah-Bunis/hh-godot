extends SubaruAirAttackState

class_name SubaruAirStingerState

func _init():
	endFrame = 35
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 5898239, Enums.StKey.Hit1PosY : -5505023,
			Enums.StKey.Hit1ScaleX : 1267461, Enums.StKey.Hit1ScaleY : 378929,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 15466496, Enums.StKey.Hurt1PosY : -3145732,
			Enums.StKey.Hurt1ScaleX : 536711, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 2818049, Enums.StKey.Hurt2PosY : -4259840,
			Enums.StKey.Hurt2ScaleX : 924253, Enums.StKey.Hurt2ScaleY : -367041,
			Enums.StKey.Hurt3PosX : -11468800, Enums.StKey.Hurt3PosY : -4259840,
			Enums.StKey.Hurt3ScaleX : 608053, Enums.StKey.Hurt3ScaleY : -367041,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.hitstun: 20,
			Enums.StKey.min_damage:5,
			Enums.StKey.chip_damage:2,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 5,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*35,
			},
		32 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 15466496, Enums.StKey.Hurt1PosY : -3145732,
			Enums.StKey.Hurt1ScaleX : 536711, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 2818049, Enums.StKey.Hurt2PosY : -4259840,
			Enums.StKey.Hurt2ScaleX : 924253, Enums.StKey.Hurt2ScaleY : -367041,
			Enums.StKey.Hurt3PosX : -11468800, Enums.StKey.Hurt3PosY : -4259840,
			Enums.StKey.Hurt3ScaleX : 608053, Enums.StKey.Hurt3ScaleY : -367041,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Tatsu")
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 6):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 35
		state[Enums.StKey.velocity_x] += SGFixed.ONE * 10
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*25, state[Enums.StKey.velocity_x])

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
