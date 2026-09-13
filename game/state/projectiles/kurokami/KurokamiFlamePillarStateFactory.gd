extends ProjectileStateFactory

class_name KurokamiFlamePillarStateFactory

func _init():
	states = {
		"Neutral": NeutralState,
		"Active": preload("res://game/state/projectiles/kurokami/KuroPillaractiveprojectilestate.gd"),
		"Destroy": preload("res://game/state/projectiles/kurokami/KuroPillardestroyState.gd"),
	}
