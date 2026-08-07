extends AssistPlayer

class_name AssistMioPlayer

func tick() -> void:
	super.tick()
	if (not has_property(Enums.StateProperty.DormantAssist) and
			has_property(Enums.StateProperty.DrainAssistMeter)):
		emit_signal("battery_player", 0, -8536, -SGFixed.ONE*70)

	if (not has_property(Enums.StateProperty.DormantAssist) and
			has_property(Enums.StateProperty.DrainAssistMeter) and 
			pilot.currentState[Enums.StKey.assist_meter] <= 0):
		fighterState.reaction(Enums.Reaction.ForceTagOut, input_interpreter)

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	if (entity == "refund"):
		emit_signal("battery_player", 0, SGFixed.ONE*20, SGFixed.ONE*4200)
	else:
		super.summonHelper(entity, uninterrupted)
