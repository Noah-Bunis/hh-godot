extends FlayonFlightBaseState

class_name FlayonFlightCState

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("FlightCStartup")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	state[Enums.StKey.super_meter] -= Util.FLIGHT_ATTACK_METER_DRAIN

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] >= 4 and not interpreter.is_button_down(Enums.InputFlags.CHold)):
		change_state.call("Flight5CEarly")
	if (state[Enums.StKey.frame] >= 15):
		change_state.call("Flight5CIncrease")