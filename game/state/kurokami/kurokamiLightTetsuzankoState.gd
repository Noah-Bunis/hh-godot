extends KurokamiAttackState

class_name kurokamiLightTetsuzankoState

var initial_player_distance = 0
var current_player_distance = 0

var voice = preload("res://game/assets/voice/fubuki/fbk_kurokami doke.wav")

func _init():
	endFrame = 27
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2579648, Enums.StKey.Hurt1PosY : -10908288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : -1104072,
			},
		4 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 3579648, Enums.StKey.Hurt1PosY : -8008288,
			Enums.StKey.Hurt1ScaleX : 846568, Enums.StKey.Hurt1ScaleY : -904072,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 8598114, Enums.StKey.Hit1PosY : -23068672,
			Enums.StKey.Hit1ScaleX : 895742, Enums.StKey.Hit1ScaleY : 475488,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 4079648, Enums.StKey.Hurt2PosY : -5504072,
			Enums.StKey.Hurt2ScaleX : 846568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.Hurt3PosX : 10867169, Enums.StKey.Hurt3PosY : -16619964,
			Enums.StKey.Hurt3ScaleX : 519159, Enums.StKey.Hurt3ScaleY : -739693,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.chip_damage: 4,
			Enums.StKey.min_damage:6,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 23 - - Util.BONUS_JUGGLE_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN,
			Enums.StKey.block_dir_x : Util.BASE_STRIKE_X_PUSHBACK,
			Enums.StKey.block_dir_y : Util.BASE_AIR_Y_PUSHBACK,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 50,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*25 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			},
		14 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 4079648, Enums.StKey.Hurt2PosY : -5504072,
			Enums.StKey.Hurt2ScaleX : 846568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.Hurt3PosX : 10867169, Enums.StKey.Hurt3PosY : -16619964,
			Enums.StKey.Hurt3ScaleX : 519159, Enums.StKey.Hurt3ScaleY : -739693,
		},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("LightTetsuzanko")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("KurokamiVoice", voice, {"bus": "Voice"})
	elif (state[Enums.StKey.frame] == 4):
		initial_player_distance = state[Enums.StKey.opponent_pos_x] - state["_pos_x"]
		state[Enums.StKey.velocity_x] += Util.fixed_max(SGFixed.ONE*30, state[Enums.StKey.velocity_x])
	if (state[Enums.StKey.frame] >= 8):
		print(initial_player_distance," ",current_player_distance)
		current_player_distance = state[Enums.StKey.opponent_pos_x] - state["_pos_x"]
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2579648, Enums.StKey.Hurt1PosY : -10908288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : -1104072,
			},
		4 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 3579648, Enums.StKey.Hurt1PosY : -8008288,
			Enums.StKey.Hurt1ScaleX : 846568, Enums.StKey.Hurt1ScaleY : -904072,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 8598114, Enums.StKey.Hit1PosY : -23068672,
			Enums.StKey.Hit1ScaleX : 895742, Enums.StKey.Hit1ScaleY : 475488,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 4079648, Enums.StKey.Hurt2PosY : -5504072,
			Enums.StKey.Hurt2ScaleX : 846568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.Hurt3PosX : 10867169, Enums.StKey.Hurt3PosY : -16619964,
			Enums.StKey.Hurt3ScaleX : 519159, Enums.StKey.Hurt3ScaleY : -739693,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*40,
			Enums.StKey.chip_damage: 4,
			Enums.StKey.min_damage:6,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.hitstun: 23 - - Util.BONUS_JUGGLE_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN,
			Enums.StKey.block_dir_x : Util.BASE_STRIKE_X_PUSHBACK,
			Enums.StKey.block_dir_y : Util.BASE_AIR_Y_PUSHBACK,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_hitstun: 50,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*25 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			},
		14 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 4079648, Enums.StKey.Hurt2PosY : -5504072,
			Enums.StKey.Hurt2ScaleX : 846568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.Hurt3PosX : 10867169, Enums.StKey.Hurt3PosY : -16619964,
			Enums.StKey.Hurt3ScaleX : 519159, Enums.StKey.Hurt3ScaleY : -739693,
		},
	}

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
		state[Enums.StKey.cancelState] = "DashPunch"
