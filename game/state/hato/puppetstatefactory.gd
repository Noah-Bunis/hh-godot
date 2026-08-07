extends StateFactory

class_name PuppetStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Dormant" : preload("res://game/state/hato/HatoDormantState.gd"),
		Enums.StKey.Summon : DormantState,
		
		"HurtStand": HatoHurtState,
		
		"Stand" : HatoStandState,
		"ForwardWalk": HatoForwardWalkState,
		"BackwardWalk": HatoBackwardWalkState,
		
		"Hato5A": HatoStand5AState,
		"Hato5B": HatoStand5BState,
		"Hato5C": HatoStand5CState,
		
		"HatoCards": HatoCardsState,
		
		"Intro": HatoIntroState,
	}
	
	merge_state_dictionary(new_states)
