extends FlayonAirAttackState

class_name FlayonLightDPState

var DPSound = preload("res://game/assets/voice/flayon/mxf_shock.wav")
const delay_cancel_frame = 8 # 12

func _init():
	endFrame = 120
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -17760254,
			Enums.StKey.Hit1ScaleX : 1026496, Enums.StKey.Hit1ScaleY : 1150290,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*50,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.min_damage:8,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 30,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 8629186, Enums.StKey.Hit1PosY : -17760254,
			Enums.StKey.Hit1ScaleX : 526496, Enums.StKey.Hit1ScaleY : 1150290,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -10087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1071143,
			Enums.StKey.Hurt2PosX : 6546270, Enums.StKey.Hurt2PosY : -20362431,
			Enums.StKey.Hurt2ScaleX : 645783, Enums.StKey.Hurt2ScaleY : 665625,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*28,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*55,
			Enums.StKey.chip_damage: 5,
			Enums.StKey.min_damage: 10,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.hitstun: 35,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
			},
		20 : { 
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -10087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1071143,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -20362431,
			Enums.StKey.Hurt2ScaleX : 645783, Enums.StKey.Hurt2ScaleY : 665625,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.super_meter] += SGFixed.ONE*200
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.kara_OK] = false # No instant air kara 
	anim.play("DP")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 7):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 50
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE * 12, state[Enums.StKey.velocity_x])
#		state[Enums.StKey.drag_x] = 85536
	elif (state[Enums.StKey.frame] == 3):
		SyncManager.play_sound("FlayonVoice", DPSound, {"bus": "Voice"})

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.hitStopFrame] <= 0 and state[Enums.StKey.frame] >= 16):
			state[Enums.StKey.doubleJump] = 1
			state[Enums.StKey.airDash] = 1
			change_state.call("LandingRecovery")
	else:
		super.reaction(state, interpreter, event_cause)

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AirBoostCancel"
		elif (state[Enums.StKey.frame] >= delay_cancel_frame and interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.DDown)):
			if ((interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
					interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
					interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
				state[Enums.StKey.cancelState] = "AirBackThrowWhiff"
			else:
				state[Enums.StKey.cancelState] = "AirThrowWhiff"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "AirBoostCancel"):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AirAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state) and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AirAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "AirAssistCall"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
