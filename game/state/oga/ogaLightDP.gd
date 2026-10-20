extends OgaAttackState

class_name OgaLightDPState

var voice = preload("res://game/assets/voice/oga/oga_hanase.wav")
var sound = preload("res://game/assets/sfx/Parry8Bit.wav")

func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -1114112, Enums.StKey.Hurt1PosY : -4980735,
			Enums.StKey.Hurt1ScaleX : 1519518, Enums.StKey.Hurt1ScaleY : 971624,
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false, 
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 3014656, Enums.StKey.Hit1PosY : -40108028,
			Enums.StKey.Hit1ScaleX : 1582990, Enums.StKey.Hit1ScaleY : -5404026,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 7536640, Enums.StKey.Hurt1PosY : -23461888,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -1507327, Enums.StKey.Hurt2PosY : -16711681,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : 983039, Enums.StKey.Hurt3PosY : -4521985,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : SGFixed.ONE*50,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: 80,
			Enums.StKey.counter_hitstun: 80,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.min_damage: 10,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*0,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*50,
			},
		19 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 7536640, Enums.StKey.Hurt1PosY : -23461888,
			Enums.StKey.Hurt1ScaleX : 498353, Enums.StKey.Hurt1ScaleY : 442051,
			Enums.StKey.Hurt2PosX : -1507327, Enums.StKey.Hurt2PosY : -16711681,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : 983039, Enums.StKey.Hurt3PosY : -4521985,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("CaptainCorridor")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("OgaVoice", voice, {"bus": "Voice"})
	if (state[Enums.StKey.frame] == 11):
		SyncManager.play_sound("ogaDPSound", sound, {"bus": "Sound"})

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "BoostCancel"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "BoostCancel"):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "GroundAssistCall"

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
