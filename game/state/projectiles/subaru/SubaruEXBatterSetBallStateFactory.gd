extends ProjectileStateFactory

class_name SubaruEXBatterSetBallStateFactory

func _init():
	
	states = {
		"Neutral": NeutralState,
		"Active": preload("res://game/state/projectiles/subaru/EXBatterSetBallactiveprojectilestate.gd"),
		"EnhancedActive": preload("res://game/state/projectiles/subaru/EXBatterSetBallenhancedprojectilestate.gd"),
		"Destroy": SubaruStarBallDestroyState,
	}
