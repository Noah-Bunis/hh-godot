class_name Enums
enum StKey {
	stateName,  # 0
	next_state,  # 1
	transition_state_flag,  # 2
	velocity_x,  # 3
	velocity_y,  # 4
	accel_x,
	accel_y,
	drag_x,
	modify_x,
	leftface,
	leftfaceOK,
	frame, # 11
	last_anim_frame,
	hitStopFrame, # 13
	hit_box_colliding_frame,  # 14
	cancelState,
	hitstun,
	hitCount,
	comboTime,
	doubleJump,
	airDash,
	ground_bounce,
	wall_bounce,
	counterOK,
	assist_meter, # 24
	sync_rate, # 25
	old_sync_rate,
	super_meter, # 27
	opponent_pos_x,
	distance_to_opponent,
	burst_OK,
	burst_cost,
	capture_anchor,
	throw_protect,
	kara_OK,
	projectile_hp,
	counter_hitstun,
	fixed_position_x,
	fixed_position_y, # 38
	fixed_scale_x,
	fixed_scale_y,
	disabled,
	hitstop,
	attack_type,
	attack_damage,
	guard,
	blockstun,
	chip_damage,
	min_damage,
	meter_build,
	launch_dir_x,
	launch_dir_y,
	block_dir_x,
	block_dir_y,
	counter_hit,
	counter_launch_dir_x,
	counter_launch_dir_y,
	Hit1Disable,
	Hurt1Disable,
	Hit2Disable,
	Hurt2Disable,
	Hurt3Disable,
	Hit1PosX,
	Hit1PosY,
	Hurt1PosX,
	Hurt1PosY,
	Hit1ScaleX,
	Hit1ScaleY,
	Hurt1ScaleX,
	Hurt1ScaleY,
	Hit2PosX,
	Hit2PosY,
	Hurt2PosX,
	Hurt2PosY,
	Hit2ScaleX,
	Hit2ScaleY,
	Hurt2ScaleX,
	Hurt2ScaleY,
	Hurt3PosX,
	Hurt3PosY,
	Hurt3ScaleX,
	Hurt3ScaleY,
	Destroy,
	Summon,
	WarpOffScreen,
	hit_cooldown, # 85
	hit_box_colliding_frame_attack_data,
}

enum AllCharacters {
	Subaru,
	Mio,
	Oga,
	Ollie,
	Suisei,
	Kanata,
	Flayon,
	Fubuki,
	Sora,
	Sana,
	OkaKoro,
	Hakka,
	AssistSubaru,
	AssistMio,
	AssistOga,
	AssistOllie,
	AssistSuisei,
	AssistKanata,
	AssistFlayon,
	Random,
}

enum PointCharacters {
	Subaru,
	Mio,
	Oga,
	Ollie,
	Suisei,
	Kanata,
	Flayon,
	Eight,
	Nine,
	Ten,
	Eleven,
	Twelve,
	Random,
}

enum AssistCharacters {
	Fubuki,
	Sora,
	Sana,
	OkaKoro,
	Hakka,
	Subaru,
	Mio,
	Oga,
	Ollie,
	Suisei,
	Kanata,
	Flayon,
	Eight,
	Nine,
	Ten,
	Eleven,
	Twelve,
	Random,
}

enum PuppetCharacters {
	Hato,
}

enum Projectiles {
	HighMioCannon,
	SubaruStarBall,
	SubaruBatterSetBall,
	OllieRook,
	OllieBishop,
	OllieKnight,
	OllieAirKnight,
	OllieChargeRook,
	OllieChargeBishop,
	OllieChargeKnight,
	OllieQueen,
	OllieProtonCannon,
	SuicopathChainsaw,
	AssistSubaruStarBall,
	AssistOllieProtonCannon,
	HakkaTags,
}

enum AttackType {
	Strike,
	Launcher,
	GroundBouncer,
	WallBouncer,
	Throw,
	AirThrow,
	BurstLock,
}

enum ReactTypeCategory {
	Strike,
	Throw,
	BurstLock,
}

enum GuardType {
	Mid,
	Low,
	High,
	Unblockable,
}

enum HitType {
	Strike,
	Projectile,
	Block,
	Throw,
	PushBlock,
	JustPushBlock,
	Parry,
}

enum Reaction {
	StrikeHit,
	StrikeHurt,
	LaunchHurt,
	GroundBounceHurt,
	WallBounceHurt,
	BlockHurt,
	JustBlockHurt,
	ParryHurt,
	ThrowHurt,
	AirThrowHurt,
	ThrowHit,
	GroundLand,
	WallLand,
	KOHurt,
	TagCall,
	ForceTagOut,
	BurstLockHurt,
	PointBlockHurt,
	PointAttackHurt,
}

enum StateProperty {
	BlockingOK,
	StrikeInvul,
	AirThrowOK,
	GroundThrowOK,
	CrossupProtect,
	LowProtect,
	HighProtect,
	LowParry,
	HighParry,
	RedParry,
	DormantAssist,
	DrainAssistMeter,
	ExtraChip,
	OTG,
	Capture,
}

enum TrainingBlock { NONE, ALL }
enum TrainingBlockSwitch { ENABLED, DISABLED }
enum TrainingBlockType { NONE, NORMAL, IB, FD, IFD, PARRY }
enum TrainingRecovery { NEUTRAL, FORWARD, BACKWARD, OFF }
enum TrainingCounterHit { OFF, ON, ASSIST_DANGER }
enum TrainingStance { STAND, CROUCH, JUMP }
enum TrainingHitboxes { NONE, ALL }


enum PlayerInput {
	InputVector
}

enum InputFlags {
	UP = 1,
	DOWN = 1 << 1,
	LEFT = 1 << 2,
	RIGHT = 1 << 3,
	ADown = 1 << 4,
	BDown = 1 << 5,
	CDown = 1 << 6,
	DDown = 1 << 7,
	AHold = 1 << 8,
	BHold = 1 << 9,
	CHold = 1 << 10,
	DHold = 1 << 11,
	AUp = 1 << 12,
	BUp = 1 << 13,
	CUp = 1 << 14,
	DUp = 1 << 15,
}

enum Numpad {
	N1,
	N2,
	N3,
	N4,
	N5,
	N6,
	N7,
	N8,
	N9
}
#
#func suicopath_scissors_OK(state: Dictionary, interpreter: InputInterpreter) -> bool:
	#return level_1_OK(state) and interpreter.special_input_button(Enums.SpecialInput.M63214, Enums.InputFlags.ADown, state[Enums.StKey.leftface])

func level_1_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.LEVEL_ONE_SUPER

func level_2_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.LEVEL_TWO_SUPER

func level_3_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.LEVEL_THREE_SUPER

func level_5_OK(state: Dictionary) -> bool:
	return state[Enums.StKey.super_meter] >= Util.MAX_SUPER_METER

const SpecialInput: Dictionary = {
	"FDash" : [15, [Numpad.N6, Numpad.N5, Numpad.N6]],
	"BDash" : [15, [Numpad.N4, Numpad.N5, Numpad.N4]],
	"FAirDash" : [17, [Numpad.N6, Numpad.N5, Numpad.N6], [Numpad.N6, Numpad.N5, Numpad.N9], [Numpad.N6, Numpad.N5, Numpad.N8, Numpad.N9], [Numpad.N6, Numpad.N5, Numpad.N6, Numpad.N9]],
	"BAirDash" : [17, [Numpad.N4, Numpad.N5, Numpad.N4], [Numpad.N4, Numpad.N5, Numpad.N7], [Numpad.N4, Numpad.N5, Numpad.N8, Numpad.N7], [Numpad.N4, Numpad.N5, Numpad.N4, Numpad.N7]],
	"UAirDash" : [17, [Numpad.N8, Numpad.N5, Numpad.N8]],
	"DAirDash" : [17, [Numpad.N2, Numpad.N5, Numpad.N2]],
	"M236" : [20, [Numpad.N6, Numpad.N3, Numpad.N2], [Numpad.N5, Numpad.N6, Numpad.N3, Numpad.N2], [Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N2]],
	"M214" : [20, [Numpad.N4, Numpad.N1, Numpad.N2], [Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2], [Numpad.N7, Numpad.N4, Numpad.N1, Numpad.N2]],
	"M214Strict" : [20, [Numpad.N4, Numpad.N1, Numpad.N2], [Numpad.N7, Numpad.N4, Numpad.N1, Numpad.N2]],
	"M623" : [25, [Numpad.N3, Numpad.N2, Numpad.N5, Numpad.N6], [Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N5, Numpad.N6], [Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N5, Numpad.N6], [Numpad.N3, Numpad.N2, Numpad.N6], [Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N6], [Numpad.N3, Numpad.N2, Numpad.N3, Numpad.N6], [Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N3, Numpad.N6], [Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N3, Numpad.N6]],
	"M41236" : [25, [Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N1, Numpad.N4], [Numpad.N5, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N1, Numpad.N4], [Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N1, Numpad.N4], 
					[Numpad.N6, Numpad.N2, Numpad.N1, Numpad.N4], [Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N4], [Numpad.N6, Numpad.N3, Numpad.N1, Numpad.N4],
					[Numpad.N9, Numpad.N6, Numpad.N2, Numpad.N1, Numpad.N4], [Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N4], [Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N1, Numpad.N4]],
	"M63214" : [25, [Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N3, Numpad.N6], [Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N3, Numpad.N6], [Numpad.N7, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N3, Numpad.N6], 
					[Numpad.N4, Numpad.N2, Numpad.N3, Numpad.N6], [Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N6], [Numpad.N4, Numpad.N1, Numpad.N3, Numpad.N6],
					[Numpad.N9, Numpad.N4, Numpad.N2, Numpad.N3, Numpad.N6], [Numpad.N9, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N6], [Numpad.N9, Numpad.N4, Numpad.N1, Numpad.N3, Numpad.N6]],
	"M22" : [20, [Numpad.N2, Numpad.N5, Numpad.N2, Numpad.N5], [Numpad.N5, Numpad.N2, Numpad.N5, Numpad.N2, Numpad.N5]],
	"M632146" : [60, [Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N3, Numpad.N6], 
						[Numpad.N9, Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N3, Numpad.N6],
						[Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N2, Numpad.N3, Numpad.N6], 
						[Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N6], 
						[Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N3, Numpad.N6],
						[Numpad.N9, Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N2, Numpad.N3, Numpad.N6], 
						[Numpad.N9, Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N6], 
						[Numpad.N9, Numpad.N6, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N3, Numpad.N6]],
	"M236236" : [60, [Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N5, Numpad.N6, Numpad.N3, Numpad.N2], 
					[Numpad.N5, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N5, Numpad.N6, Numpad.N3, Numpad.N2],
					[Numpad.N9, Numpad.N6, Numpad.N3, Numpad.N2, Numpad.N5, Numpad.N6, Numpad.N3, Numpad.N2]],
	"M214214" : [60, [Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2], 
					[Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2],
					[Numpad.N7, Numpad.N4, Numpad.N1, Numpad.N2, Numpad.N5, Numpad.N4, Numpad.N1, Numpad.N2]],
	"superJump" : [15, InputFlags.UP, 0, InputFlags.DOWN, 0],
	"superJumpShortCut" : [12, InputFlags.UP, InputFlags.DOWN, 0],
}

const UniversalMoveList: Array = [
	["Basic Controls"],
	["Movement"],
	["j6A+B or j4A+B", "AirDash", "", "Can double jump after"],
	["Offense"],
	["5D (Air OK)", "Assist1", "", "", ""],
	["2D (Air OK)", "Assist2", "", "", ""],
	["Multiple assist calls", "Assist Chain", "", "Assist character cancels into any assist attack"],
	["236D (Air OK)", "AssistSuper", "1 meter + 2 assist stock", ""],
	["A+D", "Throw / Air Throw", "", ""],
	["A+B+C", "Raibu Cancel", "1 super bar", ""],
	["Defense"],
	["Hold any button during opponent's air combo", "Air Recovery", "", ""],
	["4[B+C] Hold", "Funny Defense", "", "pushes back attackers more"],
	["A+B+C+D", "Burst", "1 meter + 2 assist stock, burst super meter cost increases after use", ""],
	["(Check HH mechanics writeup for more detail and hidden mechanics)", "", "", ""],
]

const SubaruMoveList: = [
	["Oozora Subaru"],
	["Command Normals"],
	["3C", "Launcher", "", "Universal launcher"],
	["6A", "Anti Air", "", "Upper body invul"],
	["6C", "Clean Hit Swing", "", "Clean hit at mid range"],
	["j6C", "Super Clean Hit Swing", "", "Even cleaner hit at mid range"],
	["j2C", "BreadLoops", "", "Teyah! Combo tool and corner carry"],
	["Specials"],
	["236A (Air OK)", "Star Ball", "", "Hit projectile with strikes to change trajectory"],
	["236B (Air OK)", "Pleiades Star Ball", "", "Hit projectile with strikes to enhance projectile"],
	["236B > Any special (except fireballs)", "", "follow up rekka to hit projectile"],
	["214A (Air OK)", "Batter Swing", "", ""],
	["214B (Air OK)", "Steal Home", "", "Low profile"],
	["623A or 623B (Air OK)", "Duck Punch", "", "Full invul reversal"],
	["Supers"],
	["236C (Air OK)", "Hollow Limit : Pleiades Star Barrage", "Level 1", ""],
	["632146C", "Hollow Limit : Shubonic Arm", "Level 2", "Full invul reversal"],
	["214214C", "Hollow Limit : Angel Install", "Level 5", "oh no"],
	["(Angel mode) 632146A", "Hollow Limit : Heaven Breaker", "", ""],
]

const MioMoveList: = [
	["Ookami Mio"],
	["Command Normals"],
	["3C", "Tower Force", "", "Universal launcher"],
	["6A", "Taiga!", "", "Upper body invul. Cat attack!"],
	["6C", "Chariot Pulse", "", "Whiffs on most crouchers"],
	["j2C", "Reverse Temperance Crash", "", "Instant overhead"],
	["Specials"],
	["236A or 236B or 236C", "HATO ON", "", "Summon Hatotaurus"],
	["236[A] or 236[B] or 236[C]", "Summon Concentration", "", "Build sync rate quickly when held"],
	["214A or 214B or 214C", "Unsummon", "", "Unsummons Hatotaurus"],
	["623A or 623B or 623C (Air OK)", "Card Toss", "", ""],
	["Supers"],
	["41236C", "Mio Cannon", "Level 1", "Ground bounces on normal hit"],
	["Hato Attacks"],
	["]A[", "Hato Hit", "", "Low profile"],
	["]B[", "Taurus Thunder", "", "full invul anti air"],
	["]C[", "Po Po Po!", "", "Multi hit punch rush"],
	["236]C[", "Card Knives", "Level 1", "Hato Super, cancels off of hato attacks, input in the direction Hatotaurus is facing"],
]

const OgaMoveList: = [
	["Aragami Oga"],
	["Unique Movement"],
	["Air dash:", "Triangle Jump", "", "Airdashs are angled down"],
	["Run", "", "", "Has become a step dash"],
	["Ground Backdash", "", "", "Not invul!"],
	["Command Normals"],
	["3C", "OH!-ga", "", "Universal launcher"],
	["6A", "Crouching heavy punch", "", "Upper body invul"],
	["6C", "Tuna Punch", "", "Combo tool, niche overhead"],
	["5C", "Hop kick", "", "Crossup overhead and low crush, double jump cancel OK, jumps on first frame"],
	["j2C", "Bootdive", "", "Overhead dive kick, double jump cancel OK"],
	["j8C", "Infinity Beam", "", "Combo tool, double jump cancel OK"],
	["Specials"],
	["236X", "Oga Spike", "", "B and C versions are jump cancel OK"],
	["623X", "Hero's Corridor", "", "B and C (EX) version are invul reversals"],
	["j236X", "Oga Rocket", "", "Rekka series"],
	["j214X", "Raging Twister Strike", "", "Alters Oga's air movement"],
	["Supers"],
	["63214C", "Slap back", "Level 1", "Unfortunately does not force out the opponent's assist"],
	["623C", "EX Hero's Corridor", "Level 1", "invul reversal"],
	["632146C", "Demon Scythe: Slash Mode", "Level 2", "Long distance invul reversal"],
]

const OllieMoveList: = [
	["Kureiji Ollie"],
	["Unique Movement"],
	["Run", "", "", "Starts with a back sway"],
	["Hold 2", "Low profile", "", "A super low crouch, blocking is still OK"],
	["Command Normals"],
	["Missing moves", "WARNING", "", "No close B"],
	["Ground Throws", "", "", "Throw hits at mid range"],
	["3C", "Smollie Kiiiick!", "", "Universal launcher, close range dead zone"],
	["6A", "Head Dango", "", "long range anti air"],
	["6[C]", "Twintail Drill", "", "guard crusher"],
	["6C", "Clay shooter", "", "Clean Hit at long range"],
	["j2C", "Flying Drill Crash", "", "Halts air momentum on the first frame"],
	["jump Normals", "", "", "Many jump normals have reverse gatlings / rebeats"],
	["anti-air Normals", "", "", "Some anti air normals have reverse gatlings / rebeats"],
	["Specials"],
	["214X (Air OK)", "Udin Formation", "", "Summons chess pieces, can hold the button"],
	["214[X] (Ground Only)", "Pop Pop Udin Formation", "", "Summons enhanced chess pieces, can be held with negative edge"],
	["]A[", "Rook", "", "Release A for horizontal space control"],
	["]B[", "Bishop", "", "Release B for diagonal space control"],
	["]C[", "Pegasus", "", "Release C for ...knight shaped? space control"],
	["Supers"],
	["236B", "Smollie Queen", "Level 1", "Hold D to hold smollie in place"],
	["236B > ]D[", "Smollie, hold down the neutral", "", "Steer smollie with 4 and 6 inputs"],
	["236C", "Bzzt Boom!", "Level 2", "Here's my Jollie's best!"],
]

const KanataMoveList: = [
	["Amane Kanata"],
	["Unique Movement"],
	["Air dash:", "Assault", "", "Airdashes are air hops"],
	["Run:", "Step dash", "", "Run is a short step dash"],
	["Backdash:", "", "", "Backdash is abnormally invul"],
	["Superjump:", "", "", "Can be slightly steered in 4 directions"],
	["Command Normals"],
	["3C", "Ginger Crusher", "", "Universal launcher"],
	["6A", "99 strength", "", "anti air"],
	["5C", "Tenshi Smash", "", "Groundbounces on normal hit"],
	["6C", "Papakin's Son", "", "Cancels into itself"],
	["j2C", "Tenshi Body Splash", "", "Crossups for days"],
	["j5C", "Gorilla Dunk", "", "Steerable left and right, Groundbounces on normal hit"],
	["j6C", "The Great Grappler's Duster Kick", "", "Floaty gravity. Wallbounces on normal hit"],
	["jump Normals", "", "", "Only jA hits high, all other jump normals hit mid"],
	["Specials"],
	["63214A (Air OK)", "50KG Grip Strength", "", "Kanata's signature command grab, steerable left and right"],
	["63214[A] (Air OK)", "25KG Grip Strength", "", "Alternate version that only launches opponent"],
	["22X (Air OK)", "Dodge Roll", "", ""],
	["236X (Air OK)", "Wing Stance", "", "Enter stance with followups"],
	["236X > A (Air OK)", "Wing Shield", "", ""],
	["236X > A > A (Air OK)", "Moon Jump", "", "Steerable in 4 directions"],
	["236X > B (Air OK)", "Wing Tackle", "", "Enter stance with followups"],
	["236X > C (Air OK)", "Tokusha-seizon Wandarada-!!", "Level 1", "Fight on, Kanata! Metered command run followup."],
	["236X > D (Air OK)", "Wing Stance Exit", "", "Time to get fancy!"],
	["Supers"],
	["214B (Air Only)", "Chaos Soul Wing", "Level 2", "Ground bounces multiple times on normal hit"],
	["63214C", "Other-Worldly 50KG Grip Strength", "Level 3", "Blazing fast invincible command grab, steerable left and right"],
]

const SuiseiMoveList: = [
	["Hoshimachi Suisei"],
	["Unique Movement"],
	["Air dash:", "", "", "Has 2 airdashes"],
	["Run:", "", "", "Run is slow to start up"],
	["Backdash:", "", "", "Backdash is abnormally invul"],
	["Command Normals"],
	["C Buttons", "Bibbidi", "", "Heavy attacks are replaced with stance switch"],
	["6A", "", "", "two hitting upper body invul attack"],
	["j6B", "", "", ""],
	["Specials"],
	["236B or A (Air OK)", "Caramel Thrust", "", "Stance cancel on hit"],
	["214B or A (Air OK)", "Yoru wo Matsuyo", "", "Rekka special, follow ups can whiff cancel"],
	["214B->A (Air OK)", "", "", "Launcher"],
	["214B->B (Air OK)", "", "", "Multi hit"],
	["214B->2B (Air OK)", "", "", "Steerable ender"],
	["Rekka->C", "", "", "Stance cancel on whiff and hit"],
	["Supers"],
	["", "None", "", ""],
	["", "", "", ""],
	["Suicopath Mode"],
	["Unique Movement"],
	["Air dash:", "", "", "No airdashes"],
	["Run:", "", "", "No run"],
	["Backdash:", "", "", "Dodges in place"],
	["Jump", "", "", "Suicopath cannot jump"],
	["Unique Movement"],
	["Air Recovery", "", "", "Suicopath cannot air tech"],
	["Command Normals"],
	["C Buttons", "Bobbidi", "", "Heavy attacks are replaced with stance switch"],
	["6A", "", "", "Steerable multi hitting anti air"],
	["j2B", "Four Lines Crash", "", "Steerable left and right"],
	["Specials"],
	["Supers"],
	["Note:", "", "", "Suicopath cannot build super meter"],
	["63214A", "Kyou mo Hasami", "Level 1", "Invul advancing launcher"],
	["632146B", "Next Color Chainsaw", "Level 2", "lockdown projectile"],
]

const FlayonMoveList: = [
	["Machina X Flayon"],
	["Unique Movement"],
	["Backdash", "", "", "Backflips and recovers midair"],
	["Unique Normals"],
	["6A", "Missing", "", ""],
	["cB", "Missing", "", ""],
	["Reverse Chains", "", "", "Can cancel any normal into any different normal"],
	["Air Throw Cancel", "", "", "Can cancel air normals into air throw"],
	["Jump Cancels", "", "", "Only A normals are jump cancel OK"],
	["Command Normals"],
	["No reverse chains on command normals", "", "", ""],
	["3C", "", "", "Universal launcher, Jump cancel OK"],
	["6C", "", "", ""],
	["j2C", "Pizza Cutter", "", "Multi hit crossup"],
	["j6C", "", "", ""],
	["Specials"],
	["236A or B (Air OK)", "Grappler's Soul", "", "Command Grab, cancel into normals or jump on hit"],
	["623A or B (Air OK)", "Ryuken-shiki", "", "DP, delay cancels into air throw"],
	["Flight"],
	["214X (Air OK)", "Flight", "", "Spend super meter to fly"],
	["Airdash cancel", "", "", "Cancel Flight normals into 4 way airdash"],
	["Reverse Chains", "", "", "Flight Normals are reverse chain OK"],
	["Increase Moves", "", "", "Some Flight Normals can be held to enhance them"],
	["Flight > 214X", "Flight Exit", "", ""],
	["Supers"],
	["j236C (Air Only)", "", "Level 2", "Hits before superflash"],
	["236C", "Deus EX Machina", "Level 2", "Invincible Super"],
]

const FubukiMoveList: = [
	["Assist: Shirakami Fubuki"],
	["Attacks"],
	["5D", "Akai na...", "", "Dashing rapid slash, low profile"],
	["2D", "Kurokami Flip", "", "Invul reversal, ground bounces on second hit"],
	["236D", "Hi Friend!", "Level 1 and 2 assist stocks", "Full invul"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", "Fubuki=the=Kon!-edge"],
]

const SoraMoveList: = [
	["Assist: Tokino Sora"],
	["Attacks"],
	["5D", "Nun-Nun Step", "", "Wallbounces on normal hit"],
	["2D", "Nun-Nun Fence", "", "Invul reversal, Groundbounces on normal hit."],
	["236D", "Colossal Piano", "Level 1 and 2 assist stocks", ""],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const OkakoroMoveList: = [
	["Assist: Nekomata Okayu and Inugami Korone"],
	["Attacks"],
	["5D", "Koro Hammer", "", "Hold back to charge, release at just timing for an enhanced attack"],
	["2D", "Ogayu Advance!", "", "Hold down to charge, release at just timing for an enhanced attack"],
	["236D", "Super jump challenge", "Level 1 and 2 assist stocks", "Release A, B, or C to bounce on the opponent"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const SanaMoveList: = [
	["Assist: Tsukumo Sana"],
	["Attacks"],
	["5[D]", "Sanallite", "", "Hold D. Pulls in your point character towards Sana"],
	["2[D]", "The Tsukumo System", "", "Hold D and steer Sana left or right"],
	["236[D]", "Astrogirl", "Level 1 and 2 assist stocks", "Hold D and steer Sana in all 4 directions"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", "Hold D to pull yourself away from block pressure"],
]

const HakkaMoveList: = [
	["Assist: Banzoin Hakka"],
	["Attacks"],
	["5D", "Exorcist Tags", "", "Multi hit projectile"],
	["2D", "Shattered Wings", "", "Anti air and command jump"],
	["236[D]", "Metal Scream Galaxy", "Level 1 and 2 assist stocks", "Hold and release D for 3 different levels of charge"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const AssistSubaruMoveList: = [
	["Assist: Oozora Subaru"],
	["Attacks"],
	["5D", "Star Ball Toss", "", "2 hit projectile. Hitting star ball enhances projectile"],
	["2D", "Fly Ball", "", "Anti Air. Try hitting a 5D fireball with this"],
	["j2D", "Ground Ball", "", "Air Knockdown. Try hitting a 5D fireball with this"],
	["236D", "Hollow Limit: Star Ball Beam", "Level 1 and 2 assist stocks", "Subaru fires off 4 star balls. Hitting star ball changes trajectory"],
	["[D]", "Bases Loaded", "", "Hold D. Keep Subaru on field"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const AssistMioMoveList: = [
	["Assist: Ookami Mio"],
	["Attacks"],
	["5D", "Summon", "", "Summons Mio"],
	["2D", "Unsummon", "", "Unsummons Mio"],
	["]A[", "Dash", "", ""],
	["]B[", "Cut", "", ""],
	["]C[", "Launch", "", ""],
	["236D", "Card Teleport", "Level 1 and 2 assist stocks", "Mio teleports a fixed distance forwards"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const AssistOgaMoveList: = [
	["Assist: Aragami Oga"],
	["Attacks"],
	["5D", "Light Punch", "", "Guard: High"],
	["2D", "High Jump", "", ""],
	["jD", "DiveKick", "", "Guard: Mid"],
	["j2D", "Fast Fall", "", ""],
	["236[D]", "Tuna Punch", "Level 1 and 2 assist stocks", "Release D to do an overhead punch. (Air version hits mid)"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const AssistOllieMoveList: = [
	["Assist: Kureiji Ollie"],
	["Attacks"],
	["5D", "Head Dango", "", ""],
	["2D", "Idol's hair pin", "", ""],
	["236[D]", "Bzzt Boom Replica", "Level 1 and 2 assist stocks", ""],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const AssistKanataMoveList: = [
	["Assist: Amane Kanata"],
	["Attacks"],
	["5D", "Fifty KG Grip Strength", "", ""],
	["2D", "", "", ""],
	["236[D]", "Super Ginger Crusher", "Level 1 and 2 assist stocks", ""],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]

const AssistSuiseiMoveList: = [
	["Assist: Hoshimachi Suisei"],
	["Attacks"],
	["5D", "Caramel Thrust", "", ""],
	["jD", "", "", ""],
	["2D", "Bibbidi", "", "Change to Suicopath Mode"],
	["236[D]", "", "Level 1 and 2 assist stocks", "Change to Suicopath Mode"],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
	["Suicopath Mode"],
	["5D", "", "", ""],
	["jD", "Four Lines Crash", "", ""],
	["2D", "Bobbidi", "", "Change to Suisei Mode"],
	["236[D]", "Kyou mo Hasami", "Level 1 and 2 assist stocks", ""],
	["j236[D]", "Stellar Stellar", "Level 1 and 2 assist stocks", ""],
	["6D Guard Cancel", "", "Level 1 and 2 assist stocks", ""],
]
