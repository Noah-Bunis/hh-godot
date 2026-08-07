extends AssistPlayer

class_name AssistOlliePlayer

const AssistProtonCannon = preload("res://game/fighter/projectiles/ollie/AssistOllieProtonCannonProjectile.tscn")

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		if (entity == "assistprotoncannon"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.AssistOllieProtonCannon,
					self.color_scheme,
					self.input_interpreter
				)
			var leftface_mult = 1
			if (currentState[Enums.StKey.leftface]):
				leftface_mult = -1
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*1400*leftface_mult), 
				g_position.y - (SGFixed.ONE*260), 
				AssistProtonCannon,
				"AssistProtonCannon",
				playerData)
