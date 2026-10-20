extends ActiveProjectileState

class_name RikkaBallActiveProjectileState

var sound = preload("res://game/assets/sfx/RikkaBall-001.wav")

const SPEED = 58536
const UP_SPEED = 48536

func _init():
	endFrame = 161
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		2 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false,
			Enums.StKey.chip_damage: 10,
			Enums.StKey.min_damage: 10,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 45,
			Enums.StKey.hit_box_colliding_frame : 5,
			},
		160 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = SGFixed.ONE*25
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.projectile_hp] = 1

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		SyncManager.play_sound("RikkaBall", sound, {"bus": "Sound"})

func reaction(state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.PointBlockHurt):
		change_state.call("Destroy")
	elif (event_cause == Enums.Reaction.PointAttackHurt):
		change_state.call("Destroy")


func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)
	if (
			(interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.accel_x] = -SPEED 
	elif ( 
			(interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.accel_x] = SPEED
	else:
		state[Enums.StKey.accel_x] = 0
	
	if (
			(interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.accel_y] = -UP_SPEED
	elif (
			(interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]))
			):
			state[Enums.StKey.accel_y] = UP_SPEED
	else:
		state[Enums.StKey.accel_y] = 0
