extends ActiveProjectileState

class_name QueenTravelState

func _init():
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : true,
			},
		1 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 1,
			Enums.StKey.min_damage: 1,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 10,
			Enums.StKey.hitstop : 3,
			Enums.StKey.hit_box_colliding_frame : 15,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstun: 8,
			Enums.StKey.blockstun: 8,
			},
		30 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 1,
			Enums.StKey.min_damage: 1,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 8,
			Enums.StKey.hitstop : 3,
			Enums.StKey.hit_box_colliding_frame : 10,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstun: 8,
			Enums.StKey.blockstun: 8,
			},
		60 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 1,
			Enums.StKey.min_damage: 1,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 6,
			Enums.StKey.hitstop : 3,
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstun: 8,
			Enums.StKey.blockstun: 8,
			},
		90 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.chip_damage: 1,
			Enums.StKey.min_damage: 1,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.attack_damage: 5,
			Enums.StKey.hitstop : 3,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstun: 8,
			Enums.StKey.blockstun: 8,
			},
		180 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Destroy : true,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = SGFixed.ONE*5
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.velocity_y] = -SGFixed.ONE*30
	state[Enums.StKey.accel_y] = -95536
	anim.play("Travel")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] % 40 == 0):
		state[Enums.StKey.accel_y] = SGFixed.mul(state[Enums.StKey.accel_y], -SGFixed.ONE)

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])):
		state[Enums.StKey.accel_x] = 35536
	elif (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]) or
			interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or 
			interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface])):
		state[Enums.StKey.accel_x] = -35536
	else:
		state[Enums.StKey.accel_x] = 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	pass
