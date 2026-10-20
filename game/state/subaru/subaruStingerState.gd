extends SubaruAttackState

class_name SubaruStingerState

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		6 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		10 : {
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
			Enums.StKey.guard: Enums.GuardType.Low,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*30,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*50,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.min_damage:8,
			Enums.StKey.hitstun: 30 - - Util.BONUS_JUGGLE_HITSTUN,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*55,
			},
		22 : { 
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
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 6):
		state[Enums.StKey.velocity_x] += Util.fixed_max(SGFixed.ONE*55, state[Enums.StKey.velocity_x])

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
