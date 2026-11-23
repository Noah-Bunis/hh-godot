extends SuiseiAirAttackState

class_name SuiseiGatoKickState

const FOLLOWUP_CANCEL_FRAME := 15

var CallSound = preload("res://game/assets/voice/suisei/sui_wah!.wav")

func _init():
	endFrame = 32
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			#
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -7077887, Enums.StKey.Hurt1PosY : -19791874,
			Enums.StKey.Hurt1ScaleX : 571380, Enums.StKey.Hurt1ScaleY : 897647,
			Enums.StKey.Hurt2PosX : -7405568, Enums.StKey.Hurt2PosY : -7471105,
			Enums.StKey.Hurt2ScaleX : 358726, Enums.StKey.Hurt2ScaleY : 561956,
			Enums.StKey.Hurt3PosX : 2555903, Enums.StKey.Hurt3PosY : -16908286,
			Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			},
		4 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 8126464, Enums.StKey.Hit1PosY : -15532032,
			Enums.StKey.Hit1ScaleX : 912956, Enums.StKey.Hit1ScaleY : 798516,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -7077887, Enums.StKey.Hurt1PosY : -19791874,
			Enums.StKey.Hurt1ScaleX : 571380, Enums.StKey.Hurt1ScaleY : 897647,
			Enums.StKey.Hurt2PosX : -7405568, Enums.StKey.Hurt2PosY : -7471105,
			Enums.StKey.Hurt2ScaleX : 358726, Enums.StKey.Hurt2ScaleY : 561956,
			Enums.StKey.Hurt3PosX : 2555903, Enums.StKey.Hurt3PosY : -16908286,
			Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			Enums.StKey.hitstun : 40 - Util.BONUS_JUGGLE_HITSTUN,
			Enums.StKey.attack_damage: 58,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
			Enums.StKey.hitstop: 8,
			Enums.StKey.min_damage:8,
			Enums.StKey.chip_damage:8,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.meter_build: SGFixed.ONE*1300,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*50,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
		9 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -7077887, Enums.StKey.Hurt1PosY : -19791874,
			Enums.StKey.Hurt1ScaleX : 571380, Enums.StKey.Hurt1ScaleY : 897647,
			Enums.StKey.Hurt2PosX : -7405568, Enums.StKey.Hurt2PosY : -7471105,
			Enums.StKey.Hurt2ScaleX : 358726, Enums.StKey.Hurt2ScaleY : 561956,
			Enums.StKey.Hurt3PosX : 2555903, Enums.StKey.Hurt3PosY : -16908286,
			Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			},
		18 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -4587519, Enums.StKey.Hurt1PosY : -19791874,
			Enums.StKey.Hurt1ScaleX : 381154, Enums.StKey.Hurt1ScaleY : 951256,
			Enums.StKey.Hurt2PosX : -9568256, Enums.StKey.Hurt2PosY : -11272191,
			Enums.StKey.Hurt2ScaleX : 886971, Enums.StKey.Hurt2ScaleY : 283034,
			Enums.StKey.Hurt3PosX : -1507327, Enums.StKey.Hurt3PosY : -22413312,
			Enums.StKey.Hurt3ScaleX : 572626, Enums.StKey.Hurt3ScaleY : 334233,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("GatoKick")
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 10
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*18, state[Enums.StKey.velocity_x])
	elif (state[Enums.StKey.frame] == 6):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE * 20
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*18, state[Enums.StKey.velocity_x])
#	elif (state[Enums.StKey.frame] == 2):
#		SyncManager.play_sound("SuiseiVoice", CallSound, {"bus": "Voice"})

func jump_cancel(_state: Dictionary, _interpreter: InputInterpreter):
	pass

func gatling_cancel(_state: Dictionary, _interpreter: InputInterpreter):
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
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Pendulum"
	elif (state[Enums.StKey.frame] >= FOLLOWUP_CANCEL_FRAME):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			change_state.call("AirSuiseiToSuicopath")
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("GatoDive")
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("Pendulum")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand and state[Enums.StKey.frame] <= 7):
		pass
	else:
		super.reaction(state, interpreter, event_cause)
