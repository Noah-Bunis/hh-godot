extends ProjectilePlayer

class_name SubaruStarBallProjectilePlayer

func set_initial_projectile_hp():
	currentState[Enums.StKey.projectile_hp] = 2

func setup(playerData:PlayerSetup):
	super.setup(playerData)
	
	for hitbox_name in ["Hitbox1"]:
		get_node(hitbox_name).set_projectile_mask_bits(playerData.team)
	for hurtbox_name in ["Hurtbox1"]:
		get_node(hurtbox_name).set_self_projectile_mask_bits(playerData.team)
	if (fighterState == null):
		var state_factory: StateFactory
		match playerData.point_chara:
			Enums.Projectiles.SubaruStarBall:
				state_factory = SubaruStarBallStateFactory.new()
			Enums.Projectiles.SubaruBatterSetBall:
				state_factory = preload("res://game/state/projectiles/subaru/SubaruBatterSetBallStateFactory.gd").new()
			Enums.Projectiles.SubaruEXBatterSetBall:
				state_factory = preload("res://game/state/projectiles/subaru/SubaruEXBatterSetBallStateFactory.gd").new()
			Enums.Projectiles.AssistSubaruStarBall:
				state_factory = preload("res://game/state/projectiles/subaru/AssistSubaruStarBallStateFactory.gd").new()
			_:
				printerr("starball: invalid projectile character given")
		super.state_factory_setup(state_factory)
	self.fighterState.change_state("Active")

func on_attack_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hitbox_name: String = "Unknown") -> Dictionary:
	var hit_data : Dictionary = {
		Enums.StKey.hitCount: 1,
		Enums.StKey.comboTime: 1,
		"hitType": Enums.HitType.Projectile,
		"in_corner": false,
		"counter": false,
		"otg": false,
	}
	match react_type:
		Enums.Reaction.StrikeHurt:
			if (currentState[Enums.StKey.projectile_hp] >= 1):
				play_projectile_sound()
				currentState[Enums.StKey.velocity_x] = -opponent_attack[Enums.StKey.launch_dir_x]
				currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
				currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
		Enums.Reaction.LaunchHurt:
			if (currentState[Enums.StKey.projectile_hp] >= 1):
				play_projectile_sound()
				currentState[Enums.StKey.velocity_x] = -opponent_attack[Enums.StKey.launch_dir_x]
				currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
				currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
		Enums.Reaction.GroundBounceHurt:
			if (currentState[Enums.StKey.projectile_hp] >= 1):
				play_projectile_sound()
				currentState[Enums.StKey.velocity_x] = -opponent_attack[Enums.StKey.launch_dir_x]
				currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
				currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
		Enums.Reaction.WallBounceHurt:
			if (currentState[Enums.StKey.projectile_hp] >= 1):
				play_projectile_sound()
				currentState[Enums.StKey.velocity_x] = -opponent_attack[Enums.StKey.launch_dir_x]
				currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
				currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
		Enums.Reaction.BurstLockHurt:
			pass
	return hit_data
