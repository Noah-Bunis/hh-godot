extends SuiseiAirAttackState

class_name SuiseiYoruMatsuyoState

func _init():
	endFrame = 42
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2162688, Enums.StKey.Hurt1PosY : -13828094,
			Enums.StKey.Hurt1ScaleX : 381154, Enums.StKey.Hurt1ScaleY : 951256,
			Enums.StKey.Hurt2PosX : 7929856, Enums.StKey.Hurt2PosY : -5177344,
			Enums.StKey.Hurt2ScaleX : 886971, Enums.StKey.Hurt2ScaleY : 283034,
			Enums.StKey.Hurt3PosX : 393216, Enums.StKey.Hurt3PosY : -5767168,
			Enums.StKey.Hurt3ScaleX : 566707, Enums.StKey.Hurt3ScaleY : 1009867,
			Enums.StKey.Summon: "knockdowndust",
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : -2293760, Enums.StKey.Hit1PosY : -3997696,
			Enums.StKey.Hit1ScaleX : 1215566, Enums.StKey.Hit1ScaleY : 659823,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2162688, Enums.StKey.Hurt1PosY : -13828094,
			Enums.StKey.Hurt1ScaleX : 381154, Enums.StKey.Hurt1ScaleY : 951256,
			Enums.StKey.Hurt2PosX : 7929856, Enums.StKey.Hurt2PosY : -5177344,
			Enums.StKey.Hurt2ScaleX : 886971, Enums.StKey.Hurt2ScaleY : 283034,
			Enums.StKey.Hurt3PosX : 393216, Enums.StKey.Hurt3PosY : -5767168,
			Enums.StKey.Hurt3ScaleX : 566707, Enums.StKey.Hurt3ScaleY : 1009867,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*60,
			Enums.StKey.chip_damage: 3,
			Enums.StKey.min_damage:3,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.hitstun: 30,
			Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN-3,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 90,
			Enums.StKey.meter_build: SGFixed.ONE*1000,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*15,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*65,
			},
		6 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 2162688, Enums.StKey.Hurt1PosY : -13828094,
			Enums.StKey.Hurt1ScaleX : 381154, Enums.StKey.Hurt1ScaleY : 951256,
			Enums.StKey.Hurt2PosX : 7929856, Enums.StKey.Hurt2PosY : -5177344,
			Enums.StKey.Hurt2ScaleX : 886971, Enums.StKey.Hurt2ScaleY : 283034,
			Enums.StKey.Hurt3PosX : 393216, Enums.StKey.Hurt3PosY : -5767168,
			Enums.StKey.Hurt3ScaleX : 566707, Enums.StKey.Hurt3ScaleY : 1009867,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Tatsu")
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.super_meter] += SGFixed.ONE*200
	state[Enums.StKey.kara_OK] = false # No instant air kara

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 70
		state[Enums.StKey.accel_y] = Util.GRAVITY+65536
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*10, state[Enums.StKey.velocity_x])

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AirSuiseiToSuicopath"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "GatoDive"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "GatoKick"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Pendulum"
	elif (state[Enums.StKey.frame] >= 15):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			change_state.call("AirSuiseiToSuicopath")
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("GatoDive")
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			change_state.call("GatoKick")
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("Pendulum")
	elif (state[Enums.StKey.frame] >= 6):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("GatoDive")
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			change_state.call("GatoKick")
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("Pendulum")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand and state[Enums.StKey.frame] <= 6):
		pass
	else:
		super.reaction(state, interpreter, event_cause)
