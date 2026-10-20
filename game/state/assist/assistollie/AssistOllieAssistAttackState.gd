extends AssistAttackState

class_name AssistOllieAssistAttackState

func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			},
		10 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 77463552, Enums.StKey.Hit1PosY : -29687808,
			Enums.StKey.Hit1ScaleX : 1982209, Enums.StKey.Hit1ScaleY : 288752,
			Enums.StKey.Hit2PosX : 53805052, Enums.StKey.Hit2PosY : -24772608,
			Enums.StKey.Hit2ScaleX : 1915232, Enums.StKey.Hit2ScaleY : -290274,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 7,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 20,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*30,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*20,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*50,
			},
		18 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			},
		27 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 73662456, Enums.StKey.Hit1PosY : -28114946,
			Enums.StKey.Hit1ScaleX : 1704464, Enums.StKey.Hit1ScaleY : 675527,
			Enums.StKey.Hit2PosX : 78118920, Enums.StKey.Hit2PosY : -34799616,
			Enums.StKey.Hit2ScaleX : 938505, Enums.StKey.Hit2ScaleY : 1351744,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 7,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 38,
			Enums.StKey.launch_dir_x : SGFixed.ONE*25,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*55,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 45,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*35,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*60,
			},
		33 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -11993090,
			Enums.StKey.Hurt1ScaleX : 888108, Enums.StKey.Hurt1ScaleY : 1074037,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.stop(true)
	anim.play("AssistAttack")
