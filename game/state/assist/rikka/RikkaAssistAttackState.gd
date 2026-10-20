extends AssistAttackState

class_name RikkaAssistAttackState

var CallSound = preload("res://game/assets/voice/rikka/RKA_you~.wav")

func _init():
	endFrame = 30
	
	anim_data = {
		0 : {
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			Enums.StKey.Hit1PosX : 0, Enums.StKey.Hit1PosY : -11337728,
			Enums.StKey.Hit1ScaleX : 686985, Enums.StKey.Hit1ScaleY : 1074037,
			},
		8 : {
			Enums.StKey.Summon : "RikkaBall",
			Enums.StKey.Hurt1Disable : false, Enums.StKey.Hurt2Disable : true,
			},
	}

# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.velocity_x] = 0
	state[Enums.StKey.velocity_y] = 0
	state[Enums.StKey.drag_x] = Util.FRICTION
	anim.stop(true)
	anim.play("AssistAttack")

func physics_tick(state: Dictionary) -> void:
	super.physics_tick(state)
	if (state[Enums.StKey.frame] == 3):
		SyncManager.play_sound("RikkaVoice", CallSound, {"bus": "Voice"})
		SyncManager.play_sound("RikkaVoiceReverb", CallSound, {"bus": "ReverbVoice"})