extends Node2D

class_name FrameBar

var _previous_states: Dictionary = {}

func capture_state_changes(
	entity: BasePlayer,
	frame: int,
	move_frame_events: Array[FrameEvent] = []
) -> Array[FrameEvent]:
	var events: Array[FrameEvent] = []
	var instance_id = entity.get_instance_id()
	var state_name: String = entity.currentState.get(Enums.StKey.stateName, "Neutral")
	var properties: Dictionary = {}
	for state_property in Enums.StateProperty.values():
		properties[state_property] = entity.has_property(state_property)

	var all_hurtboxes_disabled := _are_all_hurtboxes_disabled(entity)
	var event_types := _get_event_types(
		entity,
		state_name,
		all_hurtboxes_disabled,
		move_frame_events
	)
	var current_state := {
		"state_name": state_name,
		"properties": properties,
		"event_types": event_types,
		"all_hurtboxes_disabled": all_hurtboxes_disabled,
	}
	if not _previous_states.has(instance_id):
		_previous_states[instance_id] = current_state
		return events

	var previous_state: Dictionary = _previous_states[instance_id]
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

	var state_changed: bool = previous_state["state_name"] != state_name
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
	return events

func _get_event_types(
	entity: BasePlayer,
	state_name: String,
	all_hurtboxes_disabled: bool,
	move_frame_events: Array[FrameEvent]
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

func print_newest_events(events: Array[FrameEvent]) -> void:
	for event in events:
		var event_type: String = FrameEvent.EventType.keys()[event.type]
		print("FrameEvent %s: %s (duration: %d)" % [
			event.source_name,
			event_type,
			event.duration,
		])
