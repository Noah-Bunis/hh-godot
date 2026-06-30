extends BasePlayer

class_name PointPlayer

# Fields

signal summon(x, y, left_face, grounded)
signal summonPuppet(x, y, left_face)
signal unsummonPuppet()

var yCameraOffset = 0
var hp_bar: Node2D

# TODO: round counters are just for angel install comeback check, don't write to them
# there's probably some observer design pattern we should use
var round_counter: Node2D

func _init():
	super._init()
	add_to_group("player_pushbox")
	currentState[Enums.StKey.burst_OK] = true
	currentState[Enums.StKey.kara_OK] = true
	currentState[Enums.StKey.burst_cost] = 1
	currentState[Enums.StKey.capture_anchor] = ""
	currentState[Enums.StKey.throw_protect] = 0

func reset_to_game_start():
	super.reset_to_game_start()
	currentState[Enums.StKey.burst_OK] = true
	currentState[Enums.StKey.burst_cost] = 1
	currentState[Enums.StKey.capture_anchor] = ""
	currentState[Enums.StKey.throw_protect] = 0
	currentState[Enums.StKey.kara_OK] = true

func _save_state() -> Dictionary:
	var state = super._save_state()
	state[Enums.StKey.burst_OK] = currentState.get(Enums.StKey.burst_OK, true)
	state[Enums.StKey.burst_cost] = currentState.get(Enums.StKey.burst_cost, 1)
	state[Enums.StKey.capture_anchor] = currentState.get(Enums.StKey.capture_anchor, "")
	state[Enums.StKey.throw_protect] = currentState.get(Enums.StKey.throw_protect, 0)
	state[Enums.StKey.kara_OK] = currentState.get(Enums.StKey.kara_OK, true)
	return state

func _load_state(state: Dictionary) -> void:
	currentState[Enums.StKey.burst_OK] = state.get(Enums.StKey.burst_OK, true)
	currentState[Enums.StKey.burst_cost] = state.get(Enums.StKey.burst_cost, 1)
	currentState[Enums.StKey.capture_anchor] = state.get(Enums.StKey.capture_anchor, "")
	currentState[Enums.StKey.throw_protect] = state.get(Enums.StKey.throw_protect, 0)
	currentState[Enums.StKey.kara_OK] = state.get(Enums.StKey.kara_OK, true)
	super._load_state(state)

func update_opponent_anchor(opponent: BasePlayer) -> void:
	var path : String = opponent.get_path()
	currentState[Enums.StKey.capture_anchor] = path


func anim_updates() -> void:
	super.anim_updates()
	var anim_frame : Dictionary = fighterState.state.anim_data.get(currentState[Enums.StKey.frame], {})
	
	if (anim_frame.is_empty()):
		anim_frame = fighterState.state.anim_data.get(currentState[Enums.StKey.last_anim_frame], {})
	else:
		currentState[Enums.StKey.last_anim_frame] = currentState[Enums.StKey.frame]
	if (currentState[Enums.StKey.last_anim_frame] == currentState[Enums.StKey.frame]):
		summonHelper(anim_frame.get(Enums.StKey.Summon, ""))

func tick() -> void:
	super.tick()
	if (currentState[Enums.StKey.throw_protect] > 0):
		currentState[Enums.StKey.throw_protect] -= 1

func anchor_move() -> void:
	if (fighterState.has_property(Enums.StateProperty.Capture)):
		var x_offset = 5026464
		var opponent_anchor:BasePlayer = get_node(currentState[Enums.StKey.capture_anchor])
		if (opponent_anchor.currentState[Enums.StKey.leftface]):
			x_offset *= -1
		self.fixed_position.x = opponent_anchor.fixed_position.x + x_offset
		self.fixed_position.y = opponent_anchor.fixed_position.y
		sync_to_physics_engine()

func summonVFX(VFXname: String, VFX, use_color_palette:bool = false) -> void: 
	var g_position = get_global_fixed_position()
	if (use_color_palette):
		SyncManager.spawn(VFXname, get_parent(), VFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
			color_palette = self.color_scheme,
		})
	else:
		SyncManager.spawn(VFXname, get_parent(), VFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})

func summonHelper(entity: String) -> void:
	if (not entity.is_empty()):
		var leftface_mult = 1
		if (currentState[Enums.StKey.leftface]):
			leftface_mult = -1
		
		if (entity == "assist"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				true,
				5)
		elif (entity == "assist2"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				true,
				2)
		elif (entity == "assistSuper"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				true,
				0)
		elif (entity == "airassist"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				false,
				5)
		elif (entity == "airassist2"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				false,
				2)
		elif (entity == "airassistSuper"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				false,
				0)
		elif (entity == "assistGuardCancel"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				true,
				10)
		elif (entity == "airassistGuardCancel"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				false,
				10)
		elif (entity == "assistWeakGuardCancel"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				true,
				11)
		elif (entity == "airassistWeakGuardCancel"):
			emit_signal("summon", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface],
				false,
				11)
		elif (entity == "hatoSummon"):
			emit_signal("summonPuppet", 
				fixed_position.x, 
				fixed_position.y, 
				currentState[Enums.StKey.leftface])
		elif (entity == "hatoUnsummon"):
			emit_signal("unsummonPuppet")
		elif (entity == "burst"):
			summonVFX("BurstVFX", Global.BurstVFX)
			if (Util.assist_burst_exhausted(currentState)):
				emit_signal("summon", 
					fixed_position.x, 
					fixed_position.y, 
					currentState[Enums.StKey.leftface],
					false,
					13)
			else:
				emit_signal("summon", 
					fixed_position.x, 
					fixed_position.y, 
					currentState[Enums.StKey.leftface],
					false,
					12)
		elif (entity == "RCVFX"):
			summonVFX("RCVFX", Global.RCVFX)
		elif (entity == "fairdash"):
			summonVFX("AirdashVFX", Global.AirdashVFX)
		elif (entity == "bairdash"):
			summonVFX("AirdashVFX", Global.AirdashVFX)
		elif (entity == "rundust"):
			summonVFX("RunDustVFX", Global.RunDustVFX)
		elif (entity == "backdashdust"):
			summonVFX("BackDashDustVFX", Global.BackDashDustVFX)
		elif (entity == "jumpdust"):
			summonVFX("JumpDustVFX", Global.JumpDustVFX)
		elif (entity == "knockdowndust"):
			summonVFX("KnockdownVFX", Global.KnockdownDustVFX)
		elif (entity == "WallBounceDust"):
			summonVFX("WallBounceDustVFX", Global.WallBounceDustVFX)
		elif (entity == "superjumpdust"):
			summonVFX("SuperJumpDustVFX", Global.SuperJumpDustVFX)
		elif (entity == "FDBubble"):
			summonVFX("FDBubbleVFX", Global.FDBubbleVFX)
		elif (entity == "IncreaseFlash"):
			summonVFX("IncreaseFlashVFX", Global.IncreaseFlashVFX)
		elif (entity == "ParryWhiff"):
			summonVFX("ParryWhiff", Global.ParryWhiffVFX)
		elif (entity == "RedParryFlash"):
			summonVFX("RedParryFlash", Global.RedParryFlashVFX)
		elif (entity == "superFlash"):
			emit_signal("super_freeze", get_global_fixed_position().x, get_global_fixed_position().y, currentState[Enums.StKey.leftface])
			SyncManager.play_sound("superflash", Global.SuperFlashSound, {"bus": "Sound"})

func assist_hurt(scaled:int, hitCount:int, invalid: bool, block: bool, guard: bool) -> void:
	if (currentState[Enums.StKey.assist_meter] <= Util.ASSIST_STOCK):
		emit_signal("strike_hurt", SGFixed.mul(scaled, 25536), currentState[Enums.StKey.hitCount], false, false, Enums.GuardType.Mid)
	else:
		currentState[Enums.StKey.sync_rate] -= scaled * 45536
		currentState[Enums.StKey.assist_meter] -= scaled * SGFixed.ONE*60

func puppet_hurt(scaled:int, hitCount:int, invalid: bool, block: bool, guard: bool) -> void:
	# 50 DMG
	emit_signal("strike_hurt", 50, currentState[Enums.StKey.hitCount], false, false, Enums.GuardType.Mid)
	currentState[Enums.StKey.sync_rate] -= 20 * 45536
	currentState[Enums.StKey.assist_meter] -= Util.ASSIST_STOCK # 40 * SGFixed.ONE*60

func getAssistMeter() -> int:
	return currentState.get(Enums.StKey.assist_meter, 0)
func getSuperMeter() -> int:
	return currentState.get(Enums.StKey.super_meter, 0)
func getSyncRate() -> int:
	return currentState.get(Enums.StKey.sync_rate, 0)
func getBurstOK() -> bool:
	return currentState.get(Enums.StKey.burst_OK, false) and (currentState[Enums.StKey.super_meter] >= currentState[Enums.StKey.burst_cost]*Util.LEVEL_ONE_SUPER)
func getBurstCost() -> int:
	return currentState.get(Enums.StKey.burst_cost, 6)

func support_battery(super_meter:int, sync_rate:int, assist_meter:int) -> void:
	currentState[Enums.StKey.super_meter] += super_meter
	currentState[Enums.StKey.sync_rate] += sync_rate
	currentState[Enums.StKey.assist_meter] += assist_meter

func move_from_assist_character(velocity_x:int, velocity_y:int, accel_x:int, accel_y:int) -> void:
	var g_position = get_global_fixed_position()
	currentState["_pos_x"] = g_position.x
	currentState["_pos_y"] = g_position.y
	if (currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
		if (standing_on_ground() and currentState[Enums.StKey.velocity_y] >= 0):
			currentState[Enums.StKey.velocity_x] += velocity_x
			currentState[Enums.StKey.velocity_y] = 0
		else:
			currentState[Enums.StKey.velocity_x] += velocity_x
			currentState[Enums.StKey.velocity_y] += velocity_y

func damage_scale(opponent_attack) -> int:
	return Util.damage_scaling(
		Util.guts_scaling(opponent_attack[Enums.StKey.attack_damage], hp_bar.currentHP), 
		opponent_attack[Enums.StKey.min_damage], 
		currentState[Enums.StKey.hitCount])

func setup(playerData:PlayerSetup):
	super.setup(playerData)
	Hitbox1 = get_node("Hitbox1")
	Hitbox2 = get_node("Hitbox2")
	Hurtbox1 = get_node("Hurtbox1")
	Hurtbox2 = get_node("Hurtbox2")
	Hurtbox3 = get_node("Hurtbox3")
	for hitbox_name in ["Hitbox1", "Hitbox2"]:
		get_node(hitbox_name).setup(playerData.team, self.get_name())
	for hurtbox_name in ["Hurtbox1", "Hurtbox2", "Hurtbox3"]:
		get_node(hurtbox_name).setup(playerData.team, self.get_name())
	
	if (fighterState == null):
		var state_factory
		match playerData.point_chara:
			Enums.PointCharacters.Subaru:
				state_factory = SubaruStateFactory.new()
				yCameraOffset = 11993088
			Enums.PointCharacters.Mio:
				state_factory = MioStateFactory.new()
				yCameraOffset = 11993088
			Enums.PointCharacters.Oga:
				state_factory = OgaStateFactory.new()
				yCameraOffset = 493088
			Enums.PointCharacters.Ollie:
				state_factory = load("res://game/state/ollie/olliestatefactory.gd").new()
				yCameraOffset = 11993088
			Enums.PointCharacters.Kanata:
				state_factory = load("res://game/state/kanata/kanatastatefactory.gd").new()
				yCameraOffset = 11993088
			Enums.PointCharacters.Suisei:
				state_factory = load("res://game/state/suisei/suiseistatefactory.gd").new()
				yCameraOffset = 993088
			Enums.PointCharacters.Flayon:
				state_factory = load("res://game/state/flayon/flayonstatefactory.gd").new()
				yCameraOffset = 11993088
			Enums.PointCharacters.Kurokami:
				state_factory = load("res://game/state/kurokami/kurokamistatefactory.gd").new()
				yCameraOffset = 11993088
			_:
				printerr("invalid point character given")
		super.state_factory_setup(state_factory)
	fighterState.change_state("Intro")

func has_property(property: int) -> bool:
	var prop: bool = super.has_property(property)
	if (property == Enums.StateProperty.AirThrowOK):
		return prop and currentState[Enums.StKey.throw_protect] <= 0
	elif (property == Enums.StateProperty.GroundThrowOK):
		return prop and currentState[Enums.StKey.throw_protect] <= 0
	else:
		return prop
