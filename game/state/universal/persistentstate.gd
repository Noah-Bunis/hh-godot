# persistent_state.gd

class_name PersistentState

var state: State # Which state machine state are we in?
var state_factory: StateFactory # Get states from here
var anim : NetworkAnimationPlayer # contain a reference so that you can give it to new states
var player: BasePlayer # try not to access things directly, this was intended to update things like the player's z index

# Stores reference to fighter's rollback compliant state
var rollback_state: Dictionary

func _init(roll_state: Dictionary, _state_factory: StateFactory, 
			_anim: NetworkAnimationPlayer, p_player: BasePlayer):
	update_rollback_state(roll_state)
	self.state_factory = _state_factory
	self.state_factory.instantiate_states()
	self.anim = _anim
	self.player = p_player
	change_state("Neutral")
	state_change_helper("Neutral")

func free_states():
	state_factory.free_states()

func update_rollback_state(roll_state: Dictionary) -> void:
	rollback_state = roll_state

func handle_input(input_interpreter: InputInterpreter) -> void:
	if (input_interpreter != null):
		state.handle_input(rollback_state, input_interpreter)
	else:
		printerr("PersistentState: NULL input interpreter")
	
func physics_tick() -> void:
	state.physics_tick(rollback_state)

func reaction(event_cause: int, input_interpreter: InputInterpreter) -> void:
	state.reaction(rollback_state, input_interpreter, event_cause)

func has_property(property: int) -> bool:
	if (state != null):
		return state.has_property(rollback_state, property)
	else:
		# probably StrikeInvul from projectile for collision resolving on projectile clash
		printerr("PersistentState: fighterState null for property: " + str(property))
		return false

func state_transition() -> void:
	if (rollback_state[Enums.StKey.transition_state_flag]):
		state_change_helper(rollback_state[Enums.StKey.next_state])
		state.enter(rollback_state)
		rollback_state[Enums.StKey.frame] = -1
		rollback_state[Enums.StKey.transition_state_flag] = false

func change_state(new_state_name: String) -> void:
	rollback_state[Enums.StKey.next_state] = new_state_name
	rollback_state[Enums.StKey.transition_state_flag] = true

func rollback_state_transition(new_state_name: String) -> void:
	state_change_helper(new_state_name)

func state_change_helper(new_state_name: String) -> void:
	state = state_factory.get_state(new_state_name)
	state.setup(self.change_state, anim, self, self.player)
	rollback_state[Enums.StKey.stateName] = new_state_name
