extends "res://game/state/ollie/mainstates/ollieCrouchAttackState.gd"

class_name Ollie2CState

func _init():
	endFrame = 49
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -3080192, Enums.StKey.Hurt1PosY : -15007745,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : -524288, Enums.StKey.Hurt2PosY : -7471104,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 655360, Enums.StKey.Hurt3PosY : -1835008,
			Enums.StKey.Hurt3ScaleX : 1161459, Enums.StKey.Hurt3ScaleY : -231611,
			},
		16 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 71827464, Enums.StKey.Hit1PosY : -3670016,
			Enums.StKey.Hit1ScaleX : 5079656, Enums.StKey.Hit1ScaleY : 367651,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 983040, Enums.StKey.Hurt1PosY : -14548992,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : -524288, Enums.StKey.Hurt2PosY : -7471104,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 655360, Enums.StKey.Hurt3PosY : -1835008,
			Enums.StKey.Hurt3ScaleX : 1161459, Enums.StKey.Hurt3ScaleY : -231611,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Low,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*30,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.min_damage: 7,
			Enums.StKey.hitstun: 60,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*45,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*65,
			},
		25 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 983040, Enums.StKey.Hurt1PosY : -14548992,
			Enums.StKey.Hurt1ScaleX : 334968, Enums.StKey.Hurt1ScaleY : 357786,
			Enums.StKey.Hurt2PosX : -524288, Enums.StKey.Hurt2PosY : -7471104,
			Enums.StKey.Hurt2ScaleX : 446568, Enums.StKey.Hurt2ScaleY : -774072,
			Enums.StKey.Hurt3PosX : 655360, Enums.StKey.Hurt3PosY : -1835008,
			Enums.StKey.Hurt3ScaleX : 1161459, Enums.StKey.Hurt3ScaleY : -231611,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("2C")

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Stand6C"
		elif (interpreter.is_holding_a_direction(Enums.Numpad.N3, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.CDown)):
			state[Enums.StKey.cancelState] = "Crouch3C"
