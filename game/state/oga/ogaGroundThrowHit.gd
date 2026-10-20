extends OgaAttackState

class_name OgaGroundThrowHitState

func _init():
	endFrame = 40
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			},
		17 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 1, 
			Enums.StKey.Hit1PosX : 2359296, Enums.StKey.Hit1PosY : -12976128,
			Enums.StKey.Hit1ScaleX : 2503512, Enums.StKey.Hit1ScaleY : 2516269,
			Enums.StKey.hitstun : 30,
			Enums.StKey.burst_OK: false,
			Enums.StKey.attack_damage: 10,
			},
		21 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 2359296, Enums.StKey.Hit1PosY : -12976128,
			Enums.StKey.Hit1ScaleX : 2503512, Enums.StKey.Hit1ScaleY : 2516269,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*20,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*33,
			Enums.StKey.burst_OK: false,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*10,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*60,
			Enums.StKey.hitstun : 60,
			Enums.StKey.attack_damage: 40,
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
	anim.play("GroundThrowHit")
	state[Enums.StKey.sync_rate] += Util.GROUND_THROW_SYNC_BOOST

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("throwcatch", Global.ThrowCatchSound, {"bus": "Sound"})

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (boost_OK(state, interpreter)):
			state[Enums.StKey.cancelState] = "BoostCancel"
		elif (assist_ok(state, interpreter) and state[Enums.StKey.cancelState] != "BoostCancel"):
			if (interpreter.is_low_blocking(state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCall2"
			elif (level_1_OK(state) and super_assist_meter_ok(state)  and interpreter.special_input_button(Enums.SpecialInput.M236, Enums.InputFlags.DDown, state[Enums.StKey.leftface])):
				state[Enums.StKey.cancelState] = "GroundAssistCallSuper"
			else:
				state[Enums.StKey.cancelState] = "GroundAssistCall"
