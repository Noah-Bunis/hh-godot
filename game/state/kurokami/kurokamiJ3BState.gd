extends KurokamiAirAttackState

class_name Kurokamij3BState


func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true, Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 429186, Enums.StKey.Hurt1PosY : -13760254,
			Enums.StKey.Hurt1ScaleX : 826496, Enums.StKey.Hurt1ScaleY : 1326496,
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 129186, Enums.StKey.Hit1PosY : -11760254,
			Enums.StKey.Hit1ScaleX : 526496, Enums.StKey.Hit1ScaleY : 1426496,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 429186, Enums.StKey.Hurt1PosY : -13760254,
			Enums.StKey.Hurt1ScaleX : 826496, Enums.StKey.Hurt1ScaleY : 1326496,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 5,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.launch_dir_x : Util.BASE_STRIKE_X_PUSHBACK,
			Enums.StKey.launch_dir_y : +SGFixed.ONE*35, # 42
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*7,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*42,
			Enums.StKey.hitstun: Util.DEFAULT_LIGHT_HITSTUN,
			Enums.StKey.counter_hitstun: 46,
			}
	}

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
	
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("j3C")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 4):
		state[Enums.StKey.velocity_y] = SGFixed.ONE * 12
		state[Enums.StKey.velocity_x] = SGFixed.ONE * 20
