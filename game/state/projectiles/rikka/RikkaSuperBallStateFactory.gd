extends ProjectileStateFactory

class_name RikkaSuperBallStateFactory

func _init():
	
	states = {
		"Neutral": NeutralState,
		"Active": preload("res://game/state/projectiles/rikka/RikkaSuperBallactiveprojectilestate.gd"),
		"Destroy": preload("res://game/state/projectiles/rikka/RikkaBalldestroyState.gd"),
	}
