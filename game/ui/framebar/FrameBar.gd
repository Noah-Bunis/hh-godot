extends Control

class_name FrameBar

const FrameBarCellControl = preload("res://game/ui/framebar/FrameBarCell.gd")
const MAX_FRAME_HISTORY := 120

@export var frame_cell_scene: PackedScene

@onready var _panel: PanelContainer = $Panel
@onready var _duration_label_overlay: Control = $DurationLabels
@onready var _assist_rows: Array = [
	$Panel/Rows/AssistPlayer1,
	$Panel/Rows/AssistPlayer2,
]
@onready var _frame_rows: Array = [
	$Panel/Rows/AssistPlayer1,
	$Panel/Rows/Player1,
	$Panel/Rows/Player2,
	$Panel/Rows/AssistPlayer2,
]
@onready var _cell_rows: Array = [
	$Panel/Rows/AssistPlayer1/Cells,
	$Panel/Rows/Player1/Cells,
	$Panel/Rows/Player2/Cells,
	$Panel/Rows/AssistPlayer2/Cells,
]

var _previous_states: Dictionary = {}
var _frame_history: Dictionary = {}
var _duration_labels: Dictionary = {}
var _latest_activity_frame: int = 0
var _has_activity_frame := false
var _pending_frame: int = -1
var _pending_frame_types: Array = [-1, -1, -1, -1]
var _pending_row_mask: int = 0
var _pending_advancing_mask: int = 0
var _pending_annotation_mask: int = 0
var _pending_invincibility_mask: int = 0
var _frame_history_invincibility: Dictionary = {}
var _frame_cells: Array = []

func _ready() -> void:
	for row_index in range(4):
		var row_cells: Array = []
		for _column_index in range(MAX_FRAME_HISTORY):
			var cell: FrameBarCellControl = frame_cell_scene.instantiate()
			_cell_rows[row_index].add_child(cell)
			cell.get_node("DurationLabel").reparent(_duration_label_overlay, false)
			row_cells.append(cell)
		_frame_cells.append(row_cells)
	_refresh_frame_cells()

func set_assist_rows_visible(is_visible: bool) -> void:
	for row in _assist_rows:
		row.visible = is_visible

	var panel_height := 0.0
	for row in _frame_rows:
		if row.visible:
			panel_height += row.custom_minimum_size.y
	_panel.custom_minimum_size.y = panel_height
	_panel.offset_top = _panel.offset_bottom - panel_height

func reset_at_frame(frame: int) -> void:
	_previous_states.clear()
	_pending_frame = -1
	_pending_frame_types = [-1, -1, -1, -1]
	_pending_row_mask = 0
	_pending_advancing_mask = 0
	_pending_annotation_mask = 0
	_pending_invincibility_mask = 0
	_store_frame(frame, _pending_frame_types, _pending_invincibility_mask)
	_refresh_frame_cells()

func capture_state_changes(
	entity: BasePlayer,
	frame: int,
	move_frame_events: Array[FrameEvent] = []
) -> Array[FrameEvent]:
	var events: Array[FrameEvent] = []
	var instance_id = entity.get_instance_id()
	var previous_state: Dictionary = _previous_states.get(instance_id, {})
	var state_name: String = entity.currentState.get(Enums.StKey.stateName, "Neutral")
	var properties: Dictionary = {}
	for state_property in Enums.StateProperty.values():
		properties[state_property] = entity.has_property(state_property)

	var state_changed: bool = (
		not previous_state.is_empty()
		and previous_state["state_name"] != state_name
	)
	var all_hurtboxes_disabled := _are_all_hurtboxes_disabled(entity)
	if state_changed and not _has_current_state_hurtbox_data(entity):
		all_hurtboxes_disabled = false
	var first_active_seen: bool = (
		previous_state.get("first_active_seen", false)
		if previous_state.get("state_name", "") == state_name
		else false
	)
	var event_types := _get_event_types(
		entity,
		state_name,
		all_hurtboxes_disabled,
		move_frame_events,
		not first_active_seen
	)
	if event_types.has(FrameEvent.EventType.FIRST_ACTIVE):
		first_active_seen = true
	var cancel_target: String = str(previous_state.get("cancel_state", "")).to_lower()
	var normalized_state_name := state_name.to_lower()
	var is_pre_jump_state: bool = (
		normalized_state_name.contains("pre")
		and normalized_state_name.contains("jump")
	)
	var previous_jump_cancel_sequence: bool = previous_state.get(
		"jump_cancel_sequence",
		false
	)
	var jump_cancel_sequence: bool = false
	if is_pre_jump_state:
		jump_cancel_sequence = (
			previous_jump_cancel_sequence
			or (state_changed and cancel_target.contains("jump"))
		)
		if jump_cancel_sequence:
			event_types[FrameEvent.EventType.STARTUP] = 1
	if (
		not previous_state.is_empty()
		and previous_state["state_name"] == state_name
		and entity.currentState.get(Enums.StKey.hitstun, 0) <= 0
	):
		for stun_type in [
			FrameEvent.EventType.HITSTUN,
			FrameEvent.EventType.BLOCKSTUN,
		]:
			if previous_state["event_types"].has(stun_type):
				# The counter reaches zero before the reaction state exits next tick.
				event_types[stun_type] = 1
				break
	var current_state := {
		"state_name": state_name,
		"properties": properties,
		"event_types": event_types,
		"all_hurtboxes_disabled": all_hurtboxes_disabled,
		"cancel_state": entity.currentState.get(Enums.StKey.cancelState, ""),
		"jump_cancel_sequence": jump_cancel_sequence,
		"first_active_seen": first_active_seen,
	}
	if not _previous_states.has(instance_id):
		_previous_states[instance_id] = current_state
		_record_frame(entity, frame, event_types, events)
		return events

	var emitted_types: Dictionary = {}
	var invincibility_event: FrameEvent
	for event_type in event_types:
		if not previous_state["event_types"].has(event_type):
			var event := _create_event(entity, event_type, frame, event_types[event_type])
			events.append(event)
			emitted_types[event_type] = true
			if event_type == FrameEvent.EventType.INVINCIBILITY:
				invincibility_event = event

	var changed_properties: Dictionary = {}
	for state_property in properties:
		if previous_state["properties"][state_property] != properties[state_property]:
			changed_properties[state_property] = {
				"from": previous_state["properties"][state_property],
				"to": properties[state_property],
			}

	var hurtbox_state_changed: bool = (
		previous_state["all_hurtboxes_disabled"] != all_hurtboxes_disabled
	)
	if (hurtbox_state_changed or (all_hurtboxes_disabled and (state_changed or not changed_properties.is_empty()))):
		if invincibility_event == null:
			invincibility_event = _create_event(
				entity,
				FrameEvent.EventType.INVINCIBILITY,
				frame,
				1
			)
			events.append(invincibility_event)
			emitted_types[FrameEvent.EventType.INVINCIBILITY] = true
		if hurtbox_state_changed:
			invincibility_event.property_changes["all_hurtboxes_disabled"] = {
				"from": previous_state["all_hurtboxes_disabled"],
				"to": all_hurtboxes_disabled,
			}
		if all_hurtboxes_disabled and not changed_properties.is_empty():
			invincibility_event.property_changes["state_properties"] = changed_properties

	if state_changed and emitted_types.is_empty():
		var state_event := _create_event(entity, FrameEvent.EventType.STATE_CHANGE, frame, 1)
		state_event.previous_state_name = previous_state["state_name"]
		events.append(state_event)

	if not changed_properties.is_empty() and not all_hurtboxes_disabled:
		var property_event := _create_event(entity, FrameEvent.EventType.PROPERTY_CHANGE, frame, 1)
		property_event.property_changes = changed_properties
		events.append(property_event)

	_previous_states[instance_id] = current_state
	_record_frame(entity, frame, event_types, events)
	return events

func _get_event_types(
	entity: BasePlayer,
	state_name: String,
	all_hurtboxes_disabled: bool,
	move_frame_events: Array[FrameEvent],
	first_active_pending: bool
) -> Dictionary:
	var event_types: Dictionary = {}
	var normalized_state_name := state_name.to_lower()

	var state_transition_pending: bool = entity.currentState.get(
		Enums.StKey.transition_state_flag,
		false
	)
	var stun_state_name := normalized_state_name
	if state_transition_pending:
		var pending_state_name := str(
			entity.currentState.get(Enums.StKey.next_state, "")
		).to_lower()
		if not pending_state_name.is_empty():
			stun_state_name = pending_state_name

	var training_dummy_parry_enabled := false
	if entity.input_interpreter is DummyInputInterpreter:
		var training_dummy_input := entity.input_interpreter as DummyInputInterpreter
		training_dummy_parry_enabled = (
			training_dummy_input.blocking == Enums.TrainingBlock.ALL
			and training_dummy_input.block_type == Enums.TrainingBlockType.PARRY
		)

	if entity.currentState.get(Enums.StKey.hitstun, 0) > 0:
		if stun_state_name.contains("block"):
			event_types[FrameEvent.EventType.BLOCKSTUN] = entity.currentState[Enums.StKey.hitstun]
		elif not (state_transition_pending and training_dummy_parry_enabled):
			event_types[FrameEvent.EventType.HITSTUN] = entity.currentState[Enums.StKey.hitstun]

	if all_hurtboxes_disabled:
		event_types[FrameEvent.EventType.INVINCIBILITY] = 1

	var current_frame: int = entity.currentState.get(Enums.StKey.frame, 0)
	for move_event in move_frame_events:
		if first_active_pending \
				and move_event.type == FrameEvent.EventType.FIRST_ACTIVE \
				and current_frame == move_event.start_frame:
			event_types[FrameEvent.EventType.FIRST_ACTIVE] = 1
			continue
		if move_event.type in [
			FrameEvent.EventType.STARTUP,
			FrameEvent.EventType.ACTIVE,
			FrameEvent.EventType.RECOVERY,
		] and current_frame >= move_event.start_frame \
				and current_frame < move_event.start_frame + move_event.duration:
			event_types[move_event.type] = move_event.duration
			break
	return event_types

func _are_all_hurtboxes_disabled(entity: BasePlayer) -> bool:
	return (
		_is_hurtbox_disabled(entity.Hurtbox1)
		and _is_hurtbox_disabled(entity.Hurtbox2)
		and _is_hurtbox_disabled(entity.Hurtbox3)
	)

func _has_current_state_hurtbox_data(entity: BasePlayer) -> bool:
	if entity.fighterState == null or entity.fighterState.state == null:
		return false
	var current_frame: int = entity.currentState.get(Enums.StKey.frame, 0)
	var latest_animation_frame := -1
	var latest_animation_data: Dictionary = {}
	for animation_frame in entity.fighterState.state.anim_data:
		var animation_frame_number := int(animation_frame)
		if (
			animation_frame_number <= current_frame
			and animation_frame_number > latest_animation_frame
		):
			latest_animation_frame = animation_frame_number
			latest_animation_data = entity.fighterState.state.anim_data[animation_frame]
	return (
		latest_animation_data.has(Enums.StKey.Hurt1Disable)
		or latest_animation_data.has(Enums.StKey.Hurt2Disable)
		or latest_animation_data.has(Enums.StKey.Hurt3Disable)
	)

func _is_hurtbox_disabled(hurtbox) -> bool:
	if not is_instance_valid(hurtbox):
		return false
	return hurtbox.collision_shape.disabled

func _create_event(entity: BasePlayer, event_type: int, frame: int, duration: int) -> FrameEvent:
	var event := FrameEvent.new(event_type, frame, duration)
	event.source_name = str(entity.name)
	event.state_name = entity.currentState.get(Enums.StKey.stateName, "Neutral")
	return event

func _record_frame(
	entity: BasePlayer,
	frame: int,
	event_types: Dictionary,
	events: Array[FrameEvent]
) -> void:
	var row_index := _get_source_row(str(entity.name))
	if row_index < 0:
		return
	if _pending_frame != frame:
		if _pending_frame >= 0:
			assert(
			_pending_row_mask == 0b1111,
			"Incomplete frame capture: %d" % _pending_frame
		)
		_pending_frame = frame
		_pending_frame_types = [-1, -1, -1, -1]
		_pending_row_mask = 0
		_pending_advancing_mask = 0
		_pending_annotation_mask = 0
		_pending_invincibility_mask = 0
	_pending_frame_types[row_index] = _get_frame_type(event_types)
	if event_types.has(FrameEvent.EventType.INVINCIBILITY):
		_pending_invincibility_mask |= 1 << row_index
	if _has_advancing_event(event_types):
		_pending_advancing_mask |= 1 << row_index
	for event in events:
		if event.type in [
			FrameEvent.EventType.STATE_CHANGE,
			FrameEvent.EventType.PROPERTY_CHANGE,
		] \
				or not event.property_changes.is_empty():
			_pending_annotation_mask |= 1 << row_index
			break
	_pending_row_mask |= 1 << row_index
	if _pending_row_mask != 0b1111:
		return

	if _pending_advancing_mask != 0:
		_store_frame(
			_pending_frame,
			_pending_frame_types,
			_pending_invincibility_mask
		)
	for annotation_row_index in range(4):
		if _pending_annotation_mask & (1 << annotation_row_index):
			if _pending_frame_types[annotation_row_index] != FrameEvent.EventType.FIRST_ACTIVE:
				_annotate_previous_event(_pending_frame - 1, annotation_row_index)
	if _pending_advancing_mask != 0 or _pending_annotation_mask != 0:
		_refresh_frame_cells()
	_pending_frame = -1
	_pending_row_mask = 0

func _has_advancing_event(event_types: Dictionary) -> bool:
	for event_type in [
		FrameEvent.EventType.STARTUP,
		FrameEvent.EventType.ACTIVE,
		FrameEvent.EventType.RECOVERY,
		FrameEvent.EventType.HITSTUN,
		FrameEvent.EventType.BLOCKSTUN,
		FrameEvent.EventType.INVINCIBILITY,
		FrameEvent.EventType.FIRST_ACTIVE,
	]:
		if event_types.has(event_type):
			return true
	return false

func _store_frame(frame: int, frame_types: Array, invincibility_mask: int) -> void:
	_frame_history[frame] = frame_types.duplicate()
	_frame_history_invincibility[frame] = invincibility_mask
	_latest_activity_frame = frame
	_has_activity_frame = true

	for row_index in range(4):
		if frame_types[row_index] == FrameEvent.EventType.FIRST_ACTIVE:
			_annotate_startup_through_first_active(frame, row_index)
			continue
		var previous_event_frame := frame - 1
		var separated_by_gap := false
		while previous_event_frame >= frame - MAX_FRAME_HISTORY:
			var previous_frame_types: Array = _frame_history.get(previous_event_frame, [])
			if not previous_frame_types.is_empty():
				if previous_frame_types[row_index] >= 0:
					if (
						previous_frame_types[row_index] != FrameEvent.EventType.FIRST_ACTIVE
						and (separated_by_gap or previous_frame_types[row_index] != frame_types[row_index])
					):
						_annotate_previous_event(previous_event_frame, row_index)
					break
				separated_by_gap = true
			else:
				separated_by_gap = true
			previous_event_frame -= 1

	var first_visible_frame := frame - MAX_FRAME_HISTORY + 1
	for stored_frame in _frame_history.keys():
		if int(stored_frame) < first_visible_frame or int(stored_frame) > frame:
			_frame_history.erase(stored_frame)
	for label_frame in _duration_labels.keys():
		if int(label_frame) < first_visible_frame or int(label_frame) > frame:
			_duration_labels.erase(label_frame)
	for invincibility_frame in _frame_history_invincibility.keys():
		if int(invincibility_frame) < first_visible_frame or int(invincibility_frame) > frame:
			_frame_history_invincibility.erase(invincibility_frame)

func _annotate_startup_through_first_active(frame: int, row_index: int) -> void:
	var startup_duration := 0
	var previous_frame := frame - 1
	while previous_frame >= frame - MAX_FRAME_HISTORY:
		var frame_types: Array = _frame_history.get(previous_frame, [])
		if frame_types.is_empty() \
				or frame_types[row_index] != FrameEvent.EventType.STARTUP:
			break
		startup_duration += 1
		previous_frame -= 1
	var labels: Dictionary = _duration_labels.get(frame, {})
	labels[row_index] = startup_duration + 1
	_duration_labels[frame] = labels

func _annotate_previous_event(frame: int, row_index: int) -> void:
	var event_frame := -1
	var event_type := -1
	for frame_offset in range(MAX_FRAME_HISTORY):
		var frame_types: Array = _frame_history.get(frame - frame_offset, [])
		if frame_types.is_empty() or frame_types[row_index] < 0:
			continue
		event_frame = frame - frame_offset
		event_type = frame_types[row_index]
		break
	if event_frame < 0:
		return

	var duration := 1
	while duration < MAX_FRAME_HISTORY:
		var earlier_frame_types: Array = _frame_history.get(event_frame - duration, [])
		if earlier_frame_types.is_empty() or earlier_frame_types[row_index] != event_type:
			break
		duration += 1
	if event_type == FrameEvent.EventType.HITSTUN and duration == 1:
		return
	var labels: Dictionary = _duration_labels.get(event_frame, {})
	labels[row_index] = duration
	_duration_labels[event_frame] = labels

func _get_frame_type(event_types: Dictionary) -> int:
	for event_type in [
		FrameEvent.EventType.FIRST_ACTIVE,
		FrameEvent.EventType.ACTIVE,
		FrameEvent.EventType.STARTUP,
		FrameEvent.EventType.RECOVERY,
		FrameEvent.EventType.HITSTUN,
		FrameEvent.EventType.BLOCKSTUN,
	]:
		if event_types.has(event_type):
			return event_type
	return -1

func _refresh_frame_cells() -> void:
	if _frame_cells.is_empty():
		return
	var overlay_inverse_transform := _duration_label_overlay.get_global_transform().affine_inverse()
	for row_index in range(4):
		for column_index in range(MAX_FRAME_HISTORY):
			var sample_frame := (
				_latest_activity_frame - MAX_FRAME_HISTORY + 1 + column_index
			)
			var frame_type := -1
			if _has_activity_frame:
				var frame_types: Array = _frame_history.get(sample_frame, [])
				if not frame_types.is_empty():
					frame_type = frame_types[row_index]
			var invincibility_mask: int = _frame_history_invincibility.get(sample_frame, 0)
			var cell: FrameBarCellControl = _frame_cells[row_index][column_index]
			cell.set_duration_label_position(
				overlay_inverse_transform * cell.get_global_transform().origin
			)
			cell.set_frame_type(frame_type)
			cell.set_invincible((invincibility_mask & (1 << row_index)) != 0)
			var duration_labels: Dictionary = _duration_labels.get(sample_frame, {})
			if duration_labels.has(row_index):
				cell.set_duration_label(int(duration_labels[row_index]))
			else:
				cell.clear_duration_label()

func _get_source_row(source_name: String) -> int:
	if source_name == "AssistPlayer1":
		return 0
	if source_name == "Player1" or source_name == "ServerPlayer":
		return 1
	if source_name == "Player2" or source_name == "ClientPlayer":
		return 2
	if source_name == "AssistPlayer2":
		return 3
	return -1
