extends SuiseiIdleState

class_name SuiseiStandState

func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.play("Idle")
