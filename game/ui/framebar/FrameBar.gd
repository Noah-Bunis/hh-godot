extends Control

class_name FrameBar

const MAX_FRAME_HISTORY := 120
const FRAME_CELL_WIDTH := 8.0
const FRAME_CELL_GAP := 2.0
const FRAME_CELL_STEP := FRAME_CELL_WIDTH + FRAME_CELL_GAP
const ROW_LABEL_WIDTH := 112.0
const PANEL_WIDTH := 1328.0
const PANEL_HEIGHT := 132.0
const ROW_HEIGHT := 21.0
const ROW_TOP := 34.0

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

func reset_at_frame(frame: int) -> void:
	_previous_states.clear()
	_pending_frame = -1
	_pending_frame_types = [-1, -1, -1, -1]
	_pending_row_mask = 0
	_pending_advancing_mask = 0
	_pending_annotation_mask = 0
	_pending_invincibility_mask = 0
	_store_frame(frame, _pending_frame_types, _pending_invincibility_mask)
	queue_redraw()

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

	var all_hurtboxes_disabled := _are_all_hurtboxes_disabled(entity)
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
	var state_changed: bool = (
		not previous_state.is_empty()
		and previous_state["state_name"] != state_name
	)
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
		queue_redraw()
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
	queue_redraw()
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
	if normalized_state_name.contains("parry") and normalized_state_name.contains("catch"):
		event_types[FrameEvent.EventType.PARRY_CATCH] = max(entity.fighterState.state.endFrame, 1)

	if entity.currentState.get(Enums.StKey.hitstun, 0) > 0:
		if normalized_state_name.contains("block"):
			event_types[FrameEvent.EventType.BLOCKSTUN] = entity.currentState[Enums.StKey.hitstun]
		else:
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
	_pending_frame = -1
	_pending_row_mask = 0

func _has_advancing_event(event_types: Dictionary) -> bool:
	for event_type in [
		FrameEvent.EventType.STARTUP,
		FrameEvent.EventType.ACTIVE,
		FrameEvent.EventType.RECOVERY,
		FrameEvent.EventType.HITSTUN,
		FrameEvent.EventType.BLOCKSTUN,
		FrameEvent.EventType.PARRY_CATCH,
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
	var labels: Dictionary = _duration_labels.get(event_frame, {})
	labels[row_index] = duration
	_duration_labels[event_frame] = labels

func _get_frame_type(event_types: Dictionary) -> int:
	for event_type in [
		FrameEvent.EventType.FIRST_ACTIVE,
		FrameEvent.EventType.ACTIVE,
		FrameEvent.EventType.STARTUP,
		FrameEvent.EventType.RECOVERY,
		FrameEvent.EventType.PARRY_CATCH,
		FrameEvent.EventType.HITSTUN,
		FrameEvent.EventType.BLOCKSTUN,
	]:
		if event_types.has(event_type):
			return event_type
	return -1

func _draw() -> void:
	var panel_position := Vector2(
		(size.x - PANEL_WIDTH) / 2.0,
		size.y - PANEL_HEIGHT - 24.0
	)
	var panel_rect := Rect2(panel_position, Vector2(PANEL_WIDTH, PANEL_HEIGHT))
	draw_rect(panel_rect, Color(0.035, 0.045, 0.065, 0.91))
	draw_rect(panel_rect, Color(0.55, 0.62, 0.72, 0.95), false, 2.0)

	var font := get_theme_default_font()
	var font_size := maxi(get_theme_default_font_size(), 14)
	var text_color := Color(0.93, 0.95, 1.0)
	var timeline_x := panel_position.x + 14.0 + ROW_LABEL_WIDTH
	var timeline_y := panel_position.y + ROW_TOP

	for row_index in range(4):
		var row_y := timeline_y + row_index * ROW_HEIGHT
		draw_string(
			font,
			Vector2(panel_position.x + 14.0, row_y + 13.0),
			_get_source_label_for_row(row_index),
			HORIZONTAL_ALIGNMENT_LEFT,
			ROW_LABEL_WIDTH - 8.0,
			font_size,
			text_color
		)
		draw_rect(
			Rect2(
				Vector2(timeline_x, row_y),
				Vector2(MAX_FRAME_HISTORY * FRAME_CELL_STEP, ROW_HEIGHT - 2.0)
			),
			Color(0.1, 0.12, 0.15, 0.85)
		)
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
			var is_invincible: bool = (invincibility_mask & (1 << row_index)) != 0
			var cell_position := Vector2(
				timeline_x + column_index * FRAME_CELL_STEP,
				row_y + 3.0
			)
			draw_rect(
				Rect2(cell_position, Vector2(FRAME_CELL_WIDTH, ROW_HEIGHT - 8.0)),
				_get_frame_color(frame_type)
			)
			if is_invincible:
				_draw_invincibility_filter(cell_position)
			if _has_activity_frame:
				var duration_labels: Dictionary = _duration_labels.get(sample_frame, {})
				if duration_labels.has(row_index):
					var duration_position := cell_position + Vector2(-8.0, 10.0)
					draw_string(
						font,
						duration_position + Vector2(1.0, 1.0),
						str(duration_labels[row_index]),
						HORIZONTAL_ALIGNMENT_CENTER,
						FRAME_CELL_WIDTH + 16.0,
						12,
						Color(0.0, 0.0, 0.0)
					)
					draw_string(
						font,
						duration_position,
						str(duration_labels[row_index]),
						HORIZONTAL_ALIGNMENT_CENTER,
						FRAME_CELL_WIDTH + 16.0,
						12,
						text_color
					)

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

func _draw_invincibility_filter(cell_position: Vector2) -> void:
	draw_line(
		cell_position + Vector2(1.0, 10.0),
		cell_position + Vector2(6.0, 3.0),
		Color(0.72, 0.98, 1.0, 0.95),
		1.5
	)

func _get_source_label_for_row(row_index: int) -> String:
	match row_index:
		0:
			return "P1 ASSIST"
		1:
			return "P1"
		2:
			return "P2"
		_:
			return "P2 ASSIST"

func _get_frame_color(event_type: int) -> Color:
	match event_type:
		FrameEvent.EventType.STARTUP:
			return Color(0.35, 0.72, 1.0)
		FrameEvent.EventType.ACTIVE:
			return Color(1.0, 0.42, 0.28)
		FrameEvent.EventType.RECOVERY:
			return Color(1.0, 0.75, 0.28)
		FrameEvent.EventType.HITSTUN:
			return Color(1.0, 0.3, 0.35)
		FrameEvent.EventType.BLOCKSTUN:
			return Color(0.75, 0.48, 1.0)
		FrameEvent.EventType.PARRY_CATCH:
			return Color(0.38, 0.95, 0.55)
		FrameEvent.EventType.FIRST_ACTIVE:
			return Color(0.95, 0.35, 0.9)
		_:
			return Color(0.24, 0.28, 0.33)
