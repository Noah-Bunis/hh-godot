extends KurokamiAirAttackState

class_name KurokamiAirGrappleState

func _init():
	endFrame = 80
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -10087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1071143,
			},
		20 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 7205568, Enums.StKey.Hit1PosY : -16646144,
			Enums.StKey.Hit1ScaleX : 857665, Enums.StKey.Hit1ScaleY : 734906,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -10087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1071143,
			Enums.StKey.Hurt2PosX : 7205568, Enums.StKey.Hurt2PosY : -16646144,
			Enums.StKey.Hurt2ScaleX : 957665, Enums.StKey.Hurt2ScaleY : 934906,
			Enums.StKey.attack_type : Enums.AttackType.AirThrow,
			Enums.StKey.counter_hit : Enums.AttackType.AirThrow,
			Enums.StKey.chip_damage: 0,
			Enums.StKey.min_damage: 0,
			Enums.StKey.attack_damage: 0,
			Enums.StKey.hitstop: 1,
			Enums.StKey.hitstun: 60,
			Enums.StKey.burst_OK: false,
			Enums.StKey.launch_dir_x : 0,
			Enums.StKey.launch_dir_y : 0,
			Enums.StKey.counter_launch_dir_x: 0,
			Enums.StKey.counter_launch_dir_y: 0,
			},
		80 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -10087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1071143,
			Enums.StKey.Hurt2PosX : 7205568, Enums.StKey.Hurt2PosY : -16646144,
			Enums.StKey.Hurt2ScaleX : 957665, Enums.StKey.Hurt2ScaleY : 934906,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.drag_x] = Util.SLIPPERY_FRICTION
	anim.play("Grapple")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*20
	elif (state[Enums.StKey.frame] == 20):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*40, state[Enums.StKey.velocity_x])
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*35
		state[Enums.StKey.drag_x] = 0
		state[Enums.StKey.accel_y] = Util.GRAVITY

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (boost_OK(state, interpreter)):
		change_state.call("AirBoostCancel")

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	super.reaction(state, interpreter, event_cause)
	if (event_cause == Enums.Reaction.ThrowHit):
		change_state.call("GrappleFollowup")
	elif (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.hitStopFrame] <= 0 and state[Enums.StKey.frame] >= 21):
			state[Enums.StKey.doubleJump] = 1
			state[Enums.StKey.airDash] = 1
			change_state.call("LandingRecovery")
	else:
		super.reaction(state, interpreter, event_cause)

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
