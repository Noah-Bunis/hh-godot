extends KurokamiAirAttackState

class_name Kurokamij2CState

var voice = preload("res://game/assets/voice/flayon/mxf_im_crazy.wav")

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1629186, Enums.StKey.Hurt1PosY : -20760254,
			Enums.StKey.Hurt1ScaleX : 1326496, Enums.StKey.Hurt1ScaleY : 1326496,
			},
		7 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.Hit1PosX : 1629186, Enums.StKey.Hit1PosY : -20760254,
			Enums.StKey.Hit1ScaleX : 1226496, Enums.StKey.Hit1ScaleY : 1226496,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1629186, Enums.StKey.Hurt1PosY : -20760254,
			Enums.StKey.Hurt1ScaleX : 1326496, Enums.StKey.Hurt1ScaleY : 1326496,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.hitstop: 5,
			Enums.StKey.attack_damage: 18,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*30,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.min_damage:3,
			Enums.StKey.chip_damage:2,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		39 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1629186, Enums.StKey.Hurt1PosY : -20760254,
			Enums.StKey.Hurt1ScaleX : 1326496, Enums.StKey.Hurt1ScaleY : 1326496,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("j2C")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		SyncManager.play_sound("kurokamiVoice", voice, {"bus": "Voice"})


func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump6C"
