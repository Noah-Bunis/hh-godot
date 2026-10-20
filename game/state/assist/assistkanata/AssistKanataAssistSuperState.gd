extends AssistAttackState

class_name AssistKanataSuperState
func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 3866624, Enums.StKey.Hurt1PosY : -14417920,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : -6160384, Enums.StKey.Hurt2PosY : -13107201,
			Enums.StKey.Hurt2ScaleX : 809242, Enums.StKey.Hurt2ScaleY : 718928,
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
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
			},
		10 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 11272191, Enums.StKey.Hit1PosY : -27394046,
			Enums.StKey.Hit1ScaleX : 997409, Enums.StKey.Hit1ScaleY : 1680399,
			Enums.StKey.Hit2PosX : 1703936, Enums.StKey.Hit2PosY : -30408702,
			Enums.StKey.Hit2ScaleX : 512521, Enums.StKey.Hit2ScaleY : 833886,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -786432, Enums.StKey.Hurt1PosY : -8716288,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 4980736, Enums.StKey.Hurt2PosY : -6684672,
			Enums.StKey.Hurt2ScaleX : 809242, Enums.StKey.Hurt2ScaleY : 718928,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.hitstop : 10,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: 80,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*7,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*90,
			Enums.StKey.min_damage: 15,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 110,
			Enums.StKey.attack_damage: 70,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*100,
			},
		17 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 4587520, Enums.StKey.Hurt1PosY : -22544384,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 2293760, Enums.StKey.Hurt2PosY : -5898242,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
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
