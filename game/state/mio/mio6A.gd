extends MioAttackState

class_name Mio6AState

func _init():
	endFrame = 31
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -17432576,
			Enums.StKey.Hurt1ScaleX : 692179, Enums.StKey.Hurt1ScaleY : 354035,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -7798785,
			Enums.StKey.Hurt2ScaleX : 685281, Enums.StKey.Hurt2ScaleY : 718583,
			Enums.StKey.Hurt3PosX : 851968, Enums.StKey.Hurt3PosY : -4325376,
			Enums.StKey.Hurt3ScaleX : 934301, Enums.StKey.Hurt3ScaleY : 449426,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -7798785,
			Enums.StKey.Hurt2ScaleX : 685281, Enums.StKey.Hurt2ScaleY : 718583,
			Enums.StKey.Hurt3PosX : 851968, Enums.StKey.Hurt3PosY : -4325376,
			Enums.StKey.Hurt3ScaleX : 934301, Enums.StKey.Hurt3ScaleY : 449426,
			},
		10 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt3PosX : 851968, Enums.StKey.Hurt3PosY : -4425376,
			Enums.StKey.Hurt3ScaleX : 934301, Enums.StKey.Hurt3ScaleY : 649426,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 14352384, Enums.StKey.Hit1PosY : -19791874,
			Enums.StKey.Hit1ScaleX : 840433, Enums.StKey.Hit1ScaleY : -328525,
			Enums.StKey.attack_damage: 39,
			Enums.StKey.min_damage: 6,
			},
		16 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			#
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -17432576,
			Enums.StKey.Hurt1ScaleX : 692179, Enums.StKey.Hurt1ScaleY : 354035,
			Enums.StKey.Hurt2PosX : 0, Enums.StKey.Hurt2PosY : -7798785,
			Enums.StKey.Hurt2ScaleX : 685281, Enums.StKey.Hurt2ScaleY : 718583,
			Enums.StKey.Hurt3PosX : 851968, Enums.StKey.Hurt3PosY : -4325376,
			Enums.StKey.Hurt3ScaleX : 934301, Enums.StKey.Hurt3ScaleY : 449426,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("6A")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand6C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch3C"
