extends Node2D

signal end_down ()

const DOWNSound = preload("res://game/assets/sfx/DOWN.wav")

var round_tracker: RoundTracker

func _ready():
	reset()

func reset():
	$NetworkAnimationPlayer.play("EMPTY")

func play_down_text():
	#$Sprite2D.visible = true
	$NetworkAnimationPlayer.play("DOWN")
	$NetworkTimer.start()
	SyncManager.play_sound("down", DOWNSound, {"bus": "Sound"})

func play_double_ko_text():
	#$Sprite2D.visible = true
	$NetworkAnimationPlayer.play("DOUBLEKO")
	$NetworkTimer.start()
	SyncManager.play_sound("parry", Global.ParrySound, {"bus": "Sound"})
	SyncManager.play_sound("down", DOWNSound, {"bus": "Sound"})

func play_time_over_text():
	#$Sprite2D.visible = true
	$NetworkAnimationPlayer.play("TIMEOUT")
	$NetworkTimer.start()
	SyncManager.play_sound("down", Global.AirTechSound, {"bus": "Sound"})

func play_draw_text():
	#$Sprite2D.visible = true
	$NetworkAnimationPlayer.play("DRAW")
	$NetworkTimer.start()
	SyncManager.play_sound("parry", Global.ParrySound, {"bus": "Sound"})

func _on_NetworkTimer_timeout():
	if (not round_tracker.is_game_over()):
		$NetworkAnimationPlayer.play("EMPTY")
		$NetworkTimer.stop()
		emit_signal("end_down")
