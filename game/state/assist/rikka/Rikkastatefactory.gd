extends AssistStateFactory

class_name RikkaStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"AssistAttack" : preload("res://game/state/assist/rikka/RikkaAssistAttackState.gd"),
		"AssistAirAttack" : preload("res://game/state/assist/rikka/RikkaAssistAirAttackState.gd"),
		"AssistAttack2" : preload("res://game/state/assist/rikka/RikkaAssistAttack2State.gd"),
		"AssistAirAttack2" : preload("res://game/state/assist/rikka/RikkaAssistAirAttack2State.gd"),
		"AssistSuper" : preload("res://game/state/assist/rikka/RikkaAssistSuperState.gd"),
		"AssistAirSuper" : preload("res://game/state/assist/rikka/RikkaAssistAirSuperState.gd"),
		"AssistExit": preload("res://game/state/assist/rikka/RikkaAssistExitState.gd"),
		"AssistAirExit": preload("res://game/state/assist/rikka/RikkaAssistAirExitState.gd"),
		"AssistGuardCancelAttack" : preload("res://game/state/assist/rikka/RikkaAssistGuardCancelAttackState.gd"),
		"AssistAirGuardCancelAttack" : preload("res://game/state/assist/rikka/RikkaAssistAirGuardCancelAttackState.gd"),
		"AssistWeakGuardCancelAttack" : preload("res://game/state/assist/rikka/RikkaAssistWeakGuardCancelAttackState.gd"),
		"AssistAirWeakGuardCancelAttack" : preload("res://game/state/assist/rikka/RikkaAssistAirWeakGuardCancelAttackState.gd"),
	}
	
	merge_state_dictionary(new_states)
