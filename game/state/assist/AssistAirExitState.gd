extends AssistAirAttackState

class_name AssistAirExitState

func _init():
	endFrame = Util.ASSIST_EXIT_RECOVERY
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
		2 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			Enums.StKey.Summon : "sync_down",
			},
	}
# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	anim.play("Exit")

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == endFrame):
		change_state.call("Dormant")
	if (state[Enums.StKey.hitStopFrame] == 0 and not state[Enums.StKey.cancelState].is_empty()):
		# is out of hitstop, and cancellable
		# delay cancel state
		anim.stop(true)
		change_state.call(state[Enums.StKey.cancelState])
	
	gatling_cancel(state, interpreter)
	
	if (interpreter.is_button_down(Enums.InputFlags.DHold)):
		state[Enums.StKey.frame] = 1
