extends BasePlayer

class_name BaseProjectilePlayer

signal battery_player (super_meter, sync_rate, assist_meter)

func _init():
	super._init()
	add_to_group("fight_entity")
	add_to_group("network_sync")


func reset_hitboxes():
	if Hitbox1 != null:
		Hitbox1.reset_to_game_start()
		Hurtbox1.reset_to_game_start()

func reset_to_game_start():
	Util.reset_node_transform_state(self)
	currentState[Enums.StKey.stateName] = "Neutral"
	currentState[Enums.StKey.next_state] = "Neutral"
	currentState[Enums.StKey.transition_state_flag] = false
	currentState[Enums.StKey.velocity_x] = 0
	currentState[Enums.StKey.velocity_y] = 0
	currentState[Enums.StKey.accel_x] = 0
	currentState[Enums.StKey.accel_y] = 0
	currentState[Enums.StKey.drag_x] = 0
	currentState[Enums.StKey.modify_x] = 0
	currentState[Enums.StKey.leftface] = false
	currentState[Enums.StKey.leftfaceOK] = false
	currentState[Enums.StKey.frame] = 0
	currentState[Enums.StKey.last_anim_frame] = 0
	currentState[Enums.StKey.hitStopFrame] = -1
	currentState[Enums.StKey.hit_box_colliding_frame] = -1
	currentState[Enums.StKey.hit_cooldown] = {}
	reset_hitboxes()
	if (fighterState != null):
		fighterState.update_rollback_state(currentState)
		fighterState.rollback_state_transition(currentState.get(Enums.StKey.stateName, "Neutral"))
	sync_to_physics_engine()

func _save_state() -> Dictionary:
	var state = {
		Enums.StKey.stateName : currentState.get(Enums.StKey.stateName, "Neutral"),
		Enums.StKey.next_state : currentState.get(Enums.StKey.next_state, "Neutral"),
		Enums.StKey.transition_state_flag : currentState.get(Enums.StKey.transition_state_flag, false),
		Enums.StKey.velocity_x : currentState.get(Enums.StKey.velocity_x, 0),
		Enums.StKey.velocity_y : currentState.get(Enums.StKey.velocity_y, 0),
		Enums.StKey.accel_x : currentState.get(Enums.StKey.accel_x, 0),
		Enums.StKey.accel_y : currentState.get(Enums.StKey.accel_y, 0),
		Enums.StKey.drag_x : currentState.get(Enums.StKey.drag_x, 0),
		Enums.StKey.modify_x : currentState.get(Enums.StKey.modify_x, 0),
		Enums.StKey.leftface : currentState.get(Enums.StKey.leftface, false),
		Enums.StKey.leftfaceOK : currentState.get(Enums.StKey.leftfaceOK, false),
		Enums.StKey.frame : currentState.get(Enums.StKey.frame, 0),
		Enums.StKey.last_anim_frame : currentState.get(Enums.StKey.last_anim_frame, 0),
		Enums.StKey.hitStopFrame : currentState.get(Enums.StKey.hitStopFrame, -1),
		Enums.StKey.hit_cooldown : currentState.get(Enums.StKey.hit_cooldown, {}).duplicate(),
		Enums.StKey.hit_box_colliding_frame : currentState.get(Enums.StKey.hit_box_colliding_frame, -1),
	}
	Util.save_player_transform_state(self, state)
	return state

func _load_state(state: Dictionary) -> void:
	Util.load_node_transform_state(self, state)
	currentState[Enums.StKey.stateName] = state.get(Enums.StKey.stateName, "Neutral")
	currentState[Enums.StKey.next_state] = state.get(Enums.StKey.next_state, "Neutral")
	currentState[Enums.StKey.transition_state_flag] = state.get(Enums.StKey.transition_state_flag, false)
	currentState[Enums.StKey.velocity_x] = state.get(Enums.StKey.velocity_x, 0)
	currentState[Enums.StKey.velocity_y] = state.get(Enums.StKey.velocity_y, 0)
	currentState[Enums.StKey.accel_x] = state.get(Enums.StKey.accel_x, 0)
	currentState[Enums.StKey.accel_y] = state.get(Enums.StKey.accel_y, 0)
	currentState[Enums.StKey.drag_x] = state.get(Enums.StKey.drag_x, 0)
	currentState[Enums.StKey.modify_x] = state.get(Enums.StKey.modify_x, 0)
	currentState[Enums.StKey.leftface] = state.get(Enums.StKey.leftface, false)
	currentState[Enums.StKey.leftfaceOK] = state.get(Enums.StKey.leftfaceOK, false)
	currentState[Enums.StKey.frame] = state.get(Enums.StKey.frame, 0)
	currentState[Enums.StKey.last_anim_frame] = state.get(Enums.StKey.last_anim_frame, 0)
	currentState[Enums.StKey.hitStopFrame] = state.get(Enums.StKey.hitStopFrame, -1)
	currentState[Enums.StKey.hit_cooldown] = state.get(Enums.StKey.hit_cooldown, {}).duplicate()
	currentState[Enums.StKey.hit_box_colliding_frame] = state.get(Enums.StKey.hit_box_colliding_frame, -1)
	fighterState.update_rollback_state(currentState)
	fighterState.rollback_state_transition(currentState.get(Enums.StKey.stateName, "Neutral"))
	sync_to_physics_engine()

func _interpolate_state(old_state: Dictionary, new_state: Dictionary, weight: float) -> void:
	Util.interpolate_node_transform_state(self, old_state, new_state, weight)

func tick() -> void:
	fighterState.update_rollback_state(currentState)
	var g_position = get_global_fixed_position()
	currentState["_pos_x"] = g_position.x
	currentState["_pos_y"] = g_position.y
	fighterState.state_transition()
	fighterState.handle_input(self.input_interpreter)
	fighterState.state_transition()
	hit_stop_tick()
	# frame number matters after this point
	fighterState.physics_tick()
	movement_physics_tick()
	anim_updates() # super flash needs to happen last

func movement_physics_tick() -> void:
	var x_dir = 1
	if (currentState[Enums.StKey.leftface]):
		x_dir = -1
		self.fixed_scale.x = -1 * Util.fixed_abs(self.fixed_scale.x)
	else:
		self.fixed_scale.x = Util.fixed_abs(self.fixed_scale.x)
	
	if (currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
		currentState[Enums.StKey.velocity_x] = currentState.get(Enums.StKey.velocity_x, 0) + currentState.get(Enums.StKey.accel_x, 0)
		currentState[Enums.StKey.velocity_y] = currentState.get(Enums.StKey.velocity_y, 0) + currentState.get(Enums.StKey.accel_y, 0)
		
		if (currentState[Enums.StKey.velocity_x] <= 0):
			currentState[Enums.StKey.velocity_x] += Util.fixed_min(currentState.get(Enums.StKey.drag_x, 0), -currentState[Enums.StKey.velocity_x])
		else:
			currentState[Enums.StKey.velocity_x] -= Util.fixed_max(currentState.get(Enums.StKey.drag_x, 0), -currentState[Enums.StKey.velocity_x])
		mod_pushback()

		self.velocity = SGFixed.vector2(
				x_dir * (currentState.get(Enums.StKey.velocity_x, 0) + currentState.get(Enums.StKey.modify_x, 0)),
				currentState.get(Enums.StKey.velocity_y, 0)
			)
		move_and_slide()

func mod_pushback():
	if (currentState[Enums.StKey.modify_x] <= 0):
		currentState[Enums.StKey.modify_x] += Util.fixed_min(Util.MOD_FRICTION, -currentState[Enums.StKey.modify_x])
	else:
		currentState[Enums.StKey.modify_x] -= Util.fixed_max(Util.MOD_FRICTION, -currentState[Enums.StKey.modify_x])

func getFirstFrameCollide() -> Dictionary:
	return getFirstFrameCollideHelper(["Hitbox1"])

func tick_box_collisions() -> void:
	for hitbox_name in ["Hitbox1"]:
		get_node(hitbox_name).process_collisions()

func normal_strike_hit(_attack_type: int, opponent_hit_data: Dictionary) -> void:
	if (opponent_hit_data["hitType"] == Enums.HitType.PushBlock):
		currentState[Enums.StKey.modify_x] = Util.FD_PUSHBACK
	elif (opponent_hit_data["hitType"] == Enums.HitType.JustPushBlock):
		currentState[Enums.StKey.modify_x] = Util.IBFD_PUSHBACK
	currentState[Enums.StKey.modify_x] = Util.fixed_min(currentState[Enums.StKey.modify_x], 
	fighterState.state.combo_pushback(opponent_hit_data[Enums.StKey.comboTime]))
	if (opponent_hit_data["in_corner"] and standing_on_ground() and opponent_hit_data["hitType"] != Enums.HitType.Parry):
		currentState[Enums.StKey.modify_x] = Util.fixed_min(currentState[Enums.StKey.modify_x], Util.CORNER_PUSHBACK)

func on_attack_hit(attack_type: int, opponent_hit_data: Dictionary) -> void:
	var new_super_meter: int = attackData[Enums.StKey.meter_build]
	var new_sync_rate: int = 0
	var new_assist_meter: int = 0
	if (opponent_hit_data["counter"]):
		new_super_meter += SGFixed.ONE * 700
		new_sync_rate += SGFixed.ONE*14
	if (opponent_hit_data["otg"]):
		new_sync_rate += SGFixed.ONE*20
	if (currentState[Enums.StKey.hitStopFrame] < attackData[Enums.StKey.hitstop]):
		if (currentState[Enums.StKey.hitStopFrame] <= 0):
			 #and len(currentState[Enums.StKey.hit_cooldown]) <= 1
			currentState[Enums.StKey.hitStopFrame] = attackData[Enums.StKey.hitstop]
	match attack_type:
		Enums.AttackType.Strike:
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if(opponent_hit_data[Enums.StKey.comboTime] < 1):
					new_sync_rate += Util.SUPPORT_FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			elif (opponent_hit_data["hitType"] == Enums.HitType.Block):
				new_sync_rate += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.Launcher: 
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					new_sync_rate += Util.SUPPORT_FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			if (opponent_hit_data["hitType"] == Enums.HitType.Block):
				new_sync_rate += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.GroundBouncer:
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					new_sync_rate += Util.SUPPORT_FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			if (opponent_hit_data["hitType"] == Enums.HitType.Block):
				new_sync_rate += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.WallBouncer: 
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					new_sync_rate += Util.SUPPORT_FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			if (opponent_hit_data["hitType"] == Enums.HitType.Block):
				new_sync_rate += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.Throw:
			if (opponent_hit_data["hitType"] == Enums.HitType.Throw):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					new_sync_rate += Util.SUPPORT_FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.ThrowHit, input_interpreter)
		Enums.AttackType.AirThrow:
			if (opponent_hit_data["hitType"] == Enums.HitType.Throw):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					new_sync_rate += Util.SUPPORT_FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.ThrowHit, input_interpreter)
		Enums.AttackType.BurstLock:
			pass
	if (opponent_hit_data["hitType"] == Enums.HitType.Parry):
		currentState[Enums.StKey.hitStopFrame] = Util.PARRY_HIT_STOP + Util.PARRY_ATTACKER_EXTRA_HIT_STOP
		new_super_meter = 0
		new_sync_rate = 0
	if (opponent_hit_data["hitType"] == Enums.HitType.Projectile):
		new_super_meter = 0
		new_assist_meter = 0
		new_sync_rate = 0
	emit_signal("battery_player", new_super_meter, new_sync_rate, new_assist_meter)

func on_attack_hurt(react_type: int, _opponent_attack: Dictionary, _leftface: bool, _attack_leftface: bool, hitbox_name: String = "Unknown") -> Dictionary:
	var hit_data : Dictionary = {
		Enums.StKey.hitCount: 1,
		Enums.StKey.comboTime: 1,
		"hitType": Enums.HitType.Strike,
		"in_corner": false,
		"counter": false,
		"otg": false,
	}
	match react_type:
		Enums.Reaction.StrikeHurt:
			fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
		Enums.Reaction.LaunchHurt:
			fighterState.reaction(Enums.Reaction.LaunchHurt, input_interpreter)
		Enums.Reaction.GroundBounceHurt:
			fighterState.reaction(Enums.Reaction.LaunchHurt, input_interpreter)
		Enums.Reaction.WallBounceHurt:
			fighterState.reaction(Enums.Reaction.LaunchHurt, input_interpreter)
		Enums.Reaction.BurstLockHurt:
			pass
	return hit_data

func ground_land() -> void:
	fighterState.reaction(Enums.Reaction.GroundLand, input_interpreter)

func has_property(property: int) -> bool:
	if (fighterState != null):
		return fighterState.has_property(property)
	else:
		printerr("ProjectilePlayer: fighterState null for property: " + str(property))
		return false

#####################
# Projectile specific
#####################

func _network_spawn(data: Dictionary) -> void:
	reset_state()
	visible = true
	var spawn_position : SGFixedVector2 = SGFixedVector2.new()
	spawn_position.x = data['position_x']
	spawn_position.y = data['position_y']
	Hitbox1.disable(true)
	Hurtbox1.disable(true)
	set_global_fixed_position(spawn_position)
	sync_to_physics_engine()
	var spawn_input_interpreter
	if (data["input_interpreter"] == 0):
		spawn_input_interpreter = Global.server_input_interpreter
	else:
		spawn_input_interpreter = Global.client_input_interpreter
	var player_setup = PlayerSetup.new(
		data["left_face"],
		data["team"],
		data["point_chara"],
		data["color_scheme"],
		spawn_input_interpreter
	)
	if (data["left_face"]):
		self.fixed_scale.x = -1 * Util.fixed_abs(self.fixed_scale.x)
	$NetworkAnimationPlayer.seek(0.0, true)
	setup(player_setup)

func _network_despawn() -> void:
	visible = false
	self.fixed_scale.x = Util.fixed_abs(self.fixed_scale.x)
	$NetworkAnimationPlayer.stop(true)
	Hitbox1.disable(true)
	Hurtbox1.disable(true)
	reset_state()

func reset_state() -> void:
	currentState[Enums.StKey.stateName] = "Neutral" # "Neutral"
	currentState[Enums.StKey.next_state] = "Neutral" # "Neutral"
	currentState[Enums.StKey.transition_state_flag] = false
	currentState[Enums.StKey.velocity_x] = 0
	currentState[Enums.StKey.velocity_y] = 0
	currentState[Enums.StKey.accel_x] = 0
	currentState[Enums.StKey.accel_y] = 0
	currentState[Enums.StKey.drag_x] = 0
	currentState[Enums.StKey.modify_x] = 0
	currentState[Enums.StKey.leftface] = false
	currentState[Enums.StKey.leftfaceOK] = false
	currentState[Enums.StKey.frame] = 0
	currentState[Enums.StKey.last_anim_frame] = 0
	currentState[Enums.StKey.hitStopFrame] = -1 # -1
	currentState[Enums.StKey.hit_cooldown] = {}
	currentState[Enums.StKey.hit_box_colliding_frame] = -1 # -1

func setup(playerData:PlayerSetup):
	self.team = playerData.team 
	currentState[Enums.StKey.leftface] = playerData.left_face
	var palette = playerData.point_color
	self.color_scheme = palette
	assert(palette != null)
	if (palette != null):
		$Sprite2D.material.set_shader_parameter("palette", palette)
	if (playerData.input_interpreter != null):
		self.input_interpreter = playerData.input_interpreter
	else:
		printerr("BaseProjectilePlayer: NULL input interpreter")
	Hitbox1 = get_node("Hitbox1")
	Hurtbox1 = get_node("Hurtbox1")
	for hitbox_name in ["Hitbox1"]:
		get_node(hitbox_name).setup(playerData.team, self.get_name())
	for hurtbox_name in ["Hurtbox1"]:
		get_node(hurtbox_name).setup(playerData.team, self.get_name())

func anim_updates() -> void:
	var anim_frame : Dictionary = fighterState.state.anim_data.get(currentState[Enums.StKey.frame], {})
	
	if (anim_frame.is_empty()):
		anim_frame = fighterState.state.anim_data.get(currentState[Enums.StKey.last_anim_frame], {})
	else:
		currentState[Enums.StKey.last_anim_frame] = currentState[Enums.StKey.frame]
	
	if (currentState[Enums.StKey.last_anim_frame] == currentState[Enums.StKey.frame]):
		if (anim_frame.get(Enums.StKey.hit_box_colliding_frame, -1) >= 0 and currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
			currentState[Enums.StKey.hit_box_colliding_frame] = anim_frame.get(Enums.StKey.hit_box_colliding_frame, 254)
			currentState[Enums.StKey.hit_cooldown] = {}
		Hitbox1.disable(anim_frame.get(Enums.StKey.Hit1Disable, true))
		Hurtbox1.disable(anim_frame.get(Enums.StKey.Hurt1Disable, false))
		Hitbox1.fixed_position.x = anim_frame.get(Enums.StKey.Hit1PosX, Hitbox1.fixed_position.x)
		Hitbox1.fixed_position.y = anim_frame.get(Enums.StKey.Hit1PosY, Hitbox1.fixed_position.y)
		Hurtbox1.fixed_position.x = anim_frame.get(Enums.StKey.Hurt1PosX, Hurtbox1.fixed_position.x)
		Hurtbox1.fixed_position.y = anim_frame.get(Enums.StKey.Hurt1PosY, Hurtbox1.fixed_position.y)
		Hitbox1.fixed_scale.x = anim_frame.get(Enums.StKey.Hit1ScaleX, Hitbox1.fixed_scale.x)
		Hitbox1.fixed_scale.y = anim_frame.get(Enums.StKey.Hit1ScaleY, Hitbox1.fixed_scale.y)
		Hurtbox1.fixed_scale.x = anim_frame.get(Enums.StKey.Hurt1ScaleX, Hurtbox1.fixed_scale.x)
		Hurtbox1.fixed_scale.y = anim_frame.get(Enums.StKey.Hurt1ScaleY, Hurtbox1.fixed_scale.y)
		if (anim_frame.get(Enums.StKey.Destroy, false)):
			SyncManager.despawn(self)
	
	attackData[Enums.StKey.attack_type] = anim_frame.get(Enums.StKey.attack_type, Enums.AttackType.Strike)
	attackData[Enums.StKey.attack_damage] = anim_frame.get(Enums.StKey.attack_damage, 50)
	attackData[Enums.StKey.guard] = anim_frame.get(Enums.StKey.guard, Enums.GuardType.Mid)
	attackData[Enums.StKey.hitstun] = anim_frame.get(Enums.StKey.hitstun, Util.DEFAULT_HITSTUN)
	attackData[Enums.StKey.blockstun] = anim_frame.get(Enums.StKey.blockstun, Util.DEFAULT_BLOCKSTUN)
	attackData[Enums.StKey.hitstop] = anim_frame.get(Enums.StKey.hitstop, Util.DEFAULT_HITSTOP)
	attackData[Enums.StKey.chip_damage] = anim_frame.get(Enums.StKey.chip_damage, 3)
	attackData[Enums.StKey.min_damage] = anim_frame.get(Enums.StKey.min_damage, 3)
	attackData[Enums.StKey.meter_build] = anim_frame.get(Enums.StKey.meter_build, SGFixed.ONE*500)
	attackData[Enums.StKey.launch_dir_x] = anim_frame.get(Enums.StKey.launch_dir_x,  Util.BASE_STRIKE_X_PUSHBACK)
	attackData[Enums.StKey.launch_dir_y] = anim_frame.get(Enums.StKey.launch_dir_y,  Util.BASE_AIR_Y_PUSHBACK)
	attackData[Enums.StKey.block_dir_x] = anim_frame.get(Enums.StKey.block_dir_x,  Util.BASE_STRIKE_X_PUSHBACK)
	attackData[Enums.StKey.block_dir_y] = anim_frame.get(Enums.StKey.block_dir_y,  Util.BASE_AIR_Y_PUSHBACK)
	attackData[Enums.StKey.counter_hit] = anim_frame.get(Enums.StKey.counter_hit,  Enums.AttackType.Strike)
	attackData[Enums.StKey.burst_OK] = anim_frame.get(Enums.StKey.burst_OK,  true)
	attackData[Enums.StKey.counter_hitstun] = anim_frame.get(Enums.StKey.counter_hitstun, 0)
	attackData[Enums.StKey.counter_launch_dir_x] = anim_frame.get(Enums.StKey.counter_launch_dir_x, Util.BASE_STRIKE_X_PUSHBACK)
	attackData[Enums.StKey.counter_launch_dir_y] = anim_frame.get(Enums.StKey.counter_launch_dir_y, Util.BASE_AIR_Y_PUSHBACK)
	currentState[Enums.StKey.counterOK] = anim_frame.get(Enums.StKey.counterOK, false)

func point_hurt(_damage: int, _hitCount: int, _invalid: bool, block: bool, _guard: int) -> void:
	if (block):
		fighterState.reaction(Enums.Reaction.PointBlockHurt, input_interpreter)
	else:
		fighterState.reaction(Enums.Reaction.PointAttackHurt, input_interpreter)
