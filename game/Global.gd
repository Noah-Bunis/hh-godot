extends Node

var BATTLE_ENGINE_VERSION = "HHv0.7.0002"
var LOCAL_SERVER = false
var FIGHTER_GAME = preload("res://game/FighterGame.tscn")
var load_queue = preload("res://game/simple_resource_queue.gd").new()

var PLAYER_1_NODE_PATH = ["res://game/fighter/SubaruPlayer.tscn", "res://game/fighter/assist/fubuki/FubukiPlayer.tscn", "res://game/fighter/puppet/HatoPuppet.tscn"]
var PLAYER_2_NODE_PATH = ["res://game/fighter/SubaruPlayer.tscn", "res://game/fighter/assist/fubuki/FubukiPlayer.tscn", "res://game/fighter/puppet/HatoPuppet.tscn"]

var PLAYER_1_NODE = [null, null, null]
var PLAYER_2_NODE = [null, null, null]

var PLAYER_1_NODE_INSTANCE = [null, null, null]
var PLAYER_2_NODE_INSTANCE = [null, null, null]

var PLAYER_1_CHARACTER = [Enums.PointCharacters.Subaru, Enums.AssistCharacters.Fubuki, Enums.PuppetCharacters.Hato]
var PLAYER_2_CHARACTER = [Enums.PointCharacters.Subaru, Enums.AssistCharacters.Fubuki, Enums.PuppetCharacters.Hato]

var PLAYER_1_COLOR = ["res://game/assets/sprites/oga/ColorPalettes/1.png", "res://game/assets/sprites/assists/fubuki/ColorPalettes/1.png"]
var PLAYER_2_COLOR = ["res://game/assets/sprites/oga/ColorPalettes/2.png", "res://game/assets/sprites/assists/fubuki/ColorPalettes/1.png"]

var PLAYER_1_COLOR_INSTANCE = [null, null]
var PLAYER_2_COLOR_INSTANCE = [null, null]

var server_input_interpreter: Node
var client_input_interpreter: Node

var was_spectating: bool # SyncManager resets spectator status when stopping, remember your spectator status during a long set
var user_display_name: String

var LOADED_STAGE_BACKGROUND = null
var STAGE_ART_ID = 1
var BGM_ID = 1
var BGM_RANDOM_ONCE = false
var STAGE_RANDOM_ONCE = false
var BGM_IS_P1_SIDE: bool = false
var BGM_IS_ASSIST: bool = false

func BGM_CHARACTER() -> int:
	if BGM_IS_P1_SIDE:
		if (BGM_IS_ASSIST):
			return PLAYER_1_CHARACTER[1]
		else:
			return PLAYER_1_CHARACTER[0]
	else:
		if (BGM_IS_ASSIST):
			return PLAYER_2_CHARACTER[1]
		else:
			return PLAYER_2_CHARACTER[0]

func STAGE_CHARACTER() -> int:
	if BGM_IS_P1_SIDE:
		return PLAYER_1_CHARACTER[0]
	else:
		return PLAYER_2_CHARACTER[0]

func get_color_palette(is_p1: bool, is_assist: bool):
	var instance = null
	if (is_p1):
		if (is_assist):
			instance = PLAYER_1_COLOR_INSTANCE[1]
		else:
			instance = PLAYER_1_COLOR_INSTANCE[0]
	else:
		if (is_assist):
			instance = PLAYER_2_COLOR_INSTANCE[1]
		else:
			instance = PLAYER_2_COLOR_INSTANCE[0]
	if (not is_instance_valid(instance) or instance == null):
		push_error("color palette is not valid for: " + str(is_p1) + " " + str(is_assist))
	return instance

func load_new_color(is_p1, is_assist):
	var color_slot = ""
	var instance = null
	if (is_p1):
		if (is_assist):
			color_slot = PLAYER_1_COLOR[1]
			instance = PLAYER_1_COLOR_INSTANCE[1]
		else:
			color_slot = PLAYER_1_COLOR[0]
			instance = PLAYER_1_COLOR_INSTANCE[0]
	else:
		if (is_assist):
			color_slot = PLAYER_2_COLOR[1]
			instance = PLAYER_2_COLOR_INSTANCE[1]
		else:
			color_slot = PLAYER_2_COLOR[0]
			instance = PLAYER_2_COLOR_INSTANCE[0]
			
	#if (instance != null and is_instance_valid(instance)):
		#instance.queue_free() # Refcounted auto garbage collects
	instance = load(color_slot)
	
	if (is_p1):
		if (is_assist):
			PLAYER_1_COLOR_INSTANCE[1] = instance
		else:
			PLAYER_1_COLOR_INSTANCE[0] = instance
	else:
		if (is_assist):
			PLAYER_2_COLOR_INSTANCE[1] = instance
		else:
			PLAYER_2_COLOR_INSTANCE[0] = instance

# Stages and Music Selection
const STAGE_LIST = [
	'Auto',
	'Random Once',
	'Random Always',
	'Ruined HoloGra Office',
	'Pleiades Star Beach',
	'Hollow Garden',
	'Heart Of The Forest',
	'News Room',
	'Streets!',
	'Waffle House',
	'None',
]

const BGM_LIST = [
	'Auto',
	'Random Once',
	'Random Always',
	'Pleiades',
	'Howling',
	'Silent Night Requiem',
	'Chuuku No Niwa',
	'The Wahphony',
	'Detabare Neko',
	'Mogu Mogu Yummy',
	'Saikyo Tensai',
	'Just Follow Stars',
	'Graveyard Shift',
	'Battle At The Top Of The World',
	'Yume Hanabi',
	'Homenobi',
	'Palette',
	'Heroine Audition',
	'WIM',
	'This MU is (2-8) At Best',
]

var p1_device_id: int = 0
var p2_device_id: int = 1
var p1_is_gamepad: bool = false
var p2_is_gamepad: bool = false

var MATCH_TOTAL: int = 0
var P1_WIN_TOTAL: int = 0
var SET_TOTAL: int = 0
var P1_SET_WIN_TOTAL: int = 0
var P1_WIN_STREAK: int = 0
var P2_WIN_STREAK: int = 0

var P1_WON_MATCH: bool = true

# Netplay
enum NETPLAY_MODES {
	OFFLINE,
	PRIVATE_ROOM,
	PUBLIC_QUEUE,
	DIRECT_IP,
}
var NETPLAY_MODE: int = NETPLAY_MODES.OFFLINE
var IS_PUBLIC_LOBBY: bool = false
var nakama_client: NakamaClient = null
var nakama_socket = null
var nakama_session: NakamaSession = null

var replay_logging_enabled: bool = true

# Training
var IS_TRAINING: bool = false
var TRAINING_P1: bool = true
var HITBOX_DISPLAY: bool = false
var REPLAY_FILE_NAME: String = ""
var IS_REPLAY: bool = false

var ROLLBACK_LOGS_ENABLED: bool = false
var DEBUG: bool = false

var input_maps = {
	-2 : {},
	-1 : {}, # keyboard p1
	0 : {}, # none
	1 : {}, # p1
	2 : {}, # p2
}

# Universal Resource Checks
func level_1_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.LEVEL_ONE_SUPER

func level_2_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.LEVEL_TWO_SUPER

func level_3_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.LEVEL_THREE_SUPER

func level_5_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.MAX_SUPER_METER

func assist_ok(state: Dictionary, interpreter: InputInterpreter) -> bool:
	return assist_meter_ok(state) and interpreter.is_button_down(Enums.InputFlags.DDown)

func assist_meter_ok(state: Dictionary) -> bool:
	return state[Enums.StKey.assist_meter] >= Util.ASSIST_STOCK

func super_assist_meter_ok(state: Dictionary) -> bool:
	return state[Enums.StKey.assist_meter] >= Util.ASSIST_STOCK*2

func burst_OK(state: Dictionary, interpreter: InputInterpreter) -> bool:
	var cost_OK:bool = state[Enums.StKey.super_meter] >= state[Enums.StKey.burst_cost]*Util.LEVEL_ONE_SUPER
	return state[Enums.StKey.burst_OK] and cost_OK and interpreter.burst()

func boost_OK(state: Dictionary, interpreter: InputInterpreter) -> bool:
	return level_1_OK(state) and interpreter.is_button_down(Enums.InputFlags.ADown | Enums.InputFlags.BDown | Enums.InputFlags.CDown)

# Universal object templates
const HitVFX = preload("res://game/fighter/effects/Hit.tscn")
const CHHitVFX = preload("res://game/fighter/effects/CHHit.tscn")
const BlockVFX = preload("res://game/fighter/effects/Block.tscn")
const JustBlockVFX = preload("res://game/fighter/effects/JustBlock.tscn")
const PushBlockVFX = preload("res://game/fighter/effects/PushBlock.tscn")
const JustPushBlockVFX = preload("res://game/fighter/effects/JustPushBlock.tscn")
const ParryVFX = preload("res://game/fighter/effects/Parry.tscn")
const RedParryVFX = preload("res://game/fighter/effects/RedParry.tscn")

const EmptySound = preload("res://game/assets/voice/Empty.wav")
const AirdashSound = preload("res://game/assets/sfx/Airdash.wav")
const SuperFlashSound = preload("res://game/assets/sfx/SuperFlash.wav")
const GroundBounceSound = preload("res://game/assets/sfx/HitLvl1.wav")
const HitLV1Sound = preload("res://game/assets/sfx/HitLvl2.wav")
const HitLV3Sound = preload("res://game/assets/sfx/HitLvl3.wav")
const CHHitSound = preload("res://game/assets/sfx/CHHit.wav")

const BlockLV3Sound = preload("res://game/assets/sfx/BlockLvl2.wav")
const JustBlockSound = preload("res://game/assets/sfx/RomanCancel.wav")
const ParrySound = preload("res://game/assets/sfx/Parry.wav")

# Point Player effects
const BurstVFX = preload("res://game/fighter/effects/Burst.tscn")
const RCVFX = preload("res://game/fighter/effects/RadicalCancel.tscn")
const AirdashVFX = preload("res://game/fighter/effects/Airdash.tscn")
const RunDustVFX = preload("res://game/fighter/effects/RunDust.tscn")
const JumpDustVFX = preload("res://game/fighter/effects/JumpDust.tscn")
const KnockdownDustVFX = preload("res://game/fighter/effects/KnockdownDust.tscn")
const WallBounceDustVFX = preload("res://game/fighter/effects/WallBounceDust.tscn")
const SuperJumpDustVFX = preload("res://game/fighter/effects/SuperJumpDust.tscn")
const FDBubbleVFX = preload("res://game/fighter/effects/FDBubble.tscn")
const RedParryFlashVFX = preload("res://game/fighter/effects/RedParryFlash.tscn")
const ParryWhiffVFX = preload("res://game/fighter/effects/ParryWhiffFlash.tscn")
const TagVFX = preload("res://game/fighter/effects/AssistTag.tscn")
const RCSound = preload("res://game/assets/sfx/RomanCancel.wav")
const WhiffSound = preload("res://game/assets/sfx/Whiff.wav")
const AirTechSound = preload("res://game/assets/sfx/AirTech.wav")
