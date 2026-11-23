extends RefCounted

class_name PunishHitboxSimulator

func get_attack_timing(move_state: State) -> Dictionary:
	if move_state.anim_data == null or move_state.anim_data.is_empty():
		return {}

	var first_active_frame := -1
	var last_active_frame := -1
	var hitbox_1_active := false
	var hitbox_2_active := false
	var attack_type: int = Enums.AttackType.Strike

	for frame in range(move_state.endFrame + 1):
		var frame_data: Dictionary = move_state.anim_data.get(frame, {})
		if frame_data.has(Enums.StKey.attack_type):
			attack_type = int(frame_data[Enums.StKey.attack_type])
		if frame_data.has(Enums.StKey.Hit1Disable):
			hitbox_1_active = not bool(
				frame_data[Enums.StKey.Hit1Disable]
			)
		if frame_data.has(Enums.StKey.Hit2Disable):
			hitbox_2_active = not bool(
				frame_data[Enums.StKey.Hit2Disable]
			)
		if not (hitbox_1_active or hitbox_2_active) \
				or attack_type == Enums.AttackType.BurstLock:
			continue

		if first_active_frame < 0:
			first_active_frame = frame
		last_active_frame = frame

	if first_active_frame < 0:
		return {}
	return {
		"startup": first_active_frame + 1,
		"first_active_frame": first_active_frame,
		"last_active_frame": last_active_frame,
	}

func will_move_hit_during_recovery(
	attacker: BasePlayer,
	move_state: State,
	opponent: BasePlayer,
	opponent_state: State,
	timing: Dictionary,
	action_delay: int,
	attacker_anchor: BasePlayer = null
) -> bool:
	if (
		not is_instance_valid(opponent)
		or opponent_state == null
		or opponent_state.anim_data == null
		or attacker.Hitbox1 == null
		or attacker.Hitbox2 == null
	):
		return false

	var attack_boxes := _get_collision_boxes(attacker, true)
	var hurt_boxes := _get_collision_boxes(opponent, false)
	if attack_boxes.is_empty() or hurt_boxes.is_empty():
		return false

	var attack_type: int = Enums.AttackType.Strike
	var current_opponent_frame := int(
		opponent.currentState.get(Enums.StKey.frame, 0)
	)
	var simulated_opponent_frame := current_opponent_frame
	var simulated_opponent_hitstop := int(
		opponent.currentState.get(Enums.StKey.hitStopFrame, -1)
	)
	var simulated_elapsed_frames := 0
	var attacker_transform := (
		attacker_anchor if attacker_anchor != null else attacker
	)
	var attacker_position: SGFixedVector2 = (
		attacker_transform.get_global_fixed_position()
	)
	var opponent_position: SGFixedVector2 = (
		opponent.get_global_fixed_position()
	)
	for move_frame in range(int(timing["last_active_frame"]) + 1):
		var attack_frame: Dictionary = move_state.anim_data.get(move_frame, {})
		_apply_collision_frame(attack_boxes, attack_frame, true)
		if attack_frame.has(Enums.StKey.attack_type):
			attack_type = int(attack_frame[Enums.StKey.attack_type])
		if move_frame < int(timing["first_active_frame"]):
			continue
		if not _can_hit_target(attack_type, opponent):
			continue

		var elapsed_frames := action_delay + move_frame + 1
		while simulated_elapsed_frames < elapsed_frames:
			simulated_elapsed_frames += 1
			if simulated_opponent_hitstop > 0:
				simulated_opponent_hitstop -= 1
			if simulated_opponent_hitstop <= 0:
				simulated_opponent_frame += 1
				var hurt_frame: Dictionary = opponent_state.anim_data.get(
					simulated_opponent_frame,
					{}
				)
				_apply_collision_frame(hurt_boxes, hurt_frame, false)
		if simulated_opponent_frame > opponent_state.endFrame:
			break

		var attack_rects: Array[Dictionary] = []
		for attack_box in attack_boxes:
			if attack_box["disabled"]:
				continue
			attack_rects.append(
				_get_world_collision_rect(
					attack_box,
					attacker_position,
					attacker_transform
				)
			)
		var hurt_rects: Array[Dictionary] = []
		for hurt_box in hurt_boxes:
			if hurt_box["disabled"]:
				continue
			hurt_rects.append(
				_get_world_collision_rect(
					hurt_box,
					opponent_position,
					opponent
				)
			)
		for attack_rect in attack_rects:
			for hurt_rect in hurt_rects:
				if _collision_rects_overlap(attack_rect, hurt_rect):
					return true
	return false

func _can_hit_target(attack_type: int, opponent: BasePlayer) -> bool:
	if opponent.fighterState == null:
		return false
	if attack_type == Enums.AttackType.BurstLock:
		return false
	if attack_type == Enums.AttackType.Throw:
		return opponent.fighterState.has_property(
			Enums.StateProperty.GroundThrowOK
		)
	if attack_type == Enums.AttackType.AirThrow:
		return opponent.fighterState.has_property(
			Enums.StateProperty.AirThrowOK
		)
	return not opponent.fighterState.has_property(
		Enums.StateProperty.StrikeInvul
	)

func _get_collision_boxes(entity: BasePlayer, is_hitbox: bool) -> Array[Dictionary]:
	var nodes: Array = []
	if is_hitbox:
		nodes = [entity.Hitbox1, entity.Hitbox2]
	else:
		nodes = [entity.Hurtbox1, entity.Hurtbox2, entity.Hurtbox3]

	var boxes: Array[Dictionary] = []
	for index in range(nodes.size()):
		var box = nodes[index]
		if not is_instance_valid(box) or not is_instance_valid(box.collision_shape) \
				or box.collision_shape.shape == null:
			continue
		boxes.append({
			"index": index,
			"position_x": int(box.fixed_position.x),
			"position_y": int(box.fixed_position.y),
			"scale_x": int(box.fixed_scale.x),
			"scale_y": int(box.fixed_scale.y),
			"rotation": int(box.fixed_rotation),
			"extents_x": int(box.collision_shape.shape.extents_x),
			"extents_y": int(box.collision_shape.shape.extents_y),
			"disabled": true if is_hitbox else box.collision_shape.disabled,
		})
	return boxes

func _apply_collision_frame(
	boxes: Array[Dictionary],
	frame_data: Dictionary,
	is_hitbox: bool
) -> void:
	for box in boxes:
		var index: int = box["index"]
		var disable_key: int
		var position_x_key: int
		var position_y_key: int
		var scale_x_key: int
		var scale_y_key: int
		if is_hitbox:
			disable_key = [
				Enums.StKey.Hit1Disable,
				Enums.StKey.Hit2Disable,
			][index]
			position_x_key = [
				Enums.StKey.Hit1PosX,
				Enums.StKey.Hit2PosX,
			][index]
			position_y_key = [
				Enums.StKey.Hit1PosY,
				Enums.StKey.Hit2PosY,
			][index]
			scale_x_key = [
				Enums.StKey.Hit1ScaleX,
				Enums.StKey.Hit2ScaleX,
			][index]
			scale_y_key = [
				Enums.StKey.Hit1ScaleY,
				Enums.StKey.Hit2ScaleY,
			][index]
		else:
			disable_key = [
				Enums.StKey.Hurt1Disable,
				Enums.StKey.Hurt2Disable,
				Enums.StKey.Hurt3Disable,
			][index]
			position_x_key = [
				Enums.StKey.Hurt1PosX,
				Enums.StKey.Hurt2PosX,
				Enums.StKey.Hurt3PosX,
			][index]
			position_y_key = [
				Enums.StKey.Hurt1PosY,
				Enums.StKey.Hurt2PosY,
				Enums.StKey.Hurt3PosY,
			][index]
			scale_x_key = [
				Enums.StKey.Hurt1ScaleX,
				Enums.StKey.Hurt2ScaleX,
				Enums.StKey.Hurt3ScaleX,
			][index]
			scale_y_key = [
				Enums.StKey.Hurt1ScaleY,
				Enums.StKey.Hurt2ScaleY,
				Enums.StKey.Hurt3ScaleY,
			][index]

		if frame_data.has(disable_key):
			box["disabled"] = bool(frame_data[disable_key])
		if frame_data.has(position_x_key):
			box["position_x"] = int(frame_data[position_x_key])
		if frame_data.has(position_y_key):
			box["position_y"] = int(frame_data[position_y_key])
		if frame_data.has(scale_x_key):
			box["scale_x"] = int(frame_data[scale_x_key])
		if frame_data.has(scale_y_key):
			box["scale_y"] = int(frame_data[scale_y_key])

func _get_world_collision_rect(
	box: Dictionary,
	position: SGFixedVector2,
	transform_source: BasePlayer
) -> Dictionary:
	var entity_scale_x := SGFixed.to_float(transform_source.fixed_scale.x)
	var entity_scale_y := SGFixed.to_float(transform_source.fixed_scale.y)
	var local_scale_x := SGFixed.to_float(box["scale_x"])
	var local_scale_y := SGFixed.to_float(box["scale_y"])
	var rotation_sign := -1.0 if entity_scale_x < 0.0 else 1.0
	var rotation := SGFixed.to_float(transform_source.fixed_rotation) + (
		SGFixed.to_float(box["rotation"]) * rotation_sign
	)
	var half_width := (
		SGFixed.to_float(box["extents_x"])
		* absf(entity_scale_x * local_scale_x)
	)
	var half_height := (
		SGFixed.to_float(box["extents_y"])
		* absf(entity_scale_y * local_scale_y)
	)
	var axis_x := Vector2(cos(rotation), sin(rotation))
	var axis_y := Vector2(-sin(rotation), cos(rotation))
	return {
		"center": Vector2(
			SGFixed.to_float(position.x)
				+ SGFixed.to_float(box["position_x"]) * entity_scale_x,
			SGFixed.to_float(position.y)
				+ SGFixed.to_float(box["position_y"]) * entity_scale_y
		),
		"half_width": half_width,
		"half_height": half_height,
		"axis_x": axis_x,
		"axis_y": axis_y,
	}

func _collision_rects_overlap(first: Dictionary, second: Dictionary) -> bool:
	var center_delta: Vector2 = second["center"] - first["center"]
	for axis in [
		first["axis_x"],
		first["axis_y"],
		second["axis_x"],
		second["axis_y"],
	]:
		var first_radius: float = (
			first["half_width"] * absf(axis.dot(first["axis_x"]))
			+ first["half_height"] * absf(axis.dot(first["axis_y"]))
		)
		var second_radius: float = (
			second["half_width"] * absf(axis.dot(second["axis_x"]))
			+ second["half_height"] * absf(axis.dot(second["axis_y"]))
		)
		if absf(center_delta.dot(axis)) > first_radius + second_radius:
			return false
	return true
