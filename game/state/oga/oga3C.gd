extends OgaCrouchAttackState

class_name Oga3CState

func _init():
	endFrame = 32
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -27090912,
			Enums.StKey.Hurt1ScaleX : 1001320, Enums.StKey.Hurt1ScaleY : 476368,
			Enums.StKey.Hurt2PosX : -2359295, Enums.StKey.Hurt2PosY : -10747904,
			Enums.StKey.Hurt2ScaleX : 843346, Enums.StKey.Hurt2ScaleY : -1101378,
			Enums.StKey.Hurt3PosX : -10944512, Enums.StKey.Hurt3PosY : -22740992,
			Enums.StKey.Hurt3ScaleX : 770410, Enums.StKey.Hurt3ScaleY : -441327,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1310720, Enums.StKey.Hurt1PosY : -22020098,
			Enums.StKey.Hurt1ScaleX : 282910, Enums.StKey.Hurt1ScaleY : 563870,
			Enums.StKey.Hurt2PosX : -917503, Enums.StKey.Hurt2PosY : -14286850,
			Enums.StKey.Hurt2ScaleX : 1073082, Enums.StKey.Hurt2ScaleY : 628093,
			Enums.StKey.Hurt3PosX : 2228223, Enums.StKey.Hurt3PosY : -3997697,
			Enums.StKey.Hurt3ScaleX : 1376776, Enums.StKey.Hurt3ScaleY : 534814,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 6946815, Enums.StKey.Hit1PosY : -13697024,
			Enums.StKey.Hit1ScaleX : 746687, Enums.StKey.Hit1ScaleY : 2933664,
			Enums.StKey.Hit2PosX : 7929853, Enums.StKey.Hit2PosY : -11337727,
			Enums.StKey.Hit2ScaleX : 1186215, Enums.StKey.Hit2ScaleY : -1180969,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 25,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*50,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.attack_damage: 45,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*2,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*50,
			},
		13 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			},
		18 : { 
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("3C")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
