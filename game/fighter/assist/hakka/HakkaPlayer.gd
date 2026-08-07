extends AssistPlayer

class_name HakkaPlayer

@onready var HakkaTags = preload("res://game/fighter/projectiles/hakka/HakkaTagsProjectile.tscn")

func tick() -> void:
	super.tick()
	if (not has_property(Enums.StateProperty.DormantAssist) and
			has_property(Enums.StateProperty.DrainAssistMeter) and 
			currentState[Enums.StKey.frame] % 3 == 0):
		emit_signal("battery_player", 0, 0, -SGFixed.ONE*150)

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		if (entity == "hakkatags"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.HakkaTags,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x,
				g_position.y, 
				HakkaTags,
				"HakkaTags",
				playerData)
