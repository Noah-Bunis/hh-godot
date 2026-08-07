extends FlayonAttackState

class_name Flayon6CState

func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1546271, Enums.StKey.Hurt1PosY : -10362432,
			Enums.StKey.Hurt1ScaleX : 745784, Enums.StKey.Hurt1ScaleY : 1065625,
			Enums.StKey.Hurt2PosX : 8500000, Enums.StKey.Hurt2PosY : -10087936,
			Enums.StKey.Hurt2ScaleX : 603537, Enums.StKey.Hurt2ScaleY : 971143,
			Enums.StKey.Hurt3PosX : 9420000, Enums.StKey.Hurt3PosY : -4187392,
			Enums.StKey.Hurt3ScaleX : 978601, Enums.StKey.Hurt3ScaleY : 396011,
			},
		24 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 8629186, Enums.StKey.Hit1PosY : -8760254,
			Enums.StKey.Hit1ScaleX : 826496, Enums.StKey.Hit1ScaleY : 850290,
			Enums.StKey.Hit2PosX : 18435712, Enums.StKey.Hit2PosY : -5136510,
			Enums.StKey.Hit2ScaleX : 820696, Enums.StKey.Hit2ScaleY : 510074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1546271, Enums.StKey.Hurt1PosY : -10362432,
			Enums.StKey.Hurt1ScaleX : 745784, Enums.StKey.Hurt1ScaleY : 1065625,
			Enums.StKey.Hurt2PosX : 8500000, Enums.StKey.Hurt2PosY : -10087936,
			Enums.StKey.Hurt2ScaleX : 603537, Enums.StKey.Hurt2ScaleY : 971143,
			Enums.StKey.Hurt3PosX : 9420000, Enums.StKey.Hurt3PosY : -7187392,
			Enums.StKey.Hurt3ScaleX : 978601, Enums.StKey.Hurt3ScaleY : 696011,
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.attack_damage: 30,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 3,
			Enums.StKey.min_damage:2,
			Enums.StKey.chip_damage:2,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_hitstun: 10,
			},
		45 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 1546271, Enums.StKey.Hurt1PosY : -10362432,
			Enums.StKey.Hurt1ScaleX : 745784, Enums.StKey.Hurt1ScaleY : 1065625,
			Enums.StKey.Hurt2PosX : 8500000, Enums.StKey.Hurt2PosY : -10087936,
			Enums.StKey.Hurt2ScaleX : 603537, Enums.StKey.Hurt2ScaleY : 971143,
			Enums.StKey.Hurt3PosX : 9420000, Enums.StKey.Hurt3PosY : -7187392,
			Enums.StKey.Hurt3ScaleX : 978601, Enums.StKey.Hurt3ScaleY : 696011,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("6C")
	state[Enums.StKey.drag_x] = Util.ICE_FRICTION
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] >= 10 and state[Enums.StKey.frame] <= 30):
		state[Enums.StKey.drag_x] = Util.SKID_FRICTION
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*24, state[Enums.StKey.velocity_x])

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch3C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch2C"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Crouch2B"
		elif ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Crouch2A"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Stand5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Stand5A"
