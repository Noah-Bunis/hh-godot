extends AssistPlayer

class_name RikkaPlayer

@onready var RikkaBall = preload("res://game/fighter/projectiles/rikka/RikkaBallProjectile.tscn")
@onready var RikkaBigBall = preload("res://game/fighter/projectiles/rikka/RikkaRedBallProjectile.tscn")
@onready var RikkaSuperBall = preload("res://game/fighter/projectiles/rikka/RikkaSuperBallProjectile.tscn")

func tick() -> void:
	super.tick()

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		if (entity == "RikkaBall"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.RikkaBall,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x,
				g_position.y, 
				RikkaBall,
				"RikkaBall",
				playerData)
		elif (entity == "RikkaRedBall"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.RikkaBigBall,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x,
				g_position.y, 
				RikkaBigBall,
				"RikkaBigBall",
				playerData)
		elif (entity == "RikkaSuperBall"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.RikkaSuperBall,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x,
				g_position.y, 
				RikkaSuperBall,
				"RikkaSuperBall",
				playerData)
