extends KurokamiAttackState

class_name kurokamiTetsuzankoState

var initial_player_distance = 0
var current_player_distance = 0

func _init():
	endFrame = 49
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2579648, Enums.StKey.Hurt1PosY : -10908288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : -1104072,
			},
		6 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 3579648, Enums.StKey.Hurt1PosY : -8008288,
			Enums.StKey.Hurt1ScaleX : 846568, Enums.StKey.Hurt1ScaleY : -904072,
			},
		18 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 10867169, Enums.StKey.Hit1PosY : -20619964,
			Enums.StKey.Hit1ScaleX : 619159, Enums.StKey.Hit1ScaleY : -639693,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 1879648, Enums.StKey.Hurt2PosY : -904072,
			Enums.StKey.Hurt2ScaleX : 1046568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*60,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.min_damage:8,
			Enums.StKey.hitstun: 50 - - Util.BONUS_JUGGLE_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN+20,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 80,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*15 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
		24 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 1879648, Enums.StKey.Hurt2PosY : -904072,
			Enums.StKey.Hurt2ScaleX : 1046568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.Hurt3PosX : 10867169, Enums.StKey.Hurt3PosY : -16619964,
			Enums.StKey.Hurt3ScaleX : 519159, Enums.StKey.Hurt3ScaleY : -739693,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Tetsuzanko")
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 6):
		initial_player_distance = state[Enums.StKey.opponent_pos_x] - state["_pos_x"]
		state[Enums.StKey.velocity_x] = SGFixed.ONE*55
	elif (state[Enums.StKey.frame] == 18):
		state[Enums.StKey.velocity_x] = Util.fixed_max(SGFixed.ONE*0, state[Enums.StKey.velocity_x] - 54)
	if (state[Enums.StKey.frame] >= 18):
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
		6 : {
			Enums.StKey.Summon : "rundust",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 3579648, Enums.StKey.Hurt1PosY : -8008288,
			Enums.StKey.Hurt1ScaleX : 846568, Enums.StKey.Hurt1ScaleY : -904072,
			},
		18 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 10867169, Enums.StKey.Hit1PosY : -20619964,
			Enums.StKey.Hit1ScaleX : 619159, Enums.StKey.Hit1ScaleY : -639693,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false, Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 1879648, Enums.StKey.Hurt2PosY : -904072,
			Enums.StKey.Hurt2ScaleX : 1046568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*15 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*60,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.min_damage:8,
			Enums.StKey.hitstun: 50 - - Util.BONUS_JUGGLE_HITSTUN,
			Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN+20,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_hitstun: 80,
			Enums.StKey.counter_launch_dir_x : -SGFixed.ONE*15 if ((initial_player_distance > 0 and current_player_distance > 0) or (initial_player_distance < 0 and current_player_distance < 0)) else SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			},
		24 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 6579648, Enums.StKey.Hurt1PosY : -15808288,
			Enums.StKey.Hurt1ScaleX : 646568, Enums.StKey.Hurt1ScaleY : 244563,
			Enums.StKey.Hurt2PosX : 1879648, Enums.StKey.Hurt2PosY : -904072,
			Enums.StKey.Hurt2ScaleX : 1046568, Enums.StKey.Hurt2ScaleY : -654072,
			Enums.StKey.Hurt3PosX : 10867169, Enums.StKey.Hurt3PosY : -16619964,
			Enums.StKey.Hurt3ScaleX : 519159, Enums.StKey.Hurt3ScaleY : -739693,
			},
		}

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
