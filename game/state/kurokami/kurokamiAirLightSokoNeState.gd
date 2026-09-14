extends KurokamiAirAttackState

class_name KurokamiAirLightSokoNeState

var initial_vel_x = 0
var initial_vel_y = 0

func _init():
	endFrame = 54
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -19087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			},
		23 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "kurokamilightflamepillar",
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 0, Enums.StKey.Hurt1PosY : -19087936,
			Enums.StKey.Hurt1ScaleX : 603537, Enums.StKey.Hurt1ScaleY : 1371143,
			Enums.StKey.Hurt3PosX : 9562144, Enums.StKey.Hurt3PosY : -20538944,
			Enums.StKey.Hurt3ScaleX : 383139, Enums.StKey.Hurt3ScaleY : 370037,
			}
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("AirSokoNe")
	var initial_vel_x = 0
	var initial_vel_y = 0
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.hitStopFrame] = 0
	elif (state[Enums.StKey.frame] == 4):
		initial_vel_x = state[Enums.StKey.velocity_x]
		initial_vel_y = state[Enums.StKey.velocity_y]
		state[Enums.StKey.velocity_x] = SGFixed.ONE*0
		state[Enums.StKey.velocity_y] = SGFixed.ONE*-1
		state[Enums.StKey.accel_y] = SGFixed.ONE*0
	elif (state[Enums.StKey.frame] == 23):
		state[Enums.StKey.velocity_x] = initial_vel_x
		state[Enums.StKey.velocity_y] = initial_vel_y
		state[Enums.StKey.accel_y] = Util.GRAVITY

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
