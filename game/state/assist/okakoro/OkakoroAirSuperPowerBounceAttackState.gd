extends AssistAirAttackState

class_name OkakoroAirPowerBounceAttackState

var voice2 = preload("res://game/assets/voice/okayu/oky_oi.wav")

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
		1 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -1669474,
			Enums.StKey.Hit1ScaleX : 1026847, Enums.StKey.Hit1ScaleY : 506067,
			Enums.StKey.hitstop : 10,
			Enums.StKey.hitstun : 80,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*7,
			Enums.StKey.launch_dir_y : SGFixed.ONE*40,
			Enums.StKey.min_damage:8,
			Enums.StKey.chip_damage:8,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 120,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*7,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*40,
			},
		2 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	var old_accel = state[Enums.StKey.accel_y]
	super.enter(state)
	state[Enums.StKey.accel_y] = old_accel
	state[Enums.StKey.leftfaceOK] = false
	anim.stop(true)
	anim.play("AssistSuperAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 0):
		SyncManager.play_sound("OkakoroPowerBounceAttack", voice2, {"bus": "Voice"})

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	super.handle_input(state, interpreter)
	if (state[Enums.StKey.hitStopFrame] == 1):
		state[Enums.StKey.accel_y] += 30000
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*50
		state[Enums.StKey.velocity_x] = -SGFixed.mul(Util.BASE_STRIKE_X_PUSHBACK, Util.BASE_AIR_X_MULT)
		change_state.call("AssistAirSuperFall")

func exit_state():
	change_state.call("AssistAirSuperFall")

func combo_pushback(comboTime: int) -> int:
	return 0

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	# if (event_cause == Enums.Reaction.StrikeHit):
	# 	state[Enums.StKey.accel_y] += 30000
	# 	state[Enums.StKey.velocity_y] = -SGFixed.ONE*50
	# 	state[Enums.StKey.velocity_x] = -SGFixed.mul(Util.BASE_STRIKE_X_PUSHBACK, Util.BASE_AIR_X_MULT)
	# 	state[Enums.StKey.cancelState] = "AssistAirSuperFall"
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.hitStopFrame] <= 0):
			change_state.call("LandAttackRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
