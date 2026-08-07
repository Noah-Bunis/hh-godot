extends PointPlayer

class_name MioPlayer

# Fields

const HighMioCannon = preload("res://game/fighter/projectiles/HighMioCannon.tscn")
const MioSuperCannon = preload("res://game/fighter/effects/MioSuperEffects.tscn")

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		var leftface_mult = 1
		if (currentState[Enums.StKey.leftface]):
			leftface_mult = -1
		
		if (entity == "miocards"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.HighMioCannon,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x - (SGFixed.ONE*100*leftface_mult), 
				g_position.y - (SGFixed.ONE*200), 
				HighMioCannon,
				"MioCards",
				playerData)
		elif (entity == "miosupercannon"):
			summonVFX("MioSuperCannon", MioSuperCannon, true)
		
