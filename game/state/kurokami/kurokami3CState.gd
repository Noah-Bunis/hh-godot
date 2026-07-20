extends KurokamiCrouchAttackState

class_name Kurokami3CState

func _init():
	endFrame = 32
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt2PosX : -524288, Enums.StKey.Hurt2PosY : -7471104,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 655360, Enums.StKey.Hurt3PosY : -1835008,
			Enums.StKey.Hurt3ScaleX : 1161459, Enums.StKey.Hurt3ScaleY : -231611,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 6767169, Enums.StKey.Hit1PosY : -33619964,
			Enums.StKey.Hit1ScaleX : 1019159, Enums.StKey.Hit1ScaleY : -339693,
			Enums.StKey.Hit2PosX : 11010048, Enums.StKey.Hit2PosY : -18920636,
			Enums.StKey.Hit2ScaleX : 904071, Enums.StKey.Hit2ScaleY : 1863129,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -327680, Enums.StKey.Hurt1PosY : -27787266,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : 379648, Enums.StKey.Hurt2PosY : -11908288,
			Enums.StKey.Hurt2ScaleX : 646568, Enums.StKey.Hurt2ScaleY : -1254072,
			Enums.StKey.Hurt3PosX : 10767169, Enums.StKey.Hurt3PosY : -12000000,
			Enums.StKey.Hurt3ScaleX : 400000, Enums.StKey.Hurt3ScaleY : -1245535,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 25,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*7,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*50,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.attack_damage: 45,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*7,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
			13 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 2767169, Enums.StKey.Hit1PosY : -33619964,
			Enums.StKey.Hit1ScaleX : 519159, Enums.StKey.Hit1ScaleY : -339693,
			Enums.StKey.Hit2PosX : 12010048, Enums.StKey.Hit2PosY : -17920636,
			Enums.StKey.Hit2ScaleX : 504071, Enums.StKey.Hit2ScaleY : 1863129,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -327680, Enums.StKey.Hurt1PosY : -27787266,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : 379648, Enums.StKey.Hurt2PosY : -11908288,
			Enums.StKey.Hurt2ScaleX : 646568, Enums.StKey.Hurt2ScaleY : -1254072,
			Enums.StKey.Hurt3PosX : 8767169, Enums.StKey.Hurt3PosY : -12000000,
			Enums.StKey.Hurt3ScaleX : 400000, Enums.StKey.Hurt3ScaleY : -1245535,
			},
		16 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -327680, Enums.StKey.Hurt1PosY : -27787266,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : 1179648, Enums.StKey.Hurt2PosY : -16908288,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 327680, Enums.StKey.Hurt3PosY : -5242880,
			Enums.StKey.Hurt3ScaleX : 779030, Enums.StKey.Hurt3ScaleY : -635720,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("3C")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
