extends FlayonFlightBaseState

class_name FlayonFlight2CIncreaseState

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
		4 : {
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
			Enums.StKey.hit_box_colliding_frame : 3, 
			Enums.StKey.Hit1PosX : 4629186, Enums.StKey.Hit1PosY : -12760256,
			Enums.StKey.Hit1ScaleX : 1026496, Enums.StKey.Hit1ScaleY : 850290,
			Enums.StKey.Hit2PosX : 15435712, Enums.StKey.Hit2PosY : -7136510,
			Enums.StKey.Hit2ScaleX : 820696, Enums.StKey.Hit2ScaleY : 810074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 15435712, Enums.StKey.Hurt2PosY : -7136510,
			Enums.StKey.Hurt2ScaleX : 920696, Enums.StKey.Hurt2ScaleY : 910074,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 7,
			Enums.StKey.chip_damage: 4,
			Enums.StKey.meter_build: SGFixed.ONE*1000,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 90,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : SGFixed.ONE*45,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*15,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*45,
			},
		20 : {
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
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.kara_OK] = false
	anim.play("Flight2CIncrease")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.super_meter] -= Util.FLIGHT_ATTACK_METER_DRAIN
	if (state[Enums.StKey.frame] == 4):
		SyncManager.play_sound("airtech", Global.AirTechSound, {"bus": "Sound"})
	elif (state[Enums.StKey.frame] == 8):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*25, state[Enums.StKey.velocity_x])
		state[Enums.StKey.velocity_y] = SGFixed.ONE*55

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func reaction(state: Dictionary, _interpreter: InputInterpreter, event_cause: int) -> void:
	if (state[Enums.StKey.hitStopFrame] <= 0 and event_cause == Enums.Reaction.GroundLand):
		state[Enums.StKey.doubleJump] = 1
		state[Enums.StKey.airDash] = 1
		state[Enums.StKey.leftfaceOK] = true
		change_state.call("Stand")
	else:
		super.reaction(state, _interpreter, event_cause)