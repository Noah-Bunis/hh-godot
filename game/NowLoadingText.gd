extends Node2D

signal end_pre_round ()

const NOWLOADINGSound = preload("res://game/assets/sfx/WhiffLvl3.wav")

const GOSound = preload("res://game/assets/sfx/GO.wav")

const GOVoice1 = preload("res://game/assets/voice/systemvoice/GoVoiceJDon.wav")
const GOVoice2 = preload("res://game/assets/voice/systemvoice/GoVoiceShiakazing.wav")
const GOVoice3 = preload("res://game/assets/voice/systemvoice/GoVoicePoltato.wav")

var enabled: bool = true
var round_tracker: RoundTracker

@export var announcer_timer: NetworkTimer

func start():
	$NetworkTimer.start()
	announcer_timer.start()
	if (enabled):
		$NetworkAnimationPlayer.play("LOADING")
		$Fade.visible = true
		SyncManager.play_sound("nowloading", NOWLOADINGSound, {"bus": "Sound"})

func _on_NetworkTimer_timeout():
	emit_signal("end_pre_round")
	$NetworkTimer.stop()
	announcer_timer.stop()
	$Fade.visible = false
	if (enabled):
		SyncManager.play_sound("go", GOSound, {"bus": "Sound"})

func skip():
	enabled = false
	$NetworkTimer.wait_ticks = 1
	$NetworkAnimationPlayer.stop()
	announcer_timer.stop()
	_on_NetworkTimer_timeout()

func _on_announcer_timer_timeout() -> void:
	announcer_timer.stop()
	if (enabled):
		var round_count = round_tracker.read_rounds_won(true) + round_tracker.read_rounds_won(false)
		if (round_count % 3 == 0):
			SyncManager.play_sound("go_voice", GOVoice1, {"bus": "Voice"})
		elif (round_count % 3 == 1):
			SyncManager.play_sound("go_voice", GOVoice2, {"bus": "Voice"})
		else:
			SyncManager.play_sound("go_voice", GOVoice3, {"bus": "Voice"})
