extends SubaruAirAttackState

class_name SubaruAirBatterSetState

var sound = preload("res://game/assets/sfx/Parry8Bit.wav")

func _init():
	endFrame = 52
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "subarubattersetball",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 1572864, Enums.StKey.Hurt3PosY : -10485762,
			Enums.StKey.Hurt3ScaleX : 554342, Enums.StKey.Hurt3ScaleY : -1021119,
			},
		11 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 1572864, Enums.StKey.Hurt3PosY : -10485762,
			Enums.StKey.Hurt3ScaleX : 554342, Enums.StKey.Hurt3ScaleY : -1021119,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("BatterSet")
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.hitStopFrame] = 0
	elif (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_x] = SGFixed.mul(state[Enums.StKey.velocity_x], SGFixed.HALF)
		state[Enums.StKey.velocity_y] = SGFixed.ONE*-10
		state[Enums.StKey.accel_y] = 35536


func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirBatterSwing"
	
	if (state[Enums.StKey.frame] >= 13 and state[Enums.StKey.frame] <= 20):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirBatterSwing"
	elif (state[Enums.StKey.frame] >= 21):
		if (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "DuckPunch"
		elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "LightDuckPunch"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirBatterSwing"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "AirStinger"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
