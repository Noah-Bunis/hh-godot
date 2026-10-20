extends AssistStateFactory

class_name AssistFlayonStateFactory

func _init():
	super._init()
	
	var new_states : Dictionary = {
		"Dormant" : AssistFlayonDormantState,
		"AssistAttack" : AssistFlayonAssistAttackState,
		"AssistAirAttack" : AssistFlayonAssistAirAttackState,
		"AssistSuper" : AssistFlayonSuperState,
		"AssistAirSuper" : AssistFlayonAirSuperState,
		"AssistAttack2" : AssistFlayonDPState,
		"AssistAirAttack2" : AssistFlayonDPState,
		"LandAttackRecovery" : AssistFlayonLandingRecoveryState,
		"AssistExit": AssistFlayonAssistExitState,
		"AssistAirExit": AssistFlayonAssistAirExitState,
		"AssistGuardCancelAttack" : AssistFlayonAssistGuardCancelAttackState,
		"AssistAirGuardCancelAttack" : AssistFlayonAssistAirGuardCancelAttackState,
		"AssistWeakGuardCancelAttack" : AssistFlayonAssistWeakGuardCancelAttackState,
		"AssistAirWeakGuardCancelAttack" : AssistFlayonAssistAirWeakGuardCancelAttackState,
		"AssistBurst" : AssistFlayonBurstState,
	}
	
	merge_state_dictionary(new_states)
