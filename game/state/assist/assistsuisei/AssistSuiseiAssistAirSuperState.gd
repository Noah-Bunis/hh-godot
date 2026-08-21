extends AssistASuicoBaseAirAttackState

class_name AssistSuiseiAirSuperState

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Summon : "meterDump",
			},
		1 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : 0,
			Enums.StKey.Hit1ScaleX : 18338272, Enums.StKey.Hit1ScaleY : 18338272,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop: 0,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
		},
		2 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1PosX : 9240576, Enums.StKey.Hit1PosY : -17595266,
			Enums.StKey.Hit1ScaleX : 1275360, Enums.StKey.Hit1ScaleY : 1275360,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*20,
			Enums.StKey.hitstun : 80,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 18,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.hitstop: 5,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.counter_launch_dir_y : -SGFixed.ONE*20,
			},
		10 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 100,
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1PosX : 9240576, Enums.StKey.Hit1PosY : -19595266,
			Enums.StKey.Hit1ScaleX : 1578531, Enums.StKey.Hit1ScaleY : 1775360,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*25,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.hitstun : 70,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.min_damage: 20,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.hitstop: 12,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.meter_build: 0,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*2,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		15 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
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
	anim.play("AssistSuper")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*50
