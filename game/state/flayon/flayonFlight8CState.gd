extends FlayonFlightBaseState

class_name FlayonFlight8CState

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
		4 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : -14435712, Enums.StKey.Hit1PosY : -8136510,
			Enums.StKey.Hit1ScaleX : 220696, Enums.StKey.Hit1ScaleY : 910074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -462144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 1122078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.hit_box_colliding_frame : 3,
			Enums.StKey.attack_damage: 10,
			Enums.StKey.min_damage: 3,
			Enums.StKey.meter_build: SGFixed.ONE*3000,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 2,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*25,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*0,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*25,
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
		19 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 10435712, Enums.StKey.Hit1PosY : -17136510,
			Enums.StKey.Hit1ScaleX : 820696, Enums.StKey.Hit1ScaleY : 1010074,
			Enums.StKey.Hit2PosX : 2629186, Enums.StKey.Hit2PosY : -12760256,
			Enums.StKey.Hit2ScaleX : 1026496, Enums.StKey.Hit2ScaleY : 850290,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 10435712, Enums.StKey.Hurt2PosY : -17136510,
			Enums.StKey.Hurt2ScaleX : 920696, Enums.StKey.Hurt2ScaleY : 1110074,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.min_damage: 5,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 14,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*45,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*8,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*45,
			},
		25 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 10435712, Enums.StKey.Hurt2PosY : -17136510,
			Enums.StKey.Hurt2ScaleX : 920696, Enums.StKey.Hurt2ScaleY : 1110074,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("FlightBash")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.super_meter] -= Util.FLIGHT_ATTACK_METER_DRAIN

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Flight2C"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Flight5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Flight5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Flight5A"
