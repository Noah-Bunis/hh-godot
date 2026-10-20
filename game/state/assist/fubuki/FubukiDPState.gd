extends AssistAirAttackState

class_name FubukiDPState

var voice = preload("res://game/assets/voice/fubuki/fbk_aaa yatta.wav")

func _init():
	endFrame = 100
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			},
		8 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 7420224, Enums.StKey.Hit1PosY : -18219010,
			Enums.StKey.Hit1ScaleX : 1173739, Enums.StKey.Hit1ScaleY : -1202484,
			Enums.StKey.min_damage: 6,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 25,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*10,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*55,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
		13 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
		31 : {
			Enums.StKey.Hit1Disable : false,Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 5439487, Enums.StKey.Hit1PosY : -23396352,
			Enums.StKey.Hit1ScaleX : 1342229, Enums.StKey.Hit1ScaleY : 1354745,
			Enums.StKey.Hit2PosX : 19857410, Enums.StKey.Hit2PosY : -12451842,
			Enums.StKey.Hit2ScaleX : 1142229, Enums.StKey.Hit2ScaleY : 1101102,
			Enums.StKey.min_damage: 6,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.hitstun: 40,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.launch_dir_y : SGFixed.ONE*40,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 60,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*40,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*40,
			},
		36 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.drag_x] = Util.ICE_FRICTION
	anim.stop(true)
	anim.play("DP")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 7):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*50
		state[Enums.StKey.velocity_x] = SGFixed.ONE*15
		state[Enums.StKey.accel_y] = Util.GRAVITY
	if (state[Enums.StKey.frame] == 6):
		SyncManager.play_sound("FubukiVoice", voice, {"bus": "Voice"})
	if (state[Enums.StKey.frame] == 27):
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*30
		state[Enums.StKey.velocity_x] = SGFixed.ONE*15

func reaction(state: Dictionary, interpreter: InputInterpreter, event_cause: int) -> void:
	if (event_cause == Enums.Reaction.GroundLand):
		if (state[Enums.StKey.frame] > 8 and state[Enums.StKey.hitStopFrame] <= 0):
			change_state.call("LandAttackRecovery")
	else:
		super.reaction(state, interpreter, event_cause)
