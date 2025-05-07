extends SubaruAttackState

class_name SubaruBatterSetState

var sound = preload("res://game/assets/sfx/Parry8Bit.wav")

func _init():
	endFrame = 45
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -7471104,
			Enums.StKey.Hurt1ScaleX : 522078, Enums.StKey.Hurt1ScaleY : 1436954,
			},
		3 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Summon : "subarubattersetball",
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 1572864, Enums.StKey.Hurt3PosY : -10485762,
			Enums.StKey.Hurt3ScaleX : 554342, Enums.StKey.Hurt3ScaleY : -1021119,
			},
#		10 : {
#			Enums.StKey.counterOK : true,
#			Enums.StKey.Hit1Disable : false,
#			Enums.StKey.hit_box_colliding_frame : 254,
#			Enums.StKey.Hit1PosX : 7405568, Enums.StKey.Hit1PosY : -16646144,
#			Enums.StKey.Hit1ScaleX : 657665, Enums.StKey.Hit1ScaleY : 734906,
#			Enums.StKey.hitstun : 60,
#			Enums.StKey.attack_damage: 45,
#			Enums.StKey.attack_type : Enums.AttackType.Launcher,
#			Enums.StKey.launch_dir_x : -SGFixed.ONE*0,
#			Enums.StKey.launch_dir_y : -SGFixed.ONE*70,
#			Enums.StKey.hitstop: 5,
#			Enums.StKey.min_damage:4,
#			Enums.StKey.chip_damage:4,
#			Enums.StKey.counter_hit: Enums.AttackType.WallBouncer,
#			Enums.StKey.counter_hitstun: 200,
#			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*0,
#			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*70,
#			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
#			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
#			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
#			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
#			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
#			Enums.StKey.Hurt3PosX : 1572864, Enums.StKey.Hurt3PosY : -10485762,
#			Enums.StKey.Hurt3ScaleX : 554342, Enums.StKey.Hurt3ScaleY : -1021119,
#			},
		11 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -458752, Enums.StKey.Hurt1PosY : -22282238,
			Enums.StKey.Hurt1ScaleX : 339834, Enums.StKey.Hurt1ScaleY : 629832,
			Enums.StKey.Hurt2PosX : -655360, Enums.StKey.Hurt2PosY : -18219008,
			Enums.StKey.Hurt2ScaleX : 548413, Enums.StKey.Hurt2ScaleY : -906915,
			Enums.StKey.Hurt3PosX : 1572864, Enums.StKey.Hurt3PosY : -10485762,
			Enums.StKey.Hurt3ScaleX : 554342, Enums.StKey.Hurt3ScaleY : -1021119,
			},
	}

func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("BatterSet")
	state[Enums.StKey.super_meter] += SGFixed.ONE*200

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		state[Enums.StKey.hitStopFrame] = 0
	elif (state[Enums.StKey.frame] == 2):
		SyncManager.play_sound("SubaruStarBallSound", sound, {"bus": "Sound"})

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "BatterSwing"
	if (state[Enums.StKey.frame] >= 13 and state[Enums.StKey.frame] <= 20):
		if (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "BatterSwing"
	if (state[Enums.StKey.frame] >= 21):
		if (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "DuckPunch"
		elif (interpreter.special_input_button(Enums.SpecialInput.M623, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "LightDuckPunch"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "BatterSwing"
		elif (interpreter.special_input_button(Enums.SpecialInput.M214, Enums.InputFlags.BDown, state[Enums.StKey.leftface])):
			state[Enums.StKey.cancelState] = "Stinger"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
