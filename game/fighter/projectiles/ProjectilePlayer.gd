extends "res://game/fighter/projectiles/BaseProjectilePlayer.gd"

class_name ProjectilePlayer

func _init():
	super._init()
	set_initial_projectile_hp()

func set_initial_projectile_hp():
	currentState[Enums.StKey.projectile_hp] = 1

func reset_state() -> void:
	super.reset_state()
	set_initial_projectile_hp()

func _ready():
	super._ready()
	Hitbox1 = get_node("Hitbox1")
	Hurtbox1 = get_node("Hurtbox1")
	Hurtbox1.fixed_position.x = Hitbox1.fixed_position.x
	Hurtbox1.fixed_position.y = Hitbox1.fixed_position.y
	Hurtbox1.fixed_scale.x = Hitbox1.fixed_scale.x
	Hurtbox1.fixed_scale.y = Hitbox1.fixed_scale.y

func _save_state() -> Dictionary:
	var state = super._save_state()
	state[Enums.StKey.projectile_hp] = currentState.get(Enums.StKey.projectile_hp, 1)
	return state

func _load_state(state: Dictionary) -> void:
	currentState[Enums.StKey.projectile_hp] = state.get(Enums.StKey.projectile_hp, 1)
	super._load_state(state)

func setup(playerData:PlayerSetup):
	super.setup(playerData)
	for hitbox_name in ["Hitbox1"]:
		get_node(hitbox_name).set_projectile_mask_bits(playerData.team)
	for hurtbox_name in ["Hurtbox1"]:
		get_node(hurtbox_name).set_projectile_mask_bits(playerData.team)
	if (fighterState == null):
		var state_factory: StateFactory
		match playerData.point_chara:
			Enums.Projectiles.HighMioCannon:
				state_factory = preload("res://game/state/projectiles/mio/MioCardStateFactory.gd").new()
			Enums.Projectiles.SubaruStarBall:
				state_factory = SubaruStarBallStateFactory.new()
			Enums.Projectiles.SubaruBatterSetBall:
				state_factory = preload("res://game/state/projectiles/subaru/SubaruBatterSetBallStateFactory.gd").new()
			Enums.Projectiles.AssistSubaruStarBall:
				state_factory = preload("res://game/state/projectiles/subaru/AssistSubaruStarBallStateFactory.gd").new()
			Enums.Projectiles.HakkaTags:
				state_factory = preload("res://game/state/projectiles/hakka/HakkaTagsStateFactory.gd").new()
			Enums.Projectiles.SuicopathChainsaw:
				state_factory = preload("res://game/state/projectiles/suisei/ChainsawStateFactory.gd").new()
			Enums.Projectiles.KurokamiFlamePillar:
				state_factory = preload("res://game/state/projectiles/kurokami/KurokamiFlamePillarStateFactory.gd").new()
			_:
				printerr("invalid projectile character given")
		super.state_factory_setup(state_factory)
	self.fighterState.change_state("Active")
	set_initial_projectile_hp()

func on_attack_hit(attack_type: int, opponent_hit_data: Dictionary) -> void:
	super.on_attack_hit(attack_type, opponent_hit_data)
	if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
		var owner = Global.PLAYER_2_NODE_INSTANCE[0] if team else Global.PLAYER_1_NODE_INSTANCE[0]
		if (is_instance_valid(owner)):
			owner.currentState[Enums.StKey.projectile_hit] = true
	if (currentState[Enums.StKey.projectile_hp] <= 1):
		fighterState.change_state("Destroy")
		$NetworkAnimationPlayer.speed_scale = 1
	else:
		currentState[Enums.StKey.projectile_hp] -= 1
	play_projectile_sound()

func on_attack_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool , hitbox_name: String = "Unknown") -> Dictionary:
	var hit_data : Dictionary = {
		Enums.StKey.hitCount: 1,
		Enums.StKey.comboTime: 1,
		"hitType": Enums.HitType.Projectile,
		"in_corner": false,
		"counter": false,
		"otg": false,
	}
	match react_type:
		Enums.Reaction.BurstLockHurt:
			pass
	return hit_data

func play_hit_lvl1_sound() -> void:
	pass

func play_hit_lvl3_sound() -> void:
	pass

func play_projectile_sound() -> void:
	SyncManager.play_sound("block1", Global.BlockLV3Sound, {"bus": "Sound"})
