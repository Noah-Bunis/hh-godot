extends "res://game/state/kanata/mainstates/kanataAirAttackState.gd"

class_name KanataAirWingStanceCState


var Voice = preload("res://game/assets/voice/kanata/amk_gooooooooooooo.wav")

func _init():
	endFrame = 7
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -4849664, Enums.StKey.Hurt1PosY : -9437184,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 3014656, Enums.StKey.Hurt2PosY : -16187392,
			Enums.StKey.Hurt2ScaleX : 1024561, Enums.StKey.Hurt2ScaleY : -708704,
			Enums.StKey.Hurt3PosX : -5373952, Enums.StKey.Hurt3PosY : -19136512,
			Enums.StKey.Hurt3ScaleX : 1150714, Enums.StKey.Hurt3ScaleY : -810479,
			},
		4 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable: true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : 0,
			Enums.StKey.Hit1ScaleX : 18338272, Enums.StKey.Hit1ScaleY : 18338272,
			Enums.StKey.hit_box_colliding_frame : 254,
			Enums.StKey.hitstop: 0,
			Enums.StKey.meter_build: 0,
			Enums.StKey.attack_type : Enums.AttackType.BurstLock,
			Enums.StKey.counter_hit : Enums.AttackType.BurstLock,
		},
		5 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -4849664, Enums.StKey.Hurt1PosY : -9437184,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 3014656, Enums.StKey.Hurt2PosY : -16187392,
			Enums.StKey.Hurt2ScaleX : 1024561, Enums.StKey.Hurt2ScaleY : -708704,
			Enums.StKey.Hurt3PosX : -5373952, Enums.StKey.Hurt3PosY : -19136512,
			Enums.StKey.Hurt3ScaleX : 1150714, Enums.StKey.Hurt3ScaleY : -810479,
			Enums.StKey.Summon : "rundust",
			},
		6 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -4849664, Enums.StKey.Hurt1PosY : -9437184,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 3014656, Enums.StKey.Hurt2PosY : -16187392,
			Enums.StKey.Hurt2ScaleX : 1024561, Enums.StKey.Hurt2ScaleY : -708704,
			Enums.StKey.Hurt3PosX : -5373952, Enums.StKey.Hurt3PosY : -19136512,
			Enums.StKey.Hurt3ScaleX : 1150714, Enums.StKey.Hurt3ScaleY : -810479,
			Enums.StKey.Summon : "rundust",
			},
		12 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -4849664, Enums.StKey.Hurt1PosY : -9437184,
			Enums.StKey.Hurt1ScaleX : 871288, Enums.StKey.Hurt1ScaleY : 1034829,
			Enums.StKey.Hurt2PosX : 3014656, Enums.StKey.Hurt2PosY : -16187392,
			Enums.StKey.Hurt2ScaleX : 1024561, Enums.StKey.Hurt2ScaleY : -708704,
			Enums.StKey.Hurt3PosX : -5373952, Enums.StKey.Hurt3PosY : -19136512,
			Enums.StKey.Hurt3ScaleX : 1150714, Enums.StKey.Hurt3ScaleY : -810479,
			Enums.StKey.Summon : "rundust",
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	anim.play("WingStanceC")
	state[Enums.StKey.super_meter] -= Util.LEVEL_ONE_SUPER
	state[Enums.StKey.accel_y] = 0
	state[Enums.StKey.velocity_y] = -SGFixed.ONE*25


func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 4):
		SyncManager.play_sound("KanataVoice", Voice, {"bus": "Voice"})
		SyncManager.play_sound("KanataVoiceReverb", Voice, {"bus": "ReverbVoice"})
	elif (state[Enums.StKey.frame] >= 5):
		state[Enums.StKey.accel_y] = Util.GRAVITY
		state[Enums.StKey.velocity_x] = SGFixed.ONE*40
		state[Enums.StKey.velocity_y] = SGFixed.ONE*80

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
