extends KurokamiAirAttackState

class_name Kurokamij2CState

var voice = preload("res://game/assets/voice/flayon/mxf_im_crazy.wav")

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1629186, Enums.StKey.Hurt1PosY : -20760254,
			Enums.StKey.Hurt1ScaleX : 1326496, Enums.StKey.Hurt1ScaleY : 1326496,
			},
		11 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 1629186, Enums.StKey.Hit1PosY : -20760254,
			Enums.StKey.Hit1ScaleX : 1226496, Enums.StKey.Hit1ScaleY : 1226496,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1629186, Enums.StKey.Hurt1PosY : -20760254,
			Enums.StKey.Hurt1ScaleX : 1326496, Enums.StKey.Hurt1ScaleY : 1326496,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.min_damage: 5,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.launch_dir_x : Util.BASE_STRIKE_X_PUSHBACK,
			Enums.StKey.launch_dir_y : +SGFixed.ONE*35, # 42
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*7,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*42,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN,
			Enums.StKey.counter_hitstun: 40,
			},
		15 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 1629186, Enums.StKey.Hurt1PosY : -20760254,
			Enums.StKey.Hurt1ScaleX : 1326496, Enums.StKey.Hurt1ScaleY : 1326496,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("j2C")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		SyncManager.play_sound("kurokamiVoice", voice, {"bus": "Voice"})
		state[Enums.StKey.velocity_y] = SGFixed.ONE * 20
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE * 1, state[Enums.StKey.velocity_x])
		
func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.hitStopFrame] <= 0 and state[Enums.StKey.frame] >= 3):
			state[Enums.StKey.doubleJump] = 1
			state[Enums.StKey.airDash] = 1
			change_state.call("LandingRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
