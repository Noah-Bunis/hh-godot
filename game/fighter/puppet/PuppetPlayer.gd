extends "res://game/fighter/projectiles/BaseProjectilePlayer.gd"

class_name PuppetPlayer

# Fields

var pilot: PointPlayer

func _init():
	add_to_group("fight_entity")
	add_to_group("network_sync")

func reset_to_game_start():
	super.reset_to_game_start()
	currentState[Enums.StKey.cancelState] = ""
	
func _save_state() -> Dictionary:
	var state = super._save_state()
	state[Enums.StKey.cancelState] = currentState.get(Enums.StKey.cancelState, "")
	return state

func _load_state(state: Dictionary) -> void:
	currentState[Enums.StKey.cancelState] = state.get(Enums.StKey.cancelState, "")
	super._load_state(state)

func setup(playerData:PlayerSetup):
	super.setup(playerData)
	
	if (fighterState == null):
		var state_factory: StateFactory
		match playerData.point_chara:
			Enums.PuppetCharacters.Hato:
				state_factory = PuppetStateFactory.new()
			_:
				printerr("invalid puppet character given")
		super.state_factory_setup(state_factory)
	fighterState.change_state("Intro")

func tick() -> void:
	currentState["pilot_meter"] = pilot.currentState[Enums.StKey.super_meter]
	super.tick()

func mod_pushback():
	if (not has_property(Enums.StateProperty.DormantAssist)):
		if (currentState[Enums.StKey.modify_x] <= 0):
			currentState[Enums.StKey.modify_x] += Util.fixed_min(Util.SLIPPERY_FRICTION, -currentState[Enums.StKey.modify_x])
		else:
			currentState[Enums.StKey.modify_x] -= Util.fixed_max(Util.SLIPPERY_FRICTION, -currentState[Enums.StKey.modify_x])

func anim_updates() -> void:
	super.anim_updates()
	var anim_frame : Dictionary = fighterState.state.anim_data.get(currentState[Enums.StKey.frame], {})

	if (anim_frame.is_empty()):
		anim_frame = fighterState.state.anim_data.get(currentState[Enums.StKey.frame], {})
	else:
		currentState[Enums.StKey.last_anim_frame] = currentState[Enums.StKey.frame]
	
	if (currentState[Enums.StKey.last_anim_frame] == currentState[Enums.StKey.frame]):
		if(anim_frame.get(Enums.StKey.WarpOffScreen, false)):
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
		summonHelper(anim_frame.get(Enums.StKey.Summon, ""))

func summonVFX(VFXname: String, VFX) -> void: 
	var g_position = get_global_fixed_position()
	SyncManager.spawn(VFXname, get_parent(), VFX,
	{
		position_x = g_position.x,
		position_y = g_position.y,
		leftface = currentState[Enums.StKey.leftface],
	})

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	if (not entity.is_empty() and uninterrupted):
		if (not entity.is_empty()):
			if (entity == "superFlash"):
				emit_signal("super_freeze", get_global_fixed_position().x, get_global_fixed_position().y, currentState[Enums.StKey.leftface])
				SyncManager.play_sound("superflash", Global.SuperFlashSound, {"bus": "Sound"})
			elif (entity == "meterDump"):
				emit_signal("battery_player", -Util.LEVEL_ONE_SUPER, 0, 0)

func summon(x : int, y : int, left_face : bool) -> void:
#	currentState[Enums.StKey.leftface] = left_face
	update_left_face(left_face)
	if (left_face):
		fixed_position.x = x + SGFixed.ONE * 150
	else:
		fixed_position.x = x - SGFixed.ONE * 150
	fixed_position.y = y - SGFixed.ONE * 2
	sync_to_physics_engine()
	var g_position = get_global_fixed_position()
	SyncManager.spawn("TagVFX", get_parent(), Global.TagVFX,
	{
		position_x = g_position.x,
		position_y = g_position.y,
		leftface = currentState[Enums.StKey.leftface],
	})
	fighterState.change_state("Stand")

func getFirstFrameCollide() -> Dictionary:
	return getFirstFrameCollideHelper(["Hitbox1"])

func unsummon() -> void:
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
	fighterState.change_state("Dormant")

func meter_build() -> void:
	pass

func normal_strike_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, old_hit_stun: int, hit_data: Dictionary) -> void:
	var g_position = get_global_fixed_position()
	SyncManager.spawn("HitVFX", get_parent(), Global.HitVFX,
	{
		position_x = g_position.x,
		position_y = g_position.y - Util.HIT_EFFECT_Y_OFFSET,
		leftface = currentState[Enums.StKey.leftface],
	})
	emit_signal("strike_hurt", 1, 1, false, false, opponent_attack[Enums.StKey.guard])

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
			currentState[Enums.StKey.leftface] = not attack_leftface
			currentState[Enums.StKey.leftfaceOK] = false
			currentState[Enums.StKey.velocity_x] = 0
			currentState[Enums.StKey.velocity_y] = 0
			SyncManager.play_sound("hit1", Global.HitLV1Sound, {"bus": "Sound"})
			normal_strike_hurt(react_type, opponent_attack, leftface, 0, hit_data)
			fighterState.change_state("HurtStand")
		Enums.Reaction.LaunchHurt:
			launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
		Enums.Reaction.GroundBounceHurt:
			launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
		Enums.Reaction.WallBounceHurt:
			launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
		Enums.Reaction.BurstLockHurt:
			pass

	return hit_data

func launcher_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hit_data):
	currentState[Enums.StKey.leftface] = not attack_leftface
	currentState[Enums.StKey.leftfaceOK] = false
	currentState[Enums.StKey.velocity_x] = 0
	currentState[Enums.StKey.velocity_y] = 0
	SyncManager.play_sound("hit1", Global.HitLV1Sound, {"bus": "Sound"})
	normal_strike_hurt(react_type, opponent_attack, leftface, 0, hit_data)
	fighterState.change_state("HurtStand")
