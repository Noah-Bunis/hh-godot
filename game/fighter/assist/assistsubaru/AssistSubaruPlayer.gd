extends AssistPlayer

class_name AssistSubaruPlayer

const AssistSubaruStarBall = preload("res://game/fighter/projectiles/AssistSubaruStarball.tscn")

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		if (entity == "assistsubarustarball"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.AssistSubaruStarBall,
					self.color_scheme,
					self.input_interpreter
				)
			if (currentState[Enums.StKey.leftface]):
				emit_signal("projectilespawn", 
					g_position.x + (SGFixed.ONE*150),
					g_position.y - (SGFixed.ONE*190), 
					AssistSubaruStarBall,
					"AssistSubaruStarBall",
					playerData)
			else:
				emit_signal("projectilespawn", 
					g_position.x - (SGFixed.ONE*150),
					g_position.y - (SGFixed.ONE*190), 
					AssistSubaruStarBall,
					"AssistSubaruStarBall",
					playerData)
