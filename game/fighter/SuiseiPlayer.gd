extends PointPlayer

class_name SuiseiPlayer

# Fields

var SuicopathChainsaw = preload("res://game/fighter/projectiles/SuicopathChainsaw.tscn")

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		var leftface_mult = 1
		if (currentState[Enums.StKey.leftface]):
			leftface_mult = -1
		
		if (entity == "suicopathchainsaw"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.SuicopathChainsaw,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x - (SGFixed.ONE*100*leftface_mult), 
				g_position.y - (SGFixed.ONE*200), 
				SuicopathChainsaw,
				"SuicopathChainsaw",
				playerData)
