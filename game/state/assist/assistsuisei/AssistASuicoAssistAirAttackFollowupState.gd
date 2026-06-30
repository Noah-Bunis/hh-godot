extends AssistASuicoBaseAttackState

class_name AssistASuicoAssistAirAttackState

func _init():
	endFrame = 22
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -13565953,
			Enums.StKey.Hurt1ScaleX : 1239883, Enums.StKey.Hurt1ScaleY : 1274110,
			},
		4 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -13565953,
			Enums.StKey.Hurt1ScaleX : 1239883, Enums.StKey.Hurt1ScaleY : 1274110,
			Enums.StKey.Summon : "knockdowndust",
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -19202048,
			Enums.StKey.Hit1ScaleX : 1565865, Enums.StKey.Hit1ScaleY : 1876345,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -13565953,
			Enums.StKey.Hurt1ScaleX : 1239883, Enums.StKey.Hurt1ScaleY : 1274110,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstun : 80,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : SGFixed.ONE*30,
			Enums.StKey.hitstop: 10,
			Enums.StKey.meter_build: 0,
			Enums.StKey.min_damage:12,
			Enums.StKey.chip_damage:10,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 100,
			Enums.StKey.counter_launch_dir_x: 0,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			},
		8 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -13565953,
			Enums.StKey.Hurt1ScaleX : 1239883, Enums.StKey.Hurt1ScaleY : 1274110,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("ASuicoAssistAirAttackFollowup")
