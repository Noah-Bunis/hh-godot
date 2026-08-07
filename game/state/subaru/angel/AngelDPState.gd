extends AngelAirAttackState

class_name AngelDPState

var voice = preload("res://game/assets/voice/subaru/SBR_boko boko bat.wav")

func _init():
	endFrame = 100
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		6 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 1,
			Enums.StKey.Hit1PosX : 10354687, Enums.StKey.Hit1PosY : -16121856,
			Enums.StKey.Hit1ScaleX : 979896, Enums.StKey.Hit1ScaleY : -2113845,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*80,
			Enums.StKey.chip_damage: 1,
			Enums.StKey.attack_damage:30,
			Enums.StKey.min_damage:1,
			Enums.StKey.hitstun: 70,
			Enums.StKey.hitstop: 2,
			Enums.StKey.meter_build: SGFixed.ONE*100,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*100,
			},
		30 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			},
		40 : { 
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 6094848, Enums.StKey.Hurt3PosY : -4784128,
			Enums.StKey.Hurt3ScaleX : 1171400, Enums.StKey.Hurt3ScaleY : -464723,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = 0
	anim.play("AngelDP")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] >= 5 and state[Enums.StKey.frame] <= 40):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 55
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE * 23, state[Enums.StKey.velocity_x])
		state[Enums.StKey.drag_x] = 65536
	elif (state[Enums.StKey.frame] == 4):
		SyncManager.play_sound("SubaruVoice", voice, {"bus": "Voice"})

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.hitStopFrame] <= 0 and state[Enums.StKey.frame] >= 16):
			state[Enums.StKey.doubleJump] = 1
			state[Enums.StKey.airDash] = 1
			change_state.call("AngelStand")
	else:
		super.reaction(state, interpreter, event_cause)

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AngelAirBoostCancel"
		elif (assist_ok(state, interpreter)):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AngelAirAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AngelAirAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "AngelAirAssistCall"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
