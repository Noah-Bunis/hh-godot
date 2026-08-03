extends KurokamiAirAttackState

class_name KurokamijCState

var voice = preload("res://game/assets/voice/flayon/mxf_grunt.wav")

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15187392,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1071143,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -8187392,
			Enums.StKey.Hurt2ScaleX : 878601, Enums.StKey.Hurt2ScaleY : 596011,
			},
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 14629186, Enums.StKey.Hit1PosY : -18760254,
			Enums.StKey.Hit1ScaleX : 1426496, Enums.StKey.Hit1ScaleY : 850290,
			Enums.StKey.Hit2PosX : 12155775, Enums.StKey.Hit2PosY : -17468801,
			Enums.StKey.Hit2ScaleX : 997940, Enums.StKey.Hit2ScaleY : 947094,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 16900000, Enums.StKey.Hurt1PosY : -16471104,
			Enums.StKey.Hurt1ScaleX : 922078, Enums.StKey.Hurt1ScaleY : 836954,
			Enums.StKey.Hurt2PosX : 4092544, Enums.StKey.Hurt2PosY : -15187392,
			Enums.StKey.Hurt2ScaleX : 1078601, Enums.StKey.Hurt2ScaleY : 596011,
			Enums.StKey.Hurt3PosX : -1220000, Enums.StKey.Hurt3PosY : -8187392,
			Enums.StKey.Hurt3ScaleX : 878601, Enums.StKey.Hurt3ScaleY : 596011,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 4,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_hitstun: 10,
			},
		17 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 4092544, Enums.StKey.Hurt1PosY : -15187392,
			Enums.StKey.Hurt1ScaleX : 1078601, Enums.StKey.Hurt1ScaleY : 596011,
			Enums.StKey.Hurt2PosX : 11546271, Enums.StKey.Hurt2PosY : -19362432,
			Enums.StKey.Hurt2ScaleX : 445784, Enums.StKey.Hurt2ScaleY : 765625,
			Enums.StKey.Hurt3PosX : -1220000, Enums.StKey.Hurt3PosY : -8187392,
			Enums.StKey.Hurt3ScaleX : 878601, Enums.StKey.Hurt3ScaleY : 596011,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("jC")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 10):
		SyncManager.play_sound("kurokamiVoice", voice, {"bus": "Voice"})

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
	
func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump2C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump6C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Jump5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Jump5A"
