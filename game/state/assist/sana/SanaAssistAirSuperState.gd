extends AssistAirAttackState

class_name SanaAirSuperState

func _init():
	endFrame = 12
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			Enums.StKey.Summon : "meterDump",
			},
		5 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : 0,
			Enums.StKey.Hit1ScaleX : 18338272, Enums.StKey.Hit1ScaleY : 18338272,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop: 0,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
			},
		7 : { 
			Enums.StKey.Summon : "move_pilot",
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.drag_x] = Util.ICE_FRICTION
	state[Enums.StKey.velocity_x] = SGFixed.ONE*65
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("AssistSuper")

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)
	
	if (state[Enums.StKey.frame] == 8 and interpreter.is_button_down(Enums.InputFlags.DHold)):
		state[Enums.StKey.frame] = 6
	if (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*27
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*27, state[Enums.StKey.velocity_x])

	if (interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])):
		state[Enums.StKey.velocity_y] = SGFixed.ONE*60
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*14
	else:
		state[Enums.StKey.velocity_y] = SGFixed.ONE*3

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		pass
	elif (event_cause == Enums.Reaction.ForceTagOut):
		exit_state()
	else:
		super.reaction(state, interpreter, event_cause)
