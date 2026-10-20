extends AssistAirAttackState

class_name AssistFlayonAirSuperState

func _init():
	endFrame = 80
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			Enums.StKey.Summon : "meterDump",
			},
		5 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : 0,
			Enums.StKey.Hit1ScaleX : 18338272, Enums.StKey.Hit1ScaleY : 18338272,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop: 0,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
		},
		6 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 14629186, Enums.StKey.Hit1PosY : -18760254,
			Enums.StKey.Hit1ScaleX : 1626496, Enums.StKey.Hit1ScaleY : 850290,
			Enums.StKey.Hit2PosX : 22435712, Enums.StKey.Hit2PosY : -15136510,
			Enums.StKey.Hit2ScaleX : 1220696, Enums.StKey.Hit2ScaleY : 410074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 12976128, Enums.StKey.Hurt2PosY : -20774912,
			Enums.StKey.Hurt2ScaleX : 1535050, Enums.StKey.Hurt2ScaleY : 643629,
			Enums.StKey.attack_damage: 50,
			Enums.StKey.min_damage: 8,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 6,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_hitstun: 30,
			},
		8 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false,
			},
		15 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 829186, Enums.StKey.Hit1PosY : -15760254,
			Enums.StKey.Hit1ScaleX : 1526496, Enums.StKey.Hit1ScaleY : 1026496,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.Hit2PosX : 829186, Enums.StKey.Hit2PosY : -15760254,
			Enums.StKey.Hit2ScaleX : 1026496, Enums.StKey.Hit2ScaleY : 1526496,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.hit_box_colliding_frame : 5,
			Enums.StKey.attack_damage: 40,
			Enums.StKey.min_damage: 4,
			Enums.StKey.attack_type : Enums.AttackType.Strike,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 4,
			Enums.StKey.counter_hit: Enums.AttackType.Strike,
			Enums.StKey.counter_hitstun: 20,
			},
		27 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false,
			},
		39 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.Hit1PosX : 10435712, Enums.StKey.Hit1PosY : -17136510,
			Enums.StKey.Hit1ScaleX : 820696, Enums.StKey.Hit1ScaleY : 1010074,
			Enums.StKey.Hit2PosX : 2629186, Enums.StKey.Hit2PosY : -12760256,
			Enums.StKey.Hit2ScaleX : 1026496, Enums.StKey.Hit2ScaleY : 850290,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 10435712, Enums.StKey.Hurt2PosY : -17136510,
			Enums.StKey.Hurt2ScaleX : 920696, Enums.StKey.Hurt2ScaleY : 1110074,
			Enums.StKey.attack_damage: 60,
			Enums.StKey.min_damage: 5,
			Enums.StKey.attack_type : Enums.AttackType.Launcher,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 14,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*8,
			Enums.StKey.launch_dir_y : -SGFixed.ONE*45,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*2,
			Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*45,
			},
		42 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : false,
			},
		58 : {
			Enums.StKey.burst_OK: false,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : false,
			Enums.StKey.hit_box_colliding_frame : 2, 
			Enums.StKey.Hit1PosX : 4629186, Enums.StKey.Hit1PosY : -12760256,
			Enums.StKey.Hit1ScaleX : 1026496, Enums.StKey.Hit1ScaleY : 850290,
			Enums.StKey.Hit2PosX : 15435712, Enums.StKey.Hit2PosY : -7136510,
			Enums.StKey.Hit2ScaleX : 820696, Enums.StKey.Hit2ScaleY : 810074,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -262144, Enums.StKey.Hurt1PosY : -13471104,
			Enums.StKey.Hurt1ScaleX : 822078, Enums.StKey.Hurt1ScaleY : 1236954,
			Enums.StKey.Hurt2PosX : 15435712, Enums.StKey.Hurt2PosY : -7136510,
			Enums.StKey.Hurt2ScaleX : 920696, Enums.StKey.Hurt2ScaleY : 910074,
			Enums.StKey.attack_damage: 20,
			Enums.StKey.min_damage: 5,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: Util.DEFAULT_HITSTUN + 20,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*25,
			Enums.StKey.launch_dir_y : SGFixed.ONE*45,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 30,
			Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*15,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*45,
			},
		64 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	state[Enums.StKey.accel_y] = 0
	anim.stop(true)
	anim.play("AssistSuper")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 6):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*30
	elif (state[Enums.StKey.frame] >= 15 and state[Enums.StKey.frame] < 27):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*24
	elif (state[Enums.StKey.frame] == 39):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*25
	elif (state[Enums.StKey.frame] == 58):
		state[Enums.StKey.velocity_x] = SGFixed.ONE*35

func combo_pushback(comboTime: int) -> int:
	return Util.pushback_scaling(0, comboTime)