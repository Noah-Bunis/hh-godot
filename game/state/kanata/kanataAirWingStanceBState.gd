extends "res://game/state/kanata/mainstates/kanataAirAttackState.gd"

class_name KanataAirWingStanceBState

func _init():
	endFrame = 50
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 6750208, Enums.StKey.Hurt1PosY : -16056320,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 1048575, Enums.StKey.Hurt2PosY : -6881279,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 8519679, Enums.StKey.Hit1PosY : -14090241,
			Enums.StKey.Hit1ScaleX : 729694, Enums.StKey.Hit1ScaleY : 1031250,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 6750208, Enums.StKey.Hurt1PosY : -16056320,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 1048575, Enums.StKey.Hurt2PosY : -6881279,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop : 10,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: 35,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*40,
			Enums.StKey.launch_dir_y : SGFixed.ONE*10,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 110,
			Enums.StKey.attack_damage: 80,
			Enums.StKey.min_damage: 12,
			Enums.StKey.chip_damage: 10,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*30,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*40,
			},
		37 : {
			Enums.StKey.counterOK : false,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 6750208, Enums.StKey.Hurt1PosY : -16056320,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 1048575, Enums.StKey.Hurt2PosY : -6881279,
			Enums.StKey.Hurt2ScaleX : 954510, Enums.StKey.Hurt2ScaleY : 708881,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
#	state[Enums.StKey.drag_x] = Util.SLIPPERY_FRICTION
#	state[Enums.StKey.accel_y] = SGFixed.ONE*1
	anim.play("WingStanceB")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] >= 10 and state[Enums.StKey.frame] <= 21):
		state[Enums.StKey.velocity_x] = Util.fixed_max(state[Enums.StKey.velocity_x], SGFixed.ONE*25)

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass