extends AngelAttackState

class_name AngelGroundBackThrowHitState

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		20 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 2359296, Enums.StKey.Hit1PosY : -12976128,
			Enums.StKey.Hit1ScaleX : 2503512, Enums.StKey.Hit1ScaleY : 2516269,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.burst_OK: false,
			Enums.StKey.launch_dir_x : SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*55,
			Enums.StKey.counter_hit: Enums.AttackType.Launcher,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*20,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*55,
			Enums.StKey.attack_damage: 10,
			Enums.StKey.hitstun : 60,
			},
		22 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("AngelGroundThrowHit")
	state[Enums.StKey.sync_rate] += Util.GROUND_THROW_SYNC_BOOST

# Writing _delta instead of delta here prevents the unused variable warning.
func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 23):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*30

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "AngelBoostCancel"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "AngelBoostCancel"):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AngelGroundAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "AngelGroundAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "AngelGroundAssistCall"
