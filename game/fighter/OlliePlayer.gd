extends PointPlayer

class_name OlliePlayer

# Fields

const Rook = preload("res://game/fighter/projectiles/ollie/OllieRookProjectile.tscn")
const Bishop = preload("res://game/fighter/projectiles/ollie/OllieBishopProjectile.tscn")
const Knight = preload("res://game/fighter/projectiles/ollie/OllieKnightProjectile.tscn")
const AirKnight = preload("res://game/fighter/projectiles/ollie/OllieAirKnightProjectile.tscn")
const ChargeRook = preload("res://game/fighter/projectiles/ollie/OllieChargeRookProjectile.tscn")
const ChargeBishop = preload("res://game/fighter/projectiles/ollie/OllieChargeBishopProjectile.tscn")
const ChargeKnight = preload("res://game/fighter/projectiles/ollie/OllieChargeKnightProjectile.tscn")
const Queen = preload("res://game/fighter/projectiles/ollie/OllieQueenProjectile.tscn")
const ProtonCannon = preload("res://game/fighter/projectiles/ollie/OllieProtonCannonProjectile.tscn")

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		var leftface_mult = 1
		if (currentState[Enums.StKey.leftface]):
			leftface_mult = -1
		
		if (entity == "rook"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieRook,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult), 
				g_position.y - (SGFixed.ONE*0), 
				Rook,
				"OllieRook",
				playerData)
		elif (entity == "chargerook"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieChargeRook,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult), 
				g_position.y - (SGFixed.ONE*0), 
				ChargeRook,
				"OllieChargeRook",
				playerData)
		elif (entity == "bishop"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieBishop,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult),
				g_position.y - (SGFixed.ONE*0), 
				Bishop,
				"OllieBishop",
				playerData)
		elif (entity == "chargebishop"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieChargeBishop,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult),
				g_position.y - (SGFixed.ONE*0), 
				ChargeBishop,
				"OllieChargeBishop",
				playerData)
		elif (entity == "knight"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieKnight,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult),
				g_position.y - (SGFixed.ONE*0), 
				Knight,
				"OllieKnight",
				playerData)
		elif (entity == "airknight"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieAirKnight,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult),
				g_position.y - (SGFixed.ONE*0), 
				AirKnight,
				"OllieAirKnight",
				playerData)
		elif (entity == "chargeknight"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieChargeKnight,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult),
				g_position.y - (SGFixed.ONE*0), 
				ChargeKnight,
				"OllieChargeKnight",
				playerData)
		elif (entity == "queen"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieQueen,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*100*leftface_mult), 
				g_position.y - (SGFixed.ONE*0), 
				Queen,
				"OllieQueen",
				playerData)
		elif (entity == "protoncannon"):
			var g_position = get_global_fixed_position()
			var playerData = PlayerSetup.new(
					currentState[Enums.StKey.leftface],
					self.team,
					Enums.Projectiles.OllieProtonCannon,
					self.color_scheme,
					self.input_interpreter
				)
			emit_signal("projectilespawn", 
				g_position.x + (SGFixed.ONE*1400*leftface_mult), 
				g_position.y - (SGFixed.ONE*260), 
				ProtonCannon,
				"OllieProtonCannon",
				playerData)
