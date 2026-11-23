extends SuiseiAirAttackState

class_name SuiseiPendulumState

const FOLLOWUP_CANCEL_FRAME := 2


func _init():
	endFrame = 80
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			#
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -1114112, Enums.StKey.Hurt1PosY : -15007744,
			Enums.StKey.Hurt1ScaleX : 1185327, Enums.StKey.Hurt1ScaleY : 1324647,
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 4,
			Enums.StKey.Hit1PosX : 8126464, Enums.StKey.Hit1PosY : -15532032,
			Enums.StKey.Hit1ScaleX : 712956, Enums.StKey.Hit1ScaleY : 998516,
			Enums.StKey.Hit2PosX : 1703936, Enums.StKey.Hit2PosY : -8126464,
			Enums.StKey.Hit2ScaleX : 970974, Enums.StKey.Hit2ScaleY : 634629,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -1114112, Enums.StKey.Hurt1PosY : -15007744,
			Enums.StKey.Hurt1ScaleX : 1185327, Enums.StKey.Hurt1ScaleY : 1324647,
			Enums.StKey.attack_damage: 10,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.hitstop: 3,
			Enums.StKey.min_damage:3,
			Enums.StKey.chip_damage:1,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_hitstun: 10,
			Enums.StKey.meter_build: SGFixed.ONE*700,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Pendulum")
	state[Enums.StKey.super_meter] += SGFixed.ONE*100

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*17
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*10
		state[Enums.StKey.accel_y] = Util.GRAVITY
	elif (state[Enums.StKey.frame] == 5):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*10
		state[Enums.StKey.velocity_y] = SGFixed.ONE*48
		state[Enums.StKey.accel_y] = -SGFixed.ONE*3
		state[Enums.StKey.accel_x] = 68536
	elif (state[Enums.StKey.frame] == 27):
		state[Enums.StKey.accel_y] = SGFixed.ONE*3
		state[Enums.StKey.accel_x] = -SGFixed.ONE*2
	elif (state[Enums.StKey.frame] == 47):
		state[Enums.StKey.accel_y] = -SGFixed.ONE*1
		state[Enums.StKey.accel_x] = -SGFixed.ONE*3

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AirSuiseiToSuicopath"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("GatoDive")
	elif (state[Enums.StKey.frame] >= FOLLOWUP_CANCEL_FRAME):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			change_state.call("AirSuiseiToSuicopath")
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			change_state.call("GatoDive")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand and state[Enums.StKey.frame] <= 5):
		pass
	else:
		super.reaction(state, interpreter, event_cause)
