extends ProjectileStateFactory

class_name RikkaBallStateFactory

func _init():
	
	states = {
		"Neutral": NeutralState,
		"Active": preload("res://game/state/projectiles/rikka/RikkaBallactiveprojectilestate.gd"),
		"Destroy": preload("res://game/state/projectiles/rikka/RikkaBalldestroyState.gd"),
	}
