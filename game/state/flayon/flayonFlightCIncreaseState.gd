extends FlayonFlightBaseState

class_name FlayonFlightCIncreaseState

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
		3 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "IncreaseFlash",
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 14629186, Enums.StKey.Hit1PosY : -18760254,
			Enums.StKey.Hit1ScaleX : 1626496, Enums.StKey.Hit1ScaleY : 850290,
			Enums.StKey.Hit2PosX : 12155775, Enums.StKey.Hit2PosY : -17468801,
			Enums.StKey.Hit2ScaleX : 997940, Enums.StKey.Hit2ScaleY : 947094,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 12976128, Enums.StKey.Hurt2PosY : -20774912,
			Enums.StKey.Hurt2ScaleX : 1535050, Enums.StKey.Hurt2ScaleY : 643629,
			Enums.StKey.attack_damage: 75,
			Enums.StKey.min_damage: 15,
			Enums.StKey.chip_damage:8,
			Enums.StKey.meter_build: SGFixed.ONE*3000,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 30,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*55,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*65,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*55,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*65,
			},
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.kara_OK] = false
	anim.play("FlightCIncrease")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.super_meter] -= Util.FLIGHT_ATTACK_METER_DRAIN
	if (state[Enums.StKey.frame] == 4):
		SyncManager.play_sound("airtech", Global.AirTechSound, {"bus": "Sound"})

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Flight2C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N7, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N8, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N9, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Flight8C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Flight5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Flight5A"
