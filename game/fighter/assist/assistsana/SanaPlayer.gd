extends AssistPlayer

class_name AssistSanaPlayer

func tick() -> void:
	super.tick()
	if (not has_property(Enums.StateProperty.DormantAssist) and pilot.currentState[Enums.StKey.assist_meter] <= 0):
		fighterState.reaction(Enums.Reaction.ForceTagOut, input_interpreter)

func summonHelper(entity: String, uninterrupted:bool=true) -> void:
	super.summonHelper(entity, uninterrupted)
	if (not entity.is_empty() and uninterrupted):
		if (entity == "move_pilot"):
			emit_gravity_signal()
			emit_signal("battery_player", 0, -95536, -SGFixed.ONE*50)
		elif (entity == "move_sana"):
			emit_gravity_signal()
			#emit_signal("battery_player", 0, -85536, -SGFixed.ONE*65)
			emit_signal("battery_player", 0, -125536, -SGFixed.ONE*75)
		elif (entity == "move_pilot_super"):
			emit_gravity_signal()
			#emit_gravity_signal(536, 5536)
			emit_signal("battery_player", 0, -145536, -SGFixed.ONE*75)

func emit_gravity_signal(xfactor=436, yfactor=836) -> void:
	var point_leftface : bool = pilot.currentState[Enums.StKey.leftface]
	var pos_x : int = pilot.fixed_position.x
	var pos_y : int = pilot.fixed_position.y
	var self_pos_x : int = self.fixed_position.x
	var self_pos_y : int = self.fixed_position.y
	var vel_x:int = SGFixed.mul(self_pos_x-pos_x, xfactor)
	var vel_y:int = SGFixed.mul(self_pos_y-pos_y, yfactor)
	if (point_leftface):
		vel_x *= -1
	emit_signal("move_pilot", vel_x, vel_y, 0, 0)
