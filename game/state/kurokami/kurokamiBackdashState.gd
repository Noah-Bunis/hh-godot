extends KurokamiIdleState

class_name KurokamiBackDashState

func _init():
	endFrame = 15
	anim_data = {
		0 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,
			Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt3Disable : true,
			},
		8 : { 
			Enums.StKey.Summon : "backdashdust",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -15384000,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
	}
	
func enter(state: Dictionary) -> void:
	super.enter(state)
#	state[Enums.StKey.velocity_x] = -SGFixed.ONE*25
#	state[Enums.StKey.drag_x] = SGFixed.ONE
	state[Enums.StKey.leftfaceOK] = true
	anim.play("BackDash")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("skid", Global.SkidSound, {"bus": "Sound"})
	if (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*30
		state[Enums.StKey.drag_x] = SGFixed.ONE
	if (positive_bonus(state)):
		state[Enums.StKey.sync_rate] += SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 436)
	elif (negative_penalty(state)):
		state[Enums.StKey.sync_rate] -= SGFixed.mul(Util.fixed_abs(state[Enums.StKey.velocity_x]), 5536)
		state[Enums.StKey.assist_meter] -= SGFixed.ONE*270

func handle_input(state: Dictionary, interpreter: InputInterpreter) -> void:
	if (state[Enums.StKey.frame] == 0):
		state[Enums.StKey.leftfaceOK] = false
	if (state[Enums.StKey.frame] == endFrame):
		common_idle_transitions(state, interpreter)
	
	if (boost_OK(state, interpreter)):
		change_state.call("BoostCancel")

func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.BlockingOK:
			return false
		Enums.StateProperty.GroundThrowOK:
			return false
		Enums.StateProperty.AirThrowOK:
			return false
		_:
			return super.has_property(state,property)
