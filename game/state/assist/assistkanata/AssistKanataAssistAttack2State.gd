extends AssistAttackState

class_name AssistKanataAssistAttack2State

func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -4128768, Enums.StKey.Hurt1PosY : -8650752,
			Enums.StKey.Hurt1ScaleX : 1080399, Enums.StKey.Hurt1ScaleY : 908359,
			Enums.StKey.Hurt2PosX : -9175040, Enums.StKey.Hurt2PosY : -21364738,
			Enums.StKey.Hurt2ScaleX : 1143547, Enums.StKey.Hurt2ScaleY : -587001,
			},
		7 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -1245184, Enums.StKey.Hurt1PosY : -9175040,
			Enums.StKey.Hurt1ScaleX : 1169978, Enums.StKey.Hurt1ScaleY : 859614,
			Enums.StKey.Hurt2PosX : -9175040, Enums.StKey.Hurt2PosY : -21364738,
			Enums.StKey.Hurt2ScaleX : 1143547, Enums.StKey.Hurt2ScaleY : -587001,
			Enums.StKey.Hurt3PosX : 12845056, Enums.StKey.Hurt3PosY : -12517376,
			Enums.StKey.Hurt3ScaleX : 845584, Enums.StKey.Hurt3ScaleY : -455324,
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 22216704, Enums.StKey.Hit1PosY : -9371648,
			Enums.StKey.Hit1ScaleX : 2236383, Enums.StKey.Hit1ScaleY : -682901,
			Enums.StKey.Hit2PosX : 35717116, Enums.StKey.Hit2PosY : -13959169,
			Enums.StKey.Hit2ScaleX : 1432861, Enums.StKey.Hit2ScaleY : 568865,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -2490368, Enums.StKey.Hurt1PosY : -9043968,
			Enums.StKey.Hurt1ScaleX : 1080399, Enums.StKey.Hurt1ScaleY : 908359,
			Enums.StKey.Hurt2PosX : -13762559, Enums.StKey.Hurt2PosY : -14876672,
			Enums.StKey.Hurt2ScaleX : 837763, Enums.StKey.Hurt2ScaleY : -519068,
			Enums.StKey.Hurt3PosX : 21561344, Enums.StKey.Hurt3PosY : -7602176,
			Enums.StKey.Hurt3ScaleX : 2088636, Enums.StKey.Hurt3ScaleY : -721312,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.hitstop : 10,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_damage: 35,
			Enums.StKey.min_damage: 5,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.block_dir_x : SGFixed.ONE*40,
			Enums.StKey.block_dir_y : -SGFixed.ONE*30,
			Enums.StKey.counter_hitstun: 10,
			Enums.StKey.launch_dir_x: SGFixed.ONE*40,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*30,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*30,
			},
		16 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -2490368, Enums.StKey.Hurt1PosY : -9043968,
			Enums.StKey.Hurt1ScaleX : 1080399, Enums.StKey.Hurt1ScaleY : 908359,
			Enums.StKey.Hurt2PosX : -13500417, Enums.StKey.Hurt2PosY : -17825792,
			Enums.StKey.Hurt2ScaleX : 837763, Enums.StKey.Hurt2ScaleY : -519068,
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
	anim.play("AssistAttack2")
