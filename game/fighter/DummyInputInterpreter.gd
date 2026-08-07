extends InputInterpreter

class_name DummyInputInterpreter

signal strike_hurt()

var player: PointPlayer


var stance = 0
var blocking = 0
var block_switch = 0
var block_type = 0
var air_recovery = 0
var counter_hit = 0

var guard_type = 0

var replay_initial_leftface: bool = false # which way was i facing when the recording started?
var game_left_face: bool = false # i could be turned around, so input 6 to block
var bit_input: int = 0

var load_frame_delay: int = 0 

var in_rollback: bool = false
var strike_hurt_frame_delay = 0 # pretty sure this exists due to bugs when rolling back on hitstop?
var strike_hurt_frame_cooldown = 0

#var input_history: String

func connect_signals():
	player.connect("strike_hurt", Callable(self, "hurt_response"))

func disconnect_signals():
	player.disconnect("strike_hurt", Callable(self, "hurt_response"))

func prep_for_replay():
	is_replaying = true
	replay_initial_leftface = game_left_face
	# replay_initial_leftface = player.currentState[Enums.StKey.leftface]

func hurt_response(damage: int, hitCount: int, invalid: bool, block: bool, guard:int) -> void:
	self.guard_type = guard
	if (not in_rollback):
		if (strike_hurt_frame_cooldown <= 0):
			if (blocking == Enums.TrainingBlock.ALL):
				if (not block):
					strike_hurt_frame_delay = 1
					strike_hurt_frame_cooldown = 0
				if (block_type == Enums.TrainingBlockType.FD or
					block_type == Enums.TrainingBlockType.IB or
					block_type == Enums.TrainingBlockType.IFD or
					block_type == Enums.TrainingBlockType.PARRY):
						strike_hurt_frame_delay = 1
						strike_hurt_frame_cooldown = 3
			elif (counter_hit != Enums.TrainingCounterHit.OFF):
				if (not block):
					strike_hurt_frame_delay = 1
					strike_hurt_frame_cooldown = 3

# return the forced rollback's inputs
func hurt_response_override(tick: int) -> Dictionary:
	var input: Dictionary
	var bit_input = 0
	if (blocking == Enums.TrainingBlock.ALL):
		bit_input = block(bit_input, stance)
		if (block_switch == Enums.TrainingBlockSwitch.ENABLED):
			if (guard_type == Enums.GuardType.Low):
				bit_input = block(bit_input, Enums.TrainingStance.CROUCH)
			elif (guard_type == Enums.GuardType.High):
				bit_input = block(bit_input, Enums.TrainingStance.STAND)
		else:
			bit_input = change_stance(bit_input, stance)
			
		if (block_type == Enums.TrainingBlockType.FD):
			bit_input = BC_hold(bit_input)
		elif (block_type == Enums.TrainingBlockType.IFD):
			if (tick > 0):
				bit_input = release_stick(bit_input)
			else:
				bit_input = BC_hold(bit_input)
		elif (block_type == Enums.TrainingBlockType.IB):
			if (tick > 0):
				bit_input = release_stick(bit_input)
		elif (block_type == Enums.TrainingBlockType.PARRY):
			bit_input = release_stick(bit_input)
			if (tick <= 0):
				if (block_switch == Enums.TrainingBlockSwitch.ENABLED):
					if (guard_type == Enums.GuardType.Low):
						bit_input = change_stance(bit_input, Enums.TrainingStance.CROUCH)
					elif (guard_type == Enums.GuardType.High):
						bit_input = change_stance(bit_input, Enums.TrainingStance.STAND)
					elif (guard_type == Enums.GuardType.Mid):
						bit_input = change_stance(bit_input, Enums.TrainingStance.STAND)
				bit_input = BC_hold(bit_input)
	elif (counter_hit != Enums.TrainingCounterHit.OFF):
		if (counter_hit == Enums.TrainingCounterHit.ASSIST_DANGER):
#			if (tick == ):
			bit_input = mash_assist(bit_input)
		elif (counter_hit == Enums.TrainingCounterHit.ON):
			if (tick == 0):
				bit_input = mash(bit_input)
				bit_input = change_stance(bit_input, stance)
	if (game_left_face):
		if (bit_input & Enums.InputFlags.RIGHT):
			bit_input &= ~Enums.InputFlags.RIGHT
			bit_input |= Enums.InputFlags.LEFT
		elif (bit_input & Enums.InputFlags.LEFT):
			bit_input &= ~Enums.InputFlags.LEFT
			bit_input |= Enums.InputFlags.RIGHT
	input[Enums.PlayerInput.InputVector] = bit_input
	return input

func clear_input():
	bit_input = 0
#	dump_ordered_input_history()
	load_frame_delay = SyncManager.input_delay

func _network_process(input: Dictionary) -> void:
	super._network_process(input)
	if (load_frame_delay > 0):
		load_frame_delay -= 1
	if (not in_rollback):
		if (not is_replaying):
			if (strike_hurt_frame_cooldown > 0):
				strike_hurt_frame_cooldown -= 1
			if (strike_hurt_frame_delay > 0):
				strike_hurt_frame_delay -= 1
				emit_signal("strike_hurt")

func read_input() -> Dictionary:
	var input := {}
	if (load_frame_delay > 0):
		bit_input = 0
		input[Enums.PlayerInput.InputVector] = bit_input
		return input
	if (not is_replaying):
		if (player.currentState[Enums.StKey.comboTime] > 0 and player.currentState[Enums.StKey.hitstun] < 5):
			bit_input = tech(bit_input, air_recovery)
		
		bit_input = change_stance(bit_input, stance)
		
		if (game_left_face):
			if (bit_input & Enums.InputFlags.RIGHT):
				bit_input &= ~Enums.InputFlags.RIGHT
				bit_input |= Enums.InputFlags.LEFT
			elif (bit_input & Enums.InputFlags.LEFT):
				bit_input &= ~Enums.InputFlags.LEFT
				bit_input |= Enums.InputFlags.RIGHT
	else:
		bit_input = replay_input
		if (self.replay_initial_leftface):
			if (bit_input & Enums.InputFlags.RIGHT):
				bit_input &= ~Enums.InputFlags.RIGHT
				bit_input |= Enums.InputFlags.LEFT
			elif (bit_input & Enums.InputFlags.LEFT):
				bit_input &= ~Enums.InputFlags.LEFT
				bit_input |= Enums.InputFlags.RIGHT
	input[Enums.PlayerInput.InputVector] = bit_input
	bit_input = 0
	return input

func BC_hold(bit_input: int):
	bit_input |= Enums.InputFlags.BHold
	bit_input |= Enums.InputFlags.CHold
	return bit_input

func BC_down(bit_input: int):
	bit_input |= Enums.InputFlags.BDown
	bit_input |= Enums.InputFlags.CDown
	return bit_input

func block(bit_input: int, stance: int):
	bit_input |= Enums.InputFlags.LEFT
	if (stance == Enums.TrainingStance.CROUCH):
		bit_input |= Enums.InputFlags.DOWN
	elif (stance == Enums.TrainingStance.STAND):
		bit_input &= ~Enums.InputFlags.DOWN
	return bit_input

func change_stance(bit_input: int, stance: int):
	if (stance == Enums.TrainingStance.CROUCH):
		bit_input |= Enums.InputFlags.DOWN
	elif (stance == Enums.TrainingStance.JUMP):
		bit_input |= Enums.InputFlags.UP
	else:
		bit_input &= ~Enums.InputFlags.DOWN
		bit_input &= ~Enums.InputFlags.UP
	return bit_input

func tech(bit_input: int, direction: int):
	if (direction != Enums.TrainingRecovery.OFF):
		bit_input |= Enums.InputFlags.AHold
		
	if (direction == Enums.TrainingRecovery.FORWARD):
		bit_input |= Enums.InputFlags.RIGHT
	elif (direction == Enums.TrainingRecovery.BACKWARD):
		bit_input |= Enums.InputFlags.LEFT
#	elif (direction == Enums.TrainingRecovery.NEUTRAL):
#		bit_input |= Enums.InputFlags.DOWN
	return bit_input

func mash(bit_input: int):
	bit_input |= Enums.InputFlags.BHold
	return bit_input

func mash_assist(bit_input: int):
	bit_input |= Enums.InputFlags.DHold
	return bit_input

func release_stick(bit_input: int):
	bit_input &= ~Enums.InputFlags.DOWN
	bit_input &= ~Enums.InputFlags.RIGHT
	bit_input &= ~Enums.InputFlags.LEFT
	bit_input &= ~Enums.InputFlags.UP
	return bit_input

func is_just_blocking(leftface) -> bool:
	# override for just block window
	if (block_type == Enums.TrainingBlockType.IFD or block_type == Enums.TrainingBlockType.IB):
		var TRAINING_DUMMY_JUST_BLOCK_WINDOW = 2
		var bit_direction = Enums.InputFlags.LEFT
		if (leftface):
			bit_direction = Enums.InputFlags.RIGHT
		for i in range(TRAINING_DUMMY_JUST_BLOCK_WINDOW):
			if (tap_switch_direction(i, bit_direction)):
				return true
		return false
	return false
