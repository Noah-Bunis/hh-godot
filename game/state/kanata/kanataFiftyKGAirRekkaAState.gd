extends "res://game/state/kanata/mainstates/kanataAttackState.gd"

class_name KanataFiftyKGAirRekkaAState

var CallSound = preload("res://game/assets/voice/kanata/amk_ Squish You.wav")

func _init():
	endFrame = 27
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 2359296, Enums.StKey.Hit1PosY : -12976128,
			Enums.StKey.Hit1ScaleX : 2503512, Enums.StKey.Hit1ScaleY : 3516269,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.burst_OK: false,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*65,
			Enums.StKey.attack_damage: 160,
			Enums.StKey.min_damage: 10,
			Enums.StKey.hitstun : 120,
			Enums.StKey.hitstop : 13,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*20,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*65,
			},
		1 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		12 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -655360, Enums.StKey.Hurt1PosY : -23855102,
			Enums.StKey.Hurt1ScaleX : 497627, Enums.StKey.Hurt1ScaleY : 523538,
			Enums.StKey.Hurt2PosX : 3211265, Enums.StKey.Hurt2PosY : -15269887,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : 65, Enums.StKey.Hurt3PosY : -10485760,
			Enums.StKey.Hurt3ScaleX : 871288, Enums.StKey.Hurt3ScaleY : 1034829,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("KanataFiftyHitFollowUp")
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_y] = 0

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

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
