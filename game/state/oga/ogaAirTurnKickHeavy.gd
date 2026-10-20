extends OgaAirAttackState

class_name OgajAirTurnKickHeavyState

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 11206656, Enums.StKey.Hurt1PosY : -23920636,
			Enums.StKey.Hurt1ScaleX : 1475853, Enums.StKey.Hurt1ScaleY : 525360,
			Enums.StKey.Hurt2PosX : -2293760, Enums.StKey.Hurt2PosY : -23068672,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : -7602173, Enums.StKey.Hurt3PosY : -10682367,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 11206656, Enums.StKey.Hurt1PosY : -23920636,
			Enums.StKey.Hurt1ScaleX : 1475853, Enums.StKey.Hurt1ScaleY : 525360,
			Enums.StKey.Hurt2PosX : -2293760, Enums.StKey.Hurt2PosY : -23068672,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : -7602173, Enums.StKey.Hurt3PosY : -10682367,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -24510464,
			Enums.StKey.Hit1ScaleX : 2057129, Enums.StKey.Hit1ScaleY : 728344,
			Enums.StKey.guard: Enums.GuardType.High,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*50,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 35,
			Enums.StKey.hitstop: 10,
			Enums.StKey.counter_hitstun: 10,
			Enums.StKey.attack_damage: 45,
			Enums.StKey.min_damage: 4,
		},
		58 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 11206656, Enums.StKey.Hurt1PosY : -23920636,
			Enums.StKey.Hurt1ScaleX : 1475853, Enums.StKey.Hurt1ScaleY : 525360,
			Enums.StKey.Hurt2PosX : -2293760, Enums.StKey.Hurt2PosY : -23068672,
			Enums.StKey.Hurt2ScaleX : 841985, Enums.StKey.Hurt2ScaleY : -836808,
			Enums.StKey.Hurt3PosX : -7602173, Enums.StKey.Hurt3PosY : -10682367,
			Enums.StKey.Hurt3ScaleX : 838252, Enums.StKey.Hurt3ScaleY : 402529,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.super_meter] += SGFixed.ONE*200
	anim.play("Tatsu")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 8):
		#state[Enums.StKey.velocity_y] -= SGFixed.ONE*20
		state[Enums.StKey.leftface] = not state[Enums.StKey.leftface]

#func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
#	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirRiderKickLight"
		elif (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirRiderKick"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirTurnKickLight"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirTurnKick"
