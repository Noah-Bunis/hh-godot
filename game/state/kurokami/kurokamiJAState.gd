extends KurokamiAirAttackState

class_name KurokamijAState

func _init():
	endFrame = 13
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			Enums.StKey.Hurt2PosX : 6546271, Enums.StKey.Hurt2PosY : -15362432,
			Enums.StKey.Hurt2ScaleX : 445784, Enums.StKey.Hurt2ScaleY : 765625,
			},
		4 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit2PosX : 9629186, Enums.StKey.Hit2PosY : -9760254,
			Enums.StKey.Hit2ScaleX : 626496, Enums.StKey.Hit2ScaleY : 1050290,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			Enums.StKey.Hurt2PosX : 6546271, Enums.StKey.Hurt2PosY : -15362432,
			Enums.StKey.Hurt2ScaleX : 445784, Enums.StKey.Hurt2ScaleY : 765625,
			Enums.StKey.Hurt3PosX : 9629186, Enums.StKey.Hurt3PosY : -9760254,
			Enums.StKey.Hurt3ScaleX : 726496, Enums.StKey.Hurt3ScaleY : 1150290,
			Enums.StKey.hitstop: 8,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.min_damage: 3,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.hitstun: Util.DEFAULT_LIGHT_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_LIGHT_BLOCKSTUN,
			},
		8 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -15087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			Enums.StKey.Hurt2PosX : 6546271, Enums.StKey.Hurt2PosY : -15362432,
			Enums.StKey.Hurt2ScaleX : 445784, Enums.StKey.Hurt2ScaleY : 765625,
			Enums.StKey.Hurt3PosX : 9629186, Enums.StKey.Hurt3PosY : -9760254,
			Enums.StKey.Hurt3ScaleX : 726496, Enums.StKey.Hurt3ScaleY : 1150290,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("jA")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if ((interpreter.is_holding_a_direction(Enums.Numpad.N1, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N2, state[Enums.StKey.leftface]) or
				interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface])) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump2C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump6C"
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Jump5B"
