extends "res://game/state/kanata/mainstates/kanataAttackState.gd"

class_name KanataWingStanceAState

func _init():
	endFrame = 23
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 655360, Enums.StKey.Hurt1PosY : -16777216,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : -4194304, Enums.StKey.Hurt2PosY : -6881279,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
			},
		8 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 11206656, Enums.StKey.Hit1PosY : -14090241,
			Enums.StKey.Hit1ScaleX : 729694, Enums.StKey.Hit1ScaleY : 1031250,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2162688, Enums.StKey.Hurt1PosY : -14221312,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 4194303, Enums.StKey.Hurt2PosY : -6619137,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop : 12,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 60,
			Enums.StKey.launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*40,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*50,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			Enums.StKey.counter_hitstun: 50,
			Enums.StKey.attack_damage: 70,
			Enums.StKey.min_damage: 10,
			Enums.StKey.chip_damage: 8,
			},
		16 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 2162688, Enums.StKey.Hurt1PosY : -14221312,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 4194303, Enums.StKey.Hurt2PosY : -6619137,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("WingStanceA")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 7):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*20

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "KanataWingStanceAA"
	elif (state[Enums.StKey.frame] >= 8):
		if (interpreter.is_button_down(Enums.InputFlags.ADown)):
			change_state.call("KanataWingStanceAA")
