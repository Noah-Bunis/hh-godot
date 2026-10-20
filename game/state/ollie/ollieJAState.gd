extends "res://game/state/ollie/mainstates/ollieAirAttackState.gd"

class_name OlliejAState

func _init():
	endFrame = 20
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -2686976, Enums.StKey.Hurt1PosY : -20512764,
			Enums.StKey.Hurt1ScaleX : 868657, Enums.StKey.Hurt1ScaleY : 885109,
			Enums.StKey.Hurt2PosX : 8454144, Enums.StKey.Hurt2PosY : -17563648,
			Enums.StKey.Hurt2ScaleX : 510595, Enums.StKey.Hurt2ScaleY : -912293,
			Enums.StKey.Hurt3PosX : 21430270, Enums.StKey.Hurt3PosY : -14155776,
			Enums.StKey.Hurt3ScaleX : 1310325, Enums.StKey.Hurt3ScaleY : -514394,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit1PosX : 27721728, Enums.StKey.Hit1PosY : -11993088,
			Enums.StKey.Hit1ScaleX : 1260160, Enums.StKey.Hit1ScaleY : -252545,
			Enums.StKey.Hit2PosX : 13631489, Enums.StKey.Hit2PosY : -11665409,
			Enums.StKey.Hit2ScaleX : 935943, Enums.StKey.Hit2ScaleY : 182434,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -2686976, Enums.StKey.Hurt1PosY : -20512764,
			Enums.StKey.Hurt1ScaleX : 868657, Enums.StKey.Hurt1ScaleY : 885109,
			Enums.StKey.Hurt2PosX : 8454144, Enums.StKey.Hurt2PosY : -17563648,
			Enums.StKey.Hurt2ScaleX : 510595, Enums.StKey.Hurt2ScaleY : -912293,
			Enums.StKey.Hurt3PosX : 21430270, Enums.StKey.Hurt3PosY : -14155776,
			Enums.StKey.Hurt3ScaleX : 1310325, Enums.StKey.Hurt3ScaleY : -514394,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.attack_damage: 35,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			},
		10 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -2686976, Enums.StKey.Hurt1PosY : -20512764,
			Enums.StKey.Hurt1ScaleX : 868657, Enums.StKey.Hurt1ScaleY : 885109,
			Enums.StKey.Hurt2PosX : 8454144, Enums.StKey.Hurt2PosY : -17563648,
			Enums.StKey.Hurt2ScaleX : 510595, Enums.StKey.Hurt2ScaleY : -912293,
			Enums.StKey.Hurt3PosX : 21430270, Enums.StKey.Hurt3PosY : -14155776,
			Enums.StKey.Hurt3ScaleX : 1310325, Enums.StKey.Hurt3ScaleY : -514394,
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
		elif (interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Jump5C"
		elif (interpreter.is_button_down(Enums.InputFlags.BDown)):
			state[Enums.StKey.cancelState] = "Jump5B"
		elif (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "Jump5A"
