extends Resource
const DISPLAY_NAMES: Dictionary = {
# Shared assist calls
	"AssistAttack": "D",
	"AssistAttack2": "Down D",
	"AssistSuper": "Down DownRight Right D",
	"AssistAirAttack": "D UI_COMBO_WORD_AIR",
	"AssistAirAttack2": "Down D UI_COMBO_WORD_AIR",
	"AssistAirSuper": "Down DownRight Right D UI_COMBO_WORD_AIR",

# Shared movement and normal attacks
	"GroundThrowHit": "Right A + D", "GroundThrowWhiff": "Right A + D",
	"GroundBackThrowHit": "Left A + D", "GroundBackThrowWhiff": "Left A + D",
	"AngelGroundThrowHit": "Right A + D", "AngelGroundThrowWhiff": "Right A + D",
	"AngelGroundBackThrowHit": "Left A + D", "AngelGroundBackThrowWhiff": "Left A + D",
	"AirThrowHit": "A + D UI_COMBO_WORD_AIR", "AirThrowWhiff": "A + D UI_COMBO_WORD_AIR",
	"AirBackThrowHit": "Left A + D UI_COMBO_WORD_AIR", "AirBackThrowWhiff": "Left A + D UI_COMBO_WORD_AIR",
	"AngelAirThrowHit": "A + D UI_COMBO_WORD_AIR", "AngelAirThrowWhiff": "A + D UI_COMBO_WORD_AIR",
	"AngelAirBackThrowHit": "Left A + D UI_COMBO_WORD_AIR", "AngelAirBackThrowWhiff": "Left A + D UI_COMBO_WORD_AIR",
	"Stand5A": "A", "AngelStand5A": "A", "AngelHH2": "A", "AngelHH5": "A", "AngelHH7": "A",
	"Stand6A": "Right A", "AngelStand6A": "Right A",
	"StandcB": "B UI_COMBO_WORD_CLOSE", "AngelStandcB": "B UI_COMBO_WORD_CLOSE",
	"Stand5B": "B", "AngelStand5B": "B", "AngelHH4": "B", "AngelHH8": "B",
	"Stand5C": "C", "AngelHH3": "C", "AngelHH6": "C", "AngelStand5C": "C",
	"Stand6C": "Right C", "AngelStand6C": "Right C",
	"Crouch2A": "Down A", "AngelCrouch2A": "Down A",
	"Crouch2B": "Down B", "AngelCrouch2B": "Down B",
	"Crouch2C": "Down C", "AngelCrouch2C": "Down C",
	"Crouch3C": "DownRight C", "AngelCrouch3C": "DownRight C",
	"Jump5A": "A UI_COMBO_WORD_AIR", "AngelJump5A": "A UI_COMBO_WORD_AIR",
	"Jump5B": "B UI_COMBO_WORD_AIR", "AngelJump5B": "B UI_COMBO_WORD_AIR",
	"Jump2C": "Down C UI_COMBO_WORD_AIR", "AngelJump2C": "Down C UI_COMBO_WORD_AIR",
	"Jump5C": "C UI_COMBO_WORD_AIR", "AngelJump5C": "C UI_COMBO_WORD_AIR",
	"Jump6B": "Right B UI_COMBO_WORD_AIR",
	"Jump6C": "Right C UI_COMBO_WORD_AIR",
	"Jump8C": "Up C UI_COMBO_WORD_AIR",

# Subaru
	"DuckPunch": "Right Down DownRight B UI_COMBO_WORD_AIR_OK",
	"LightDuckPunch": "Right Down DownRight A UI_COMBO_WORD_AIR_OK",
	"Stinger": "Down DownLeft Left B",
	"AirStinger": "Down DownLeft Left B UI_COMBO_WORD_AIR",
	"BatterSwing": "Down DownLeft Left A",
	"AirBatterSwing": "Down DownLeft Left A UI_COMBO_WORD_AIR",
	"BatterSet": "Down DownRight Right B",
	"AirBatterSet": "Down DownRight Right B UI_COMBO_WORD_AIR",
	"LightStarBall": "Down DownRight Right A UI_COMBO_WORD_AIR_OK",
	"AirLightStarBall": "Down DownRight Right A UI_COMBO_WORD_AIR",
	"SubaruStarBall": "Down DownRight Right A UI_COMBO_WORD_AIR_OK",
	"EXStarBall": "Down DownRight Right C",
	"AirEXStarBall": "Down DownRight Right C UI_COMBO_WORD_AIR",
	"BionicArm": "Right DownRight Down DownLeft Left Right C",
	"AngelInstall": "Down DownLeft Left Down DownLeft Left C",
	"AngelBionicArm": "Right DownRight Down DownLeft Left Right C",

# Shared Angel-form moves (Subaru Angel / Suisei Suicopath)
	"AngelDuckPunch": "Right Down DownRight B UI_COMBO_WORD_AIR_OK",
	"AngelStinger": "Down DownLeft Left B",
	"AngelAirStinger": "Down DownLeft Left B UI_COMBO_WORD_AIR",
	"AngelLightStarBall": "Down DownRight Right B",
	"AngelAirLightStarBall": "Down DownRight Right B UI_COMBO_WORD_AIR",
	"AngelSidewinder": "Down DownRight Right A UI_COMBO_WORD_AIR",
	"AngelEXStarBall": "Down DownRight Right C",
	"AngelAirEXStarBall": "Down DownRight Right C UI_COMBO_WORD_AIR",
	"AngelHH1": "Right DownRight Down DownLeft Left Right A",
	"AngelHH9": "Down DownLeft Left C",
	"AngelHH10": "Down DownRight Right D",

# Mio
	"Super1": "Left DownLeft Down DownRight Right C",
	"MioCards": "Right Down DownRight X UI_COMBO_WORD_AIR_OK",
	"MioAirCards": "Right Down DownRight X UI_COMBO_WORD_AIR",
	"ChargeStart": "Down DownRight Right X",
	"Unsummon": "Down DownLeft Left X",
	"SummonHato": "Down DownRight Right X",
	"Hato5A": "UI_COMBO_WORD_RELEASE A",
	"Hato5B": "UI_COMBO_WORD_RELEASE B",
	"Hato5C": "UI_COMBO_WORD_RELEASE C UI_COMBO_WORD_AIR_OK",
	"HatoCards": "Down DownRight Right UI_COMBO_WORD_RELEASE C UI_COMBO_WORD_AIR_OK",

# Oga
	"LightDP": "Right Down DownRight A",
	"MediumDP": "Right Down DownRight B",
	"HeavyDP": "Right Down DownRight C",
	"Snapback": "Right DownRight Down DownLeft Left C",
	"LightRiderKick": "Down DownRight Right A",
	"MediumRiderKick": "Down DownRight Right B",
	"HeavyRiderKick": "Down DownRight Right C",
	"AirRiderKickLight": "Down DownRight Right A UI_COMBO_WORD_AIR",
	"AirRiderKick": "Down DownRight Right B UI_COMBO_WORD_AIR",
	"AirRiderKickHeavy": "Down DownRight Right C UI_COMBO_WORD_AIR",
	"AirTurnKickLight": "Down DownLeft Left A UI_COMBO_WORD_AIR",
	"AirTurnKick": "Down DownLeft Left B UI_COMBO_WORD_AIR",
	"AirTurnKickHeavy": "Down DownLeft Left C UI_COMBO_WORD_AIR",
	"SlashMode": "Right DownRight Down DownLeft Left Right C",

# Suisei
	"LightYoruMatsuyo": "Down DownLeft Left A UI_COMBO_WORD_AIR_OK",
	"YoruMatsuyo": "Down DownLeft Left B UI_COMBO_WORD_AIR_OK",
	"CaramelThrust": "Down DownRight Right A UI_COMBO_WORD_OR B",
	"AirCaramelThrust": "Down DownRight Right A UI_COMBO_WORD_OR B UI_COMBO_WORD_AIR",
	"GatoKick": "UI_COMBO_WORD_STANCE ↪ A",
	"GatoDive": "UI_COMBO_WORD_STANCE ↪ Down B",
	"Pendulum": "UI_COMBO_WORD_STANCE ↪ B",
	"AngelJump2B": "Down B UI_COMBO_WORD_AIR",
	"AngelJump2B2": "Down B UI_COMBO_WORD_AIR",
	"Stance": "C UI_COMBO_WORD_CHANGE",
	"AirSuiseiToSuicopath": "C UI_COMBO_WORD_CHANGE UI_COMBO_WORD_AIR",
	"AirSuicopathToSuisei": "C UI_COMBO_WORD_CHANGE UI_COMBO_WORD_AIR",
	"Chainsaws": "Right DownRight Down DownLeft Left Right B",
	"Scissors": "Right DownRight Down DownLeft Left A",

# Ollie
	"OllieRook": "UI_COMBO_WORD_RELEASE A",
	"SetOllieRook": "Down DownLeft Left UI_COMBO_WORD_TAP A UI_COMBO_WORD_AIR_OK",
	"OllieChargeRook": "UI_COMBO_WORD_RELEASE A (UI_COMBO_WORD_ENHANCED)",
	"SetOllieChargeRook": "Down DownLeft Left UI_COMBO_WORD_HOLD A UI_COMBO_WORD_AIR_OK",
	"OllieChargeKnight": "UI_COMBO_WORD_RELEASE C (UI_COMBO_WORD_ENHANCED)",
	"SetOllieChargeKnight": "Down DownLeft Left UI_COMBO_WORD_HOLD C UI_COMBO_WORD_AIR_OK",
	"OllieProtonCannon": "Down DownRight Right C",
	"ChessA": "Down DownLeft Left A",
	"ChessB": "Down DownLeft Left B",
	"ChessC": "Down DownLeft Left C",
	"AirChessA": "Down DownLeft Left A UI_COMBO_WORD_AIR",
	"AirChessB": "Down DownLeft Left B UI_COMBO_WORD_AIR",
	"AirChessC": "Down DownLeft Left C UI_COMBO_WORD_AIR",
	"ProtonCannon": "Down DownRight Right C",
	"Stand6CRelease": "UI_COMBO_WORD_RELEASE Right C",

# Kanata
	"KanataAirFiftyKGHit": "Right DownRight Down DownLeft Left A UI_COMBO_WORD_AIR",
	"KanataFiftyKGHit": "Right DownRight Down DownLeft Left A",
	"KanataAirFiftyRekkaA": "Right DownRight Down DownLeft Left A UI_COMBO_WORD_AIR",
	"KanataSuperFiftyRekkaA":"Right DownRight Down DownLeft Left C",
	"KanataFiftyKGWhiff": "Right DownRight Down DownLeft Left A",
	"KanataAirFiftyKGWhiff": "Right DownRight Down DownLeft Left A UI_COMBO_WORD_AIR",
	"KanataSuperFiftyKGWhiff": "Right DownRight Down DownLeft Left C",
	"KanataAirWingHazard": "Down DownLeft Left B UI_COMBO_WORD_AIR",
	"KanataWingStanceEnter":"Down DownRight Right X",
	"KanataWingStance":"Down DownRight Right X",
	"AirKanataWingStance":"Down DownRight Right X UI_COMBO_WORD_AIR",
	"KanataRolling":"Down Down X",
	"AirKanataRolling":"Down Down A UI_COMBO_WORD_AIR",
	"KanataWingStanceA":"UI_COMBO_WORD_STANCE ↪ A",
	"KanataWingStanceAA":"UI_COMBO_WORD_STANCE ↪ A UI_COMBO_WORD_THEN A",
	"KanataWingStanceC":"UI_COMBO_WORD_STANCE ↪ C",
	"KanataWingStanceB":"UI_COMBO_WORD_STANCE ↪ B",
	"KanataAirWingStanceA":"UI_COMBO_WORD_STANCE ↪ A UI_COMBO_WORD_AIR",
	"KanataAirWingStanceAA":"UI_COMBO_WORD_STANCE ↪ A UI_COMBO_WORD_THEN A UI_COMBO_WORD_AIR",
	"KanataAirWingStanceB":"UI_COMBO_WORD_STANCE ↪ B UI_COMBO_WORD_AIR",
	"KanataAirWingStanceC":"UI_COMBO_WORD_STANCE ↪ C UI_COMBO_WORD_AIR",

# Flayon
	"GrappleFollowup": "Down DownRight Right A UI_COMBO_WORD_OR B UI_COMBO_WORD_AIR_OK",
	"AirGrapple": "Down DownRight Right A UI_COMBO_WORD_OR B UI_COMBO_WORD_AIR",
	"Grapple": "Down DownRight Right A UI_COMBO_WORD_OR B",
	"Flight5A": "A UI_COMBO_WORD_FLIGHT",
	"Flight5B": "UI_COMBO_WORD_HOLD B UI_COMBO_WORD_FLIGHT",
	"Flight5C": "UI_COMBO_WORD_HOLD C UI_COMBO_WORD_FLIGHT",
	"Flight2C": "UI_COMBO_WORD_HOLD Down C UI_COMBO_WORD_FLIGHT",
	"Flight5BEarly": "B UI_COMBO_WORD_FLIGHT",
	"Flight5CEarly": "C UI_COMBO_WORD_FLIGHT",
	"Flight2CEarly": "Down C UI_COMBO_WORD_FLIGHT",
	"Flight5BIncrease": "UI_COMBO_WORD_HOLD B UI_COMBO_WORD_FLIGHT",
	"Flight5CIncrease": "UI_COMBO_WORD_HOLD C UI_COMBO_WORD_FLIGHT",
	"Flight8C": "Up C UI_COMBO_WORD_FLIGHT",
	"Flight2CIncrease": "UI_COMBO_WORD_HOLD Down C UI_COMBO_WORD_FLIGHT",
	"FlightEnter": "Down DownLeft Left X",
	"AirFlightEnter": "Down DownLeft Left X UI_COMBO_WORD_AIR",
	"DeusExMachina": "Down DownRight Right C",
	"AirStomp": "Down DownRight Right C UI_COMBO_WORD_AIR",
	"RyukenShiki": "Right Down DownRight A UI_COMBO_WORD_OR B UI_COMBO_WORD_AIR_OK",

# OkaKoro assist
	"HammerStartup" : "UI_COMBO_WORD_TAP D UI_COMBO_WORD_THEN UI_COMBO_WORD_HOLD Left",
	"HammerFollowup" : "UI_COMBO_WORD_RELEASE Left UI_COMBO_WORD_EARLY",
	"HammerJustFollowup" : "UI_COMBO_WORD_RELEASE Left UI_COMBO_WORD_PERFECT",
	"AirHammerFollowup" : "UI_COMBO_WORD_RELEASE Left UI_COMBO_WORD_AIR UI_COMBO_WORD_EARLY",
	"AirHammerJustFollowup" : "UI_COMBO_WORD_RELEASE Left UI_COMBO_WORD_AIR UI_COMBO_WORD_PERFECT",
	"JumpStartup" : "UI_COMBO_WORD_TAP D UI_COMBO_WORD_THEN UI_COMBO_WORD_HOLD Down",
	"JumpFollowup" : "UI_COMBO_WORD_RELEASE Down UI_COMBO_WORD_EARLY",
	"JumpJustFollowup" : "UI_COMBO_WORD_RELEASE Down UI_COMBO_WORD_PERFECT",
	"AssistAirSuperAttack" : "UI_COMBO_WORD_RELEASE X",

# Oga assist
	"AssistSuperFollowup" : "UI_COMBO_WORD_RELEASE D",
	"AssistAirSuperFollowup": "UI_COMBO_WORD_RELEASE D",

# Mio assist
	"Assist5A": "UI_COMBO_WORD_RELEASE A",
	"Assist5B": "UI_COMBO_WORD_RELEASE B",
	"Assist5C": "UI_COMBO_WORD_RELEASE C",
	"AssistjA": "UI_COMBO_WORD_RELEASE A UI_COMBO_WORD_AIR",
	"AssistjB": "UI_COMBO_WORD_RELEASE B UI_COMBO_WORD_AIR",
	"AssistjC": "UI_COMBO_WORD_RELEASE C UI_COMBO_WORD_AIR",

# Subaru assist
	"AssistSubaruStarBall": "D",

# Rikka assist
	"RikkaBall": "D",
	"RikkaBigBall": "Down D",
	"RikkaSuperBall": "Down DownRight Right D",

# Hakka assist
	"AirSuperCharge1": "UI_COMBO_WORD_RELEASE D (UI_COMBO_WORD_CHARGE 1)",
	"AirSuperCharge2": "UI_COMBO_WORD_RELEASE D (UI_COMBO_WORD_CHARGE 2)",
	"AirSuperCharge3": "UI_COMBO_WORD_RELEASE D (UI_COMBO_WORD_CHARGE 3)",
	"HakkaTags": "D",

# Suisei assist
	"ASuicoAssistAirAttack2": "Down D UI_COMBO_WORD_STANCE UI_COMBO_WORD_AIR",
	"ASuicoAssistAttack2": "Down D UI_COMBO_WORD_STANCE",
	"ASuicoAssistAirAttack": "D UI_COMBO_WORD_STANCE UI_COMBO_WORD_AIR",
	"ASuicoAssistAttack": "D UI_COMBO_WORD_STANCE",
	"ASuicoAssistSuper": "Down DownRight Right D UI_COMBO_WORD_STANCE",
	"ASuicoAssistAirSuper": "Down DownRight Right D UI_COMBO_WORD_STANCE UI_COMBO_WORD_AIR",
	"ASuicoAssistAttackFollowup": "   ↪",

# Shared assist followup states
	"AssistSuperAttack" : "UI_COMBO_WORD_RELEASE X",
}

const CHARACTER_DISPLAY_NAMES: Dictionary = {
	"Kanata": {
		"AssistAttackFollowup": "   ↪",
		"AssistAirAttackFollowup": "   ↪ UI_COMBO_WORD_AIR",
	},
	"Ollie": {
		"EXStarBall": "Down DownRight Right B",
		"AirEXStarBall": "Down DownRight Right B UI_COMBO_WORD_AIR",
	},
	"Suisei": {
		"AngelInstall": "C UI_COMBO_WORD_CHANGE",
		"AngelUninstall": "C UI_COMBO_WORD_CHANGE",
		"Stand5C": "C UI_COMBO_WORD_CHANGE",
		"Jump5C": "C UI_COMBO_WORD_CHANGE UI_COMBO_WORD_AIR",
	},
}

static func get_display_name(character_name: String, state_name: String) -> String:
	var character_names: Dictionary = CHARACTER_DISPLAY_NAMES.get(
		character_name,
		{}
	)
	return str(
		character_names.get(
			state_name,
			DISPLAY_NAMES.get(state_name, state_name)
		)
	)
