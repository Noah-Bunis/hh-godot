extends "res://game/state/assist/rikka/RikkaAssistAirGuardCancelAttackState.gd"

class_name RikkaAssistAirWeakGuardCancelAttackState

func _init():
	endFrame = 120
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			},
		14 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 13548576, Enums.StKey.Hit1PosY : -15905984,
			Enums.StKey.Hit1ScaleX : 1392796, Enums.StKey.Hit1ScaleY : 581041,
			Enums.StKey.min_damage:0,
			Enums.StKey.chip_damage:0,
			Enums.StKey.attack_damage: 0,
			Enums.StKey.hitstun: 30, 
			Enums.StKey.counter_hitstun: 10,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*35,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.counter_launch_dir_y : -SGFixed.ONE*25,
			},
		17 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
	}
