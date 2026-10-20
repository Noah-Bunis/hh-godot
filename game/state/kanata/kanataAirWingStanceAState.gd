extends "res://game/state/kanata/mainstates/kanataAirAttackState.gd"

class_name KanataAirWingStanceAState

func _init():
	endFrame = 32
	
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
			Enums.StKey.attack_type : Enums.AttackType.WallBouncer,
			Enums.StKey.hitstun: 60,
			Enums.StKey.launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.launch_dir_y: -SGFixed.ONE*50,
			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*50,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*40,
			Enums.StKey.counter_hitstun: 50,
			Enums.StKey.attack_damage: 65,
			Enums.StKey.min_damage: 6,
			Enums.StKey.chip_damage: 6,
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
	state[Enums.StKey.accel_y] = SGFixed.ONE*1
	anim.play("WingStanceA")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 7):
		state[Enums.StKey.velocity_x] = -SGFixed.ONE*15
		state[Enums.StKey.velocity_y] = -SGFixed.ONE*30
		state[Enums.StKey.accel_y] = Util.KANATA_GRAVITY

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
#		if (not (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]))):
		if (interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "KanataAirWingStanceAA"
	elif (state[Enums.StKey.frame] >= 8):
#		if (not (interpreter.is_holding_a_direction(Enums.Numpad.N4, state[Enums.StKey.leftface]))):
		if (interpreter.is_button_down(Enums.InputFlags.ADown)):
			change_state.call("KanataAirWingStanceAA")
