extends KurokamiAirIdleState

class_name KurokamiBackDashState

func _init():
	endFrame = 18
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -2545184, Enums.StKey.Hurt1PosY : -16087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1171143,
			},
		4 : { 
			Enums.StKey.Summon : "backdashdust",
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -2545184, Enums.StKey.Hurt1PosY : -16087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 871143,
			},
		18 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -2545184, Enums.StKey.Hurt1PosY : -16087936,
			Enums.StKey.Hurt1ScaleX : 803537, Enums.StKey.Hurt1ScaleY : 1171143,
			},
	}
	
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("BackDash")
	state[Enums.StKey.accel_y] = Util.GRAVITY

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("skid", Global.SkidSound, {"bus": "Sound"})
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*18
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*45

	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 436)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] -= SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 5536)
		state[Enums.StKey.assist_meter] -= SGFixed.ONE*270

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.leftfaceOK] = false
	if (state[Enums.StKey.frame] == endFrame):
		common_jump_transitions(state, interpreter)
	
	if (boost_OK(state, interpreter)):
		change_state.call("AirBoostCancel")

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		_:
			return super.has_property(state,property)

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] >= 4):
			state[Enums.StKey.doubleJump] = 1
			state[Enums.StKey.airDash] = 1
			state[Enums.StKey.leftfaceOK] = true
			change_state.call("LandingRecovery")
	else:
		super.reaction(state, interpreter, event_cause)

