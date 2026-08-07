extends SuicopathCrouchAttackState

class_name Suicopath2BState

var CallSound = preload("res://game/assets/voice/suisei/sui_kore wa!.wav")
var Knockdownsound = preload("res://game/assets/sfx/HitLvl1.wav")

func _init():
	endFrame = 45
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 5046272, Enums.StKey.Hurt1PosY : -21561346,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : -7340031, Enums.StKey.Hurt2PosY : -5242880,
			Enums.StKey.Hurt2ScaleX : 600907, Enums.StKey.Hurt2ScaleY : 529205,
			Enums.StKey.Hurt3PosX : 1179648, Enums.StKey.Hurt3PosY : -34734084,
			Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			},
		14 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 5046272, Enums.StKey.Hurt1PosY : -21561346,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : -7340031, Enums.StKey.Hurt2PosY : -5242880,
			Enums.StKey.Hurt2ScaleX : 600907, Enums.StKey.Hurt2ScaleY : 529205,
			Enums.StKey.Hurt3PosX : 1179648, Enums.StKey.Hurt3PosY : -34734084,
			Enums.StKey.Hurt3ScaleX : 574199, Enums.StKey.Hurt3ScaleY : 659435,
			Enums.StKey.Summon : "knockdowndust",
			},
		15 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hit1PosX : 23658496, Enums.StKey.Hit1PosY : -17563648,
			Enums.StKey.Hit1ScaleX : 1549250, Enums.StKey.Hit1ScaleY : 1726439,
			Enums.StKey.Hit2PosX : 9633793, Enums.StKey.Hit2PosY : -3014657,
			Enums.StKey.Hit2ScaleX : 711968, Enums.StKey.Hit2ScaleY : -321020,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : 7798784, Enums.StKey.Hurt1PosY : -16056321,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : 2359296, Enums.StKey.Hurt2PosY : -4063232,
			Enums.StKey.Hurt2ScaleX : 1490095, Enums.StKey.Hurt2ScaleY : 390990,
			Enums.StKey.Hurt3PosX : 23724030, Enums.StKey.Hurt3PosY : -6946816,
			Enums.StKey.Hurt3ScaleX : 1636696, Enums.StKey.Hurt3ScaleY : 659435,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.guard: Enums.GuardType.Mid,
			Enums.StKey.attack_type : Enums.AttackType.GroundBouncer,
			Enums.StKey.hitstun: 55,
			Enums.StKey.blockstun: 25,
			Enums.StKey.launch_dir_x : -SGFixed.ONE*8,
			Enums.StKey.launch_dir_y : SGFixed.ONE*48,
			Enums.StKey.counter_hit: Enums.AttackType.GroundBouncer,
			Enums.StKey.counter_hitstun: 80,
			Enums.StKey.attack_damage: 110,
			Enums.StKey.meter_build: 0,
			Enums.StKey.hitstop: 10,
			Enums.StKey.min_damage: 20,
			Enums.StKey.chip_damage: 15,
			Enums.StKey.counter_launch_dir_x: SGFixed.ONE*3,
			Enums.StKey.counter_launch_dir_y: SGFixed.ONE*75,
			},
		20 : { 
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : 7798784, Enums.StKey.Hurt1PosY : -16056321,
			Enums.StKey.Hurt1ScaleX : 865010, Enums.StKey.Hurt1ScaleY : 1120549,
			Enums.StKey.Hurt2PosX : 2359296, Enums.StKey.Hurt2PosY : -4063232,
			Enums.StKey.Hurt2ScaleX : 1490095, Enums.StKey.Hurt2ScaleY : 390990,
			Enums.StKey.Hurt3PosX : 23724030, Enums.StKey.Hurt3PosY : -6946816,
			Enums.StKey.Hurt3ScaleX : 1636696, Enums.StKey.Hurt3ScaleY : 659435,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("Suicopath2B")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		SyncManager.play_sound("SuicopathVoice", CallSound, {"bus": "Voice"})
		SyncManager.play_sound("SuicopathVoiceReverb", CallSound, {"bus": "ReverbVoice"})
	elif (state[Enums.StKey.frame] == 14):
		SyncManager.play_sound("knockdown", Knockdownsound, {"bus": "Voice"})
		SyncManager.play_sound("knockdownReverb", Knockdownsound, {"bus": "ReverbVoice"})

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (state[Enums.StKey.hitStopFrame] >= 0):
		if (interpreter.is_holding_a_direction(Enums.Numpad.N6, state[Enums.StKey.leftface]) and 
				interpreter.is_button_down(Enums.InputFlags.ADown)):
			state[Enums.StKey.cancelState] = "AngelStand6A"

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
