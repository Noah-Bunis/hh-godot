extends Object

class_name State

var change_state
var anim : NetworkAnimationPlayer
var persistent_state
var anim_data : Dictionary 
var endFrame: int = 99
var _player: BasePlayer

func enter(state: Dictionary) -> void:
	state[Enums.StKey.accel_x] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.drag_x] = 0
	state[Enums.StKey.cancelState] = ""
	state[Enums.StKey.hitCount] = 0
	state[Enums.StKey.comboTime] = 0
	state[Enums.StKey.burst_OK] = true
	state[Enums.StKey.kara_OK] = true
	state[Enums.StKey.ground_bounce] = 0
	state[Enums.StKey.wall_bounce] = 0
	state[Enums.StKey.hitStopFrame] = -1
	state[Enums.StKey.counterOK] = false
	state[Enums.StKey.leftfaceOK] = true
	
	anim.stop(true)
#	anim.play("Idle")

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(_state: Dictionary) -> void:
	pass
	
func handle_input(_state: Dictionary, _interpreter: InputInterpreter) -> void:
	pass

func setup(_change_state, _animation_player, _persistent_state, p_player: BasePlayer):
	self.change_state = _change_state
	self.anim = _animation_player
	self.persistent_state = _persistent_state
	self._player = p_player

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.StrikeHurt):
		change_state.call("HurtStand")
	elif (event_cause == Enums.Reaction.BlockHurt):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])):
			change_state.call("CrouchBlock")
		else:
			change_state.call("StandBlock")
	elif (event_cause == Enums.Reaction.JustBlockHurt):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])):
			change_state.call("JustCrouchBlock")
		else:
			change_state.call("JustStandBlock")
	elif (event_cause == Enums.Reaction.ThrowHurt):
		change_state.call("HurtThrow")
	elif (event_cause == Enums.Reaction.LaunchHurt):
		change_state.call("HurtLaunch")
	elif (event_cause == Enums.Reaction.KOHurt):
		change_state.call("KO")

func has_property(_state: Dictionary, _property: int) -> bool:
	return false

func common_idle_transitions(state: Dictionary, interpreter: InputInterpreter) -> void:
	change_state.call(self.persistent_state.state_factory.common_idle_transitions(state, interpreter))

func level_1_OK(state: Dictionary) -> bool:
	return Global.level_1_OK(state)

func level_2_OK(state: Dictionary) -> bool:
	return Global.level_2_OK(state)

func level_3_OK(state: Dictionary) -> bool:
	return Global.level_3_OK(state)

func level_5_OK(state: Dictionary) -> bool:
	return Global.level_5_OK(state)

func assist_ok(state: Dictionary, interpreter: InputInterpreter) -> bool:
	return Global.assist_ok(state, interpreter)

func assist_meter_ok(state: Dictionary) -> bool:
	return Global.assist_meter_ok(state)
	
func super_assist_meter_ok(state: Dictionary) -> bool:
	return Global.super_assist_meter_ok(state)

func burst_OK(state: Dictionary, interpreter: InputInterpreter) -> bool:
	return Global.burst_OK(state, interpreter)

func boost_OK(state: Dictionary, interpreter: InputInterpreter) -> bool:
	return Global.boost_OK(state, interpreter)

func positive_bonus(state:Dictionary) -> bool:
	var true_vel_x:int = state[Enums.StKey.velocity_x]
	if (state[Enums.StKey.leftface]):
		true_vel_x *= -1
	
	if (true_vel_x < 0):
		return state[Enums.StKey.opponent_pos_x]-state["_pos_x"] < 0
	elif (true_vel_x > 0):
		return state[Enums.StKey.opponent_pos_x]-state["_pos_x"] > 0
	return false

func negative_penalty(state:Dictionary) -> bool:
	var true_vel_x:int = state[Enums.StKey.velocity_x]
	if (state[Enums.StKey.leftface]):
		true_vel_x *= -1
	if (true_vel_x < 0):
		return state[Enums.StKey.opponent_pos_x]-state["_pos_x"] > 0
	elif (true_vel_x > 0):
		return state[Enums.StKey.opponent_pos_x]-state["_pos_x"] < 0
	return false

func combo_pushback(_comboTime: int) -> int:
	return 0
