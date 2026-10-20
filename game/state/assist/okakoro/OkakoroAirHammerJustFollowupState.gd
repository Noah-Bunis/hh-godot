extends AssistAirAttackState

class_name OkakoroAirHammerJustFollowupState

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			},
		8 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.hit_box_colliding_frame : 1,
			Enums.StKey.Hit1PosX : 2111807, Enums.StKey.Hit1PosY : -17170434,
			Enums.StKey.Hit1ScaleX : 1630703, Enums.StKey.Hit1ScaleY : 1849446,
			Enums.StKey.hitstun : 80,
			Enums.StKey.hitstop : 9,
			Enums.StKey.attack_damage: 80,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*5,
			Enums.StKey.launch_dir_y : SGFixed.ONE*65,
			Enums.StKey.min_damage:15,
			Enums.StKey.chip_damage:12,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 120,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*5,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*65,
#			Enums.StKey.counter_hitstun: 5,
			},
		14 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hurt1PosX : 4005536, Enums.StKey.Hurt1PosY : -10337728,
			Enums.StKey.Hurt1ScaleX : 1586985, Enums.StKey.Hurt1ScaleY : 1074037,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.stop(true)
	anim.play("AssistAttackFollowUp")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 1):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*45
		state[Enums.StKey.drag_x] = Util.SKID_FRICTION

func tag_cancel(state: Dictionary, interpreter: InputInterpreter):
	super.tag_cancel(state, interpreter)
	if (state["tag_attack"] == 2 or state["tag_attack"] == 1 or state["tag_attack"] == 3):
		change_state.call("AssistAirAttack2")

func combo_pushback(comboTime: int) -> int:
	return 0
