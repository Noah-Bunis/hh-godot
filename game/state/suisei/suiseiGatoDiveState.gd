extends SuiseiAirAttackState

class_name SuiseiGatoDiveState

const FORM_CHANGE_FRAME := 25

func _init():
	endFrame = 80
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -18728636,
			Enums.StKey.Hurt1ScaleX : 1342691, Enums.StKey.Hurt1ScaleY : 1149402,
			},
		6 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false, Enums.StKey.Hit2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 8126464, Enums.StKey.Hit1PosY : -15532032,
			Enums.StKey.Hit1ScaleX : 712956, Enums.StKey.Hit1ScaleY : 998516,
			Enums.StKey.Hit2PosX : 1703936, Enums.StKey.Hit2PosY : -8126464,
			Enums.StKey.Hit2ScaleX : 970974, Enums.StKey.Hit2ScaleY : 634629,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -18728636,
			Enums.StKey.Hurt1ScaleX : 1342691, Enums.StKey.Hurt1ScaleY : 1149402,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*45,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*20,
			Enums.StKey.chip_damage: 3,
			Enums.StKey.min_damage:3,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 35,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 40,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*30,
			Enums.StKey.meter_build: SGFixed.ONE*800,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("jB")
	state[Enums.StKey.super_meter] += SGFixed.ONE*100

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*10, state[Enums.StKey.velocity_x])
		state[Enums.StKey.velocity_y] = 0
		state[Enums.StKey.accel_y] = Util.GRAVITY
	elif (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*25, state[Enums.StKey.velocity_x])
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*55
	elif (state[Enums.StKey.frame] >= 25):
		state[Enums.StKey.drag_x] = Util.ICE_FRICTION

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)

	if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]))):
		state[Enums.StKey.accel_y] = 305536
	else:
		state[Enums.StKey.accel_y] = Util.GRAVITY
	
	if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))):
		state[Enums.StKey.accel_x] = -45536
	elif ((interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface]))):
		state[Enums.StKey.accel_x] = 15536
	else:
		state[Enums.StKey.accel_x] = 0


func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "AirSuiseiToSuicopath"
	elif (state[Enums.StKey.frame] >= FORM_CHANGE_FRAME):
		if (interpreter.is_button_down(Enums.InputFlags.CDown)):
			change_state.call("AirSuiseiToSuicopath")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand and state[Enums.StKey.frame] <= 5):
		pass
	else:
		super.reaction(state, interpreter, event_cause)
