extends FlayonAirAttackState

class_name FlayonFlightNoFuelState

var knockdownsound = preload("res://game/assets/sfx/HitLvl1.wav")
var voice = preload("res://game/assets/voice/flayon/mxf_Augh.wav")

func _init():
	endFrame = 40
	
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
	anim.play("FlightNoFuel")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.velocity_y] = -SGFixed.ONE*25
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.kara_OK] = false # No instant air kara

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2 || state[Enums.StKey.frame] == 8 || state[Enums.StKey.frame] == 12):
		SyncManager.play_sound("knockdown", knockdownsound, {"bus": "Sound"})
	elif (state[Enums.StKey.frame] == 20):
		SyncManager.play_sound("FlayonVoice", voice, {"bus": "Voice"})


func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] > 5):
			state[Enums.StKey.doubleJump] = 1
			state[Enums.StKey.airDash] = 1
			state[Enums.StKey.leftfaceOK] = true
			change_state.call("LandingRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
