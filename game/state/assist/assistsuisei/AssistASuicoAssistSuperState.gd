extends AssistASuicoBaseAirAttackState

class_name AssistASuicoSuperState

func _init():
	endFrame = 85
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
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
		6 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 3080192, Enums.StKey.Hurt1PosY : -8257537,
			Enums.StKey.Hurt1ScaleX : 1096239, Enums.StKey.Hurt1ScaleY : 967118,
			Enums.StKey.Hurt2PosX : -9371648, Enums.StKey.Hurt2PosY : -2359296,
			Enums.StKey.Hurt2ScaleX : 871868, Enums.StKey.Hurt2ScaleY : 393004,
			},
		21 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 20316160, Enums.StKey.Hit1PosY : -27000830,
			Enums.StKey.Hit1ScaleX : 1774487, Enums.StKey.Hit1ScaleY : 672969,
			Enums.StKey.Hit2PosX : 12582912, Enums.StKey.Hit2PosY : -19529728,
			Enums.StKey.Hit2ScaleX : 1289170, Enums.StKey.Hit2ScaleY : 1076104,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 4259840, Enums.StKey.Hurt1PosY : -14942206,
			Enums.StKey.Hurt1ScaleX : 1096239, Enums.StKey.Hurt1ScaleY : 967118,
			Enums.StKey.Hurt2PosX : -12124160, Enums.StKey.Hurt2PosY : -5046271,
			Enums.StKey.Hurt2ScaleX : 871868, Enums.StKey.Hurt2ScaleY : 393004,
			Enums.StKey.hit_box_colliding_frame : 2,
			Enums.StKey.attack_damage: 35,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstop: 3,
			Enums.StKey.min_damage: 4,
			Enums.StKey.chip_damage: 3,
			Enums.StKey.hitstun: 25,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		80 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 4259840, Enums.StKey.Hurt1PosY : -14942206,
			Enums.StKey.Hurt1ScaleX : 1096239, Enums.StKey.Hurt1ScaleY : 967118,
			Enums.StKey.Hurt2PosX : -12124160, Enums.StKey.Hurt2PosY : -5046271,
			Enums.StKey.Hurt2ScaleX : 871868, Enums.StKey.Hurt2ScaleY : 393004,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.ICE_FRICTION
	state[Enums.StKey.accel_y] = 65536
	anim.stop(true)
	anim.play("ASuicoAssistSuper")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 20):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*11, state[Enums.StKey.velocity_x])
		# state[Enums.StKey.velocity_y] = -SGFixed.ONE*25
		state[Enums.StKey.drag_x] = 0
	elif (state[Enums.StKey.frame] == 55):
		state[Enums.StKey.accel_y] = Util.GRAVITY
		state[Enums.StKey.accel_x] = 0

func combo_pushback(comboTime: int) -> int:
	return 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		pass
		# if (state[Enums.StKey.frame] > 87 and state[Enums.StKey.hitStopFrame] <= 0):
		# 	change_state.call("ASuicoLandAttackRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
