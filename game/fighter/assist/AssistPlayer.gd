extends "res://game/fighter/projectiles/BaseProjectilePlayer.gd"

class_name AssistPlayer

signal move_pilot (velocity_x, velocity_y, accel_x, accel_y)

func _init():
	super._init()
	add_to_group("fight_entity")
	add_to_group("network_sync")
	currentState[Enums.StKey.hitstun] = 0

func reset_hitboxes():
	if Hitbox1 != null:
		Hitbox1.reset_to_game_start()
		Hurtbox1.reset_to_game_start()
		Hitbox2.reset_to_game_start()
		Hurtbox2.reset_to_game_start()

func dim_sprite():
	$Sprite2D.material.set_shader_parameter("dimming", 0.8)

var pilot: BasePlayer

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
		Enums.StKey.ground_bounce : currentState.get(Enums.StKey.ground_bounce, 0),
		Enums.StKey.wall_bounce : currentState.get(Enums.StKey.wall_bounce, 0),
		Enums.StKey.leftface : currentState.get(Enums.StKey.leftface, false),
		Enums.StKey.leftfaceOK : currentState.get(Enums.StKey.leftfaceOK, false),
		Enums.StKey.frame : currentState.get(Enums.StKey.frame, 0),
		Enums.StKey.last_anim_frame : currentState.get(Enums.StKey.last_anim_frame, 0),
		Enums.StKey.hitStopFrame : currentState.get(Enums.StKey.hitStopFrame, -1),
		Enums.StKey.hit_box_colliding_frame : currentState.get(Enums.StKey.hit_box_colliding_frame, -1),
		Enums.StKey.hitstun : currentState.get(Enums.StKey.hitstun, 0),
		Enums.StKey.hit_cooldown : currentState.get(Enums.StKey.hit_cooldown, {}).duplicate(),
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
	currentState[Enums.StKey.ground_bounce] = state.get(Enums.StKey.ground_bounce, 0)
	currentState[Enums.StKey.wall_bounce] = state.get(Enums.StKey.wall_bounce, 0)
	currentState[Enums.StKey.leftface] = state.get(Enums.StKey.leftface, false)
	currentState[Enums.StKey.leftfaceOK] = state.get(Enums.StKey.leftfaceOK, false)
	currentState[Enums.StKey.frame] = state.get(Enums.StKey.frame, 0)
	currentState[Enums.StKey.last_anim_frame] = state.get(Enums.StKey.last_anim_frame, 0)
	currentState[Enums.StKey.hitStopFrame] = state.get(Enums.StKey.hitStopFrame, -1)
	currentState[Enums.StKey.hit_box_colliding_frame] = state.get(Enums.StKey.hit_box_colliding_frame, -1)
	currentState[Enums.StKey.hitstun] = state.get(Enums.StKey.hitstun, 0)
	currentState[Enums.StKey.hit_cooldown] = state.get(Enums.StKey.hit_cooldown, {}).duplicate()
	fighterState.update_rollback_state(currentState)
	fighterState.rollback_state_transition(currentState.get(Enums.StKey.stateName, "Neutral"))
	sync_to_physics_engine()

func setup(playerData:PlayerSetup):
	self.team = playerData.team
	currentState[Enums.StKey.leftface] = playerData.left_face
	var palette = Global.get_color_palette(not playerData.team, true)
	self.color_scheme = palette
	assert(palette != null)
	if (palette != null):
		$Sprite2D.material.set_shader_parameter("palette", palette)
	if (playerData.input_interpreter != null):
		self.input_interpreter = playerData.input_interpreter
	else:
		printerr("AssistPlayer: NULL input interpreter")
	Hitbox1 = get_node("Hitbox1")
	Hitbox2 = get_node("Hitbox2")
	Hurtbox1 = get_node("Hurtbox1")
	Hurtbox2 = get_node("Hurtbox2")
	for hitbox_name in ["Hitbox1", "Hitbox2"]:
		get_node(hitbox_name).setup(playerData.team, self.get_name())
	for hurtbox_name in ["Hurtbox1", "Hurtbox2"]:
		get_node(hurtbox_name).setup(playerData.team, self.get_name())
		
	if (fighterState == null):
		var state_factory: StateFactory
		match playerData.point_chara:
			Enums.AssistCharacters.Fubuki:
				state_factory = FubukiStateFactory.new()
			Enums.AssistCharacters.Sora:
				state_factory = SoraStateFactory.new()
			Enums.AssistCharacters.Sana:
				state_factory = load("res://game/state/assist/sana/sanastatefactory.gd").new()
			Enums.AssistCharacters.OkaKoro:
				state_factory = load("res://game/state/assist/okakoro/Okakorostatefactory.gd").new()
			Enums.AssistCharacters.Hakka:
				state_factory = load("res://game/state/assist/hakka/Hakkastatefactory.gd").new()
			Enums.AssistCharacters.Subaru:
				state_factory = load("res://game/state/assist/assistsubaru/assistsubarustatefactory.gd").new()
				dim_sprite()
			Enums.AssistCharacters.Mio:
				state_factory = load("res://game/state/assist/assistmio/AssistMiostatefactory.gd").new()
				dim_sprite()
			Enums.AssistCharacters.Oga:
				state_factory = load("res://game/state/assist/assistoga/assistogastatefactory.gd").new()
				dim_sprite()
			Enums.AssistCharacters.Ollie:
				state_factory = load("res://game/state/assist/assistollie/assistolliestatefactory.gd").new()
				dim_sprite()
			Enums.AssistCharacters.Suisei:
				state_factory = load("res://game/state/assist/assistsuisei/assistsuiseistatefactory.gd").new()
				dim_sprite()
			Enums.AssistCharacters.Kanata:
				state_factory = load("res://game/state/assist/assistkanata/assistkanatastatefactory.gd").new()
				dim_sprite()
			_:
				state_factory = FubukiStateFactory.new()
				printerr("invalid assist character given")
		super.state_factory_setup(state_factory)
	fighterState.change_state("Intro")

func tick() -> void:
	currentState["pilot_meter"] = pilot.currentState[Enums.StKey.super_meter]
	super.tick()
	if (currentState["_pos_y"] > Util.DEATH_PLANE_Y):
		fighterState.change_state("Dormant")
		fighterState.state_transition()
		warp_off_screen()

func getFirstFrameCollide() -> Dictionary:
	return getFirstFrameCollideHelper(["Hitbox1", "Hitbox2"])

func tick_box_collisions() -> void:
	for hitbox_name in ["Hitbox1", "Hitbox2"]:
		get_node(hitbox_name).process_collisions()

func warp_off_screen() -> void:
	var g_position = get_global_fixed_position()
	SyncManager.spawn("TagVFX", get_parent(), Global.TagVFX,
	{
		position_x = g_position.x,
		position_y = g_position.y,
		leftface = currentState[Enums.StKey.leftface],
	})
	fixed_position.x = 0
	fixed_position.y = -SGFixed.ONE * 30000
	sync_to_physics_engine()

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
		Hitbox2.disable(anim_frame.get(Enums.StKey.Hit2Disable, true))
		
		Hurtbox1.disable(anim_frame.get(Enums.StKey.Hurt1Disable, false))
		Hurtbox2.disable(anim_frame.get(Enums.StKey.Hurt2Disable, false))
		
		if (anim_frame.get(Enums.StKey.Hurt1Disable, false) == false and not anim_frame.has(Enums.StKey.Hurt1ScaleX)):
			Hurtbox1.fixed_position.x = hurtbox1_default_position_x()
			Hurtbox1.fixed_position.y = hurtbox1_default_position_y()
			Hurtbox1.fixed_scale.x = hurtbox1_default_scale_x()
			Hurtbox1.fixed_scale.y = hurtbox1_default_scale_y()
		else:
			Hurtbox1.fixed_position.x = anim_frame.get(Enums.StKey.Hurt1PosX, Hurtbox1.fixed_position.x)
			Hurtbox1.fixed_position.y = anim_frame.get(Enums.StKey.Hurt1PosY, Hurtbox1.fixed_position.y)
			Hurtbox1.fixed_scale.x = anim_frame.get(Enums.StKey.Hurt1ScaleX, Hurtbox1.fixed_scale.x)
			Hurtbox1.fixed_scale.y = anim_frame.get(Enums.StKey.Hurt1ScaleY, Hurtbox1.fixed_scale.y)
		
		if (anim_frame.get(Enums.StKey.Hurt2Disable, false) == false and not anim_frame.has(Enums.StKey.Hurt2ScaleX)):
			Hurtbox2.fixed_position.x = hurtbox2_default_position_x()
			Hurtbox2.fixed_position.y = hurtbox2_default_position_y()
			Hurtbox2.fixed_scale.x = hurtbox2_default_scale_x()
			Hurtbox2.fixed_scale.y = hurtbox2_default_scale_y()
		else:
			Hurtbox2.fixed_position.x = anim_frame.get(Enums.StKey.Hurt2PosX, Hurtbox2.fixed_position.x)
			Hurtbox2.fixed_position.y = anim_frame.get(Enums.StKey.Hurt2PosY, Hurtbox2.fixed_position.y)
			Hurtbox2.fixed_scale.x = anim_frame.get(Enums.StKey.Hurt2ScaleX, Hurtbox2.fixed_scale.x)
			Hurtbox2.fixed_scale.y = anim_frame.get(Enums.StKey.Hurt2ScaleY, Hurtbox2.fixed_scale.y)
			
		
		Hitbox1.fixed_position.x = anim_frame.get(Enums.StKey.Hit1PosX, Hitbox1.fixed_position.x)
		Hitbox1.fixed_position.y = anim_frame.get(Enums.StKey.Hit1PosY, Hitbox1.fixed_position.y)
		Hitbox2.fixed_position.x = anim_frame.get(Enums.StKey.Hit2PosX, Hitbox2.fixed_position.x)
		Hitbox2.fixed_position.y = anim_frame.get(Enums.StKey.Hit2PosY, Hitbox2.fixed_position.y)
		
		Hitbox1.fixed_scale.x = anim_frame.get(Enums.StKey.Hit1ScaleX, Hitbox1.fixed_scale.x)
		Hitbox1.fixed_scale.y = anim_frame.get(Enums.StKey.Hit1ScaleY, Hitbox1.fixed_scale.y)
		Hitbox2.fixed_scale.x = anim_frame.get(Enums.StKey.Hit2ScaleX, Hitbox2.fixed_scale.x)
		Hitbox2.fixed_scale.y = anim_frame.get(Enums.StKey.Hit2ScaleY, Hitbox2.fixed_scale.y)
		
		if(anim_frame.get(Enums.StKey.WarpOffScreen, false)):
			warp_off_screen()
		if (not anim_frame.is_empty()):
			summonHelper(anim_frame.get(Enums.StKey.Summon, ""))
	attackData[Enums.StKey.attack_type] = anim_frame.get(Enums.StKey.attack_type, Enums.AttackType.Strike)
	attackData[Enums.StKey.attack_damage] = anim_frame.get(Enums.StKey.attack_damage, 50)
	attackData[Enums.StKey.guard] = anim_frame.get(Enums.StKey.guard, Enums.GuardType.Mid)
	attackData[Enums.StKey.hitstun] = anim_frame.get(Enums.StKey.hitstun, Util.DEFAULT_HITSTUN)
	attackData[Enums.StKey.blockstun] = anim_frame.get(Enums.StKey.blockstun, Util.DEFAULT_BLOCKSTUN)
	attackData[Enums.StKey.hitstop] = anim_frame.get(Enums.StKey.hitstop, Util.DEFAULT_HITSTOP)
	attackData[Enums.StKey.chip_damage] = anim_frame.get(Enums.StKey.chip_damage, 5)
	attackData[Enums.StKey.min_damage] = anim_frame.get(Enums.StKey.min_damage, 10)
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

func summonVFX(VFXname: String, VFX) -> void:
	var g_position = get_global_fixed_position()
	SyncManager.spawn(VFXname, get_parent(), VFX,
	{
		position_x = g_position.x,
		position_y = g_position.y,
		leftface = currentState[Enums.StKey.leftface],
	})

func summonHelper(entity: String) -> void:
	if (entity == "superFlash"):
		emit_signal("super_freeze", get_global_fixed_position().x, get_global_fixed_position().y, currentState[Enums.StKey.leftface])
		SyncManager.play_sound("superflash", Global.SuperFlashSound, {"bus": "Sound"})
	elif (entity == "meterDump"):
		emit_signal("battery_player", -Util.LEVEL_ONE_SUPER, 0, 0)
	elif (entity == "knockdowndust"):
		summonVFX("KnockdownVFX", Global.KnockdownDustVFX)
	elif (entity == "WallBounceDust"):
		summonVFX("WallBounceDustVFX", Global.WallBounceDustVFX)
	elif (entity == "burst"):
		summonVFX("BurstVFX", Global.BurstVFX)

func tag_in(x : int, y : int, left_face : bool, grounded : bool, tag_attack: int) -> void:
	if (has_property(Enums.StateProperty.DormantAssist) and tag_attack != 12): # normal burst doesn't initiate summon
		currentState[Enums.StKey.leftface] = left_face
		if (left_face):
			fixed_position.x = x #+ SGFixed.ONE * 75
		else:
			fixed_position.x = x #- SGFixed.ONE * 75
		fixed_position.y = y
		sync_to_physics_engine()
	var g_position = get_global_fixed_position()
	SyncManager.spawn("TagVFX", get_parent(), Global.TagVFX,
	{
		position_x = g_position.x,
		position_y = g_position.y,
		leftface = currentState[Enums.StKey.leftface],
	})
	SyncManager.play_sound("rc", Global.RCSound, {"bus": "Sound"})
	currentState["tag_grounded"] = grounded
	currentState["tag_attack"] = tag_attack # , 1-9 (normals / gatlings), 10-11 (AssistGuardCancel) 12-13(Burst)
	fighterState.reaction(Enums.Reaction.TagCall, input_interpreter)

func freeze_player_sim() -> void:
	$NetworkAnimationPlayer.speed_scale = 0

func normal_strike_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, old_hit_stun: int, hit_data: Dictionary) -> void:
	var g_position = get_global_fixed_position()
	currentState[Enums.StKey.hitStopFrame] = opponent_attack[Enums.StKey.hitstop]
	SyncManager.spawn("HitVFX", get_parent(), Global.HitVFX,
	{
		position_x = g_position.x,
		position_y = g_position.y - Util.HIT_EFFECT_Y_OFFSET,
		leftface = currentState[Enums.StKey.leftface],
	})
	emit_signal("strike_hurt",
		SGFixed.to_int(
			SGFixed.mul(SGFixed.from_int(opponent_attack[Enums.StKey.attack_damage]), 65536)
			),
		1, false, false, opponent_attack[Enums.StKey.guard])

func on_attack_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hitbox_name: String = "Unknown") -> Dictionary:
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
			currentState[Enums.StKey.hitCount] += 1
			currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
			currentState[Enums.StKey.leftface] = not attack_leftface
			currentState[Enums.StKey.leftfaceOK] = false
			currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
			currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
			SyncManager.play_sound("hit1", Global.HitLV1Sound, {"bus": "Sound"})
			fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
			normal_strike_hurt(react_type, opponent_attack, leftface, 0, hit_data)
		Enums.Reaction.LaunchHurt:
			launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
		Enums.Reaction.GroundBounceHurt:
			currentState[Enums.StKey.ground_bounce] += 1
			launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
		Enums.Reaction.WallBounceHurt:
			currentState[Enums.StKey.wall_bounce] += 1
			launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
		Enums.Reaction.BurstLockHurt:
			pass
	return hit_data

func launcher_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hit_data):
	currentState[Enums.StKey.hitCount] += 1
	currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
	currentState[Enums.StKey.hitStopFrame] = opponent_attack[Enums.StKey.hitstop]
	currentState[Enums.StKey.leftface] = not attack_leftface
	currentState[Enums.StKey.leftfaceOK] = false
	currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
	currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
	SyncManager.play_sound("hit3", Global.HitLV3Sound, {"bus": "Sound"})
	fighterState.reaction(Enums.Reaction.LaunchHurt, input_interpreter)
	normal_strike_hurt(react_type, opponent_attack, leftface, 0, hit_data)

func skip_intro() -> void:
	fighterState.change_state("Dormant")
	warp_off_screen()
	fighterState.state_transition()

func hurtbox1_default_position_x() -> int:
	return 0
func hurtbox1_default_position_y() -> int:
	return -14337728
func hurtbox1_default_scale_x() -> int:
	return 926985
func hurtbox1_default_scale_y() -> int:
	return 1474037
func hurtbox2_default_position_x() -> int:
	return 0
func hurtbox2_default_position_y() -> int:
	return -14337728
func hurtbox2_default_scale_x() -> int:
	return 926985
func hurtbox2_default_scale_y() -> int:
	return 1474037
