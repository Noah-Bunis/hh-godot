extends AssistASuicoBaseAttackState

class_name AssistASuicoAssistAttackState

var Knockdownsound = preload("res://game/assets/sfx/HitLvl1.wav")

func _init():
	endFrame = 45
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 5046272, Enums.StKey.Hurt1PosY : -21561346,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : -7340031, Enums.StKey.Hurt2PosY : -5242880,
			Enums.StKey.Hurt2ScaleX : 600907, Enums.StKey.Hurt2ScaleY : 529205,
			#Enums.StKey.Hurt3PosX : 1179648, Enums.StKey.Hurt3PosY : -34734084,
			#Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			},
		14 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 5046272, Enums.StKey.Hurt1PosY : -21561346,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : -7340031, Enums.StKey.Hurt2PosY : -5242880,
			Enums.StKey.Hurt2ScaleX : 600907, Enums.StKey.Hurt2ScaleY : 529205,
			#Enums.StKey.Hurt3PosX : 1179648, Enums.StKey.Hurt3PosY : -34734084,
			#Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			Enums.StKey.Summon : "knockdowndust",
			},
		15 : {
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 23658496, Enums.StKey.Hit1PosY : -17563648,
			Enums.StKey.Hit1ScaleX : 1549250, Enums.StKey.Hit1ScaleY : 1726439,
			Enums.StKey.Hit2PosX : 9633793, Enums.StKey.Hit2PosY : -3014657,
			Enums.StKey.Hit2ScaleX : 711968, Enums.StKey.Hit2ScaleY : -321020,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 7798784, Enums.StKey.Hurt1PosY : -16056321,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : 2359296, Enums.StKey.Hurt2PosY : -4063232,
			Enums.StKey.Hurt2ScaleX : 1490095, Enums.StKey.Hurt2ScaleY : 390990,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: 55,
			Enums.StKey.blockstun: 25,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*8,
			Enums.StKey.launch_dir_y : SGFixed.ONE*48,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 80,
			Enums.StKey.attack_damage: 75,
			Enums.StKey.hitstop: 13,
			Enums.StKey.min_damage: 20,
			Enums.StKey.chip_damage: 6,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*3,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*75,
			},
		20 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,
			Enums.StKey.Hurt1PosX : 7798784, Enums.StKey.Hurt1PosY : -16056321,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : 2359296, Enums.StKey.Hurt2PosY : -4063232,
			Enums.StKey.Hurt2ScaleX : 1490095, Enums.StKey.Hurt2ScaleY : 390990,
			},
	}


# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = 0
	anim.stop(true)
	anim.play("ASuicoAssistAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 14):
		SyncManager.play_sound("SuicopathFX", Knockdownsound, {"bus": "Voice"})
		SyncManager.play_sound("SuicopathFXReverb", Knockdownsound, {"bus": "ReverbVoice"})
