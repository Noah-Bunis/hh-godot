extends AssistPlayer

class_name BijouPlayer

@onready var HakkaTags = preload("res://game/fighter/projectiles/hakka/HakkaTagsProjectile.tscn")

func tick() -> void:
	super.tick()

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)