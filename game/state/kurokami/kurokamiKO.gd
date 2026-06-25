extends KOState

class_name KurokamiKOState

var voice = preload("res://game/assets/voice/flayon/mxf_its_nothing_to_me.wav")

func enter(state: Dictionary) -> void:
	super.enter(state)
	SyncManager.play_sound("kurokamiVoice", voice, {"bus": "Voice"})
	SyncManager.play_sound("kurokamiVoiceReverb", voice, {"bus": "ReverbVoice"})
