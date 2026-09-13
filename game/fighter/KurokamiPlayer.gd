extends PointPlayer

class_name KurokamiPlayer

# Fields

var KurokamiFlamePillar = preload("res://game/fighter/projectiles/KurokamiFlamePillar.tscn")

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		var leftface_mult = 1
		if (currentState[Enums.StKey.leftface]):
			leftface_mult = -1
		if (entity == "kurokamilightflamepillar"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.KurokamiFlamePillar,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x - (SGFixed.ONE*-400*leftface_mult), 
				SGFixed.ONE*170, 
				KurokamiFlamePillar,
				"KurokamiFlamePillar",
				playerData)
		if (entity == "kurokamiflamepillar"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.KurokamiFlamePillar,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x - (SGFixed.ONE*-800*leftface_mult), 
				SGFixed.ONE*170, 
				KurokamiFlamePillar,
				"KurokamiFlamePillar",
				playerData)
