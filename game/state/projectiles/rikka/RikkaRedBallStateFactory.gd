extends ProjectileStateFactory

class_name RikkaRedBallStateFactory

func _init():
	
	states = {
		"Neutral": NeutralState,
		"Active": preload("res://game/state/projectiles/rikka/RikkaRedBallactiveprojectilestate.gd"),
		"Destroy": preload("res://game/state/projectiles/rikka/RikkaBalldestroyState.gd"),
	}
