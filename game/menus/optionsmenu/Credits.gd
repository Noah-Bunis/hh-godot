extends Node2D

# Called when the node enters the scene tree for the first time.
@onready var CREDITS_FONT = preload("res://game/assets/CreditsFont.tres")

const credits = {
	"Netplay Code Libaries (Rollback, WebRTC, FixedPoint Physics, etc.)" : 
		["David Snopek"],
	"Debugging Help":
		["Snopek Games discord"],
	"Playtesters" : [
		"yoi",
		"wish",
		"leafer",
		],
	"Guest Composer" : [
		"miyaakka",
	],
	"Guest Developer" : [
		"Keyboard Noah",
	],
	"Infinite and Bug Hunters" : [
		"りてら",
		"J.Comet Bravo",
		"Shino",
		"Keyboard Noah",
		"jdes",
	],
	"Location test": [
		"Gabriel M.",
		"*Unknown OD DBFZ player*",
		"GCYoshi",
		"Phil",
		"asokii",
		"DirgeUndying",
		"Phen",
		"HoldBackToBark",
		"HakethKOTB",
		"AriaofScarlet",
		"LIKiMiNAJ",
		"Wosernerd",
		"QuantumAwesome",
		"LapPillow",
		],
	"Voice Talents":[
		"Ookami Mio",
		"Oozora Subaru",
		"Aragami Oga",
		"Kureiji Ollie",
		"Amane Kanata",
		"Shirakami Fubuki",
		"Tokino Sora",
		"Tsukumo Sana",
		"Nekomata Okayu",
		"Inugami Korone",
		"Banzoin Hakka",
		"Yukoku Roberu",
		],
	"Original Music By":
		[
		"THIS MU SUCKS - miyaakka",
		"Mogu Mogu Yummy - PinocchioP, Nekomata Okayu",
		"Saikyo Tensai Wonderland - Ogura Asuka, Inugami Korone",
		"Spiral Tones - Rikka and Calliope Mori",
		"Just Follow Stars - EFFY, Holostars talents",
		"Howling - TaWaRa, Ookami Mio",
		"Detabare Neko - Neko Hacker, Nekomata Okayu",
		"Graveyard Shift - The Herb Shop, Calliope Mori and BOOGEY VOXX",
		"Top of the World - Hikaru Sakurazawa, holoTEMPUS talents",
		"Yume Hanabi - HaTo, Nakiri Ayame",
		"Silent Night Requiem - Lin Haowei, Aragami Oga",
		"Heroine Audition - Sakai Takuya, Aki Rosenthal",
		"Chuuku no Niwa - bermei.inazawa, Amane Kanata",
		"W.I.M. - K's /Coro, Arurandeisu",
		"Homenobi - Watanabe Sho, Shirogane Noel",
		"Palette - niki, Tokoyami Towa",
		"Pleiades - Shunsuke Takizawa, Oozora Subaru",
		"Summer High Heels - Shuhei Tsubota, Oozora Subaru",
		"Violet, Meconopsis, Astrogirl - seibin, M2U, Ujico*/Snail's House, Ninomae Inanis",
		"Beginning - Harada Atsushi, Kageyama Shien",
		"Ghost - Atsuhito Sato, Hoshimachi Suisei",
		],
	"Special Thanks": [
		"Our family and friends",
		"the Hololive Production talents and staff",
		"Holofans, FG developers, and FG fans everywhere",
		],
	"-----------------" : [
		"Thank you so much for playing our game (demo)!",
		],
	"A Game By" : 
		["tMOE and qJOE"],
}

func load_section(credit_section, credit_list, container):
	var newLabel: Label
	var newText : String = credit_section
	newLabel = Label.new()
	newLabel.set("theme_override_fonts/font", CREDITS_FONT)
	newLabel.text = newText
	container.add_child(newLabel)
	for row in credit_list:
		newText = row
		newLabel = Label.new()
#		newLabel.add_font_override("custom_fonts/font", "res://game/assets/CreditsFont.tres")
		newLabel.set("theme_override_fonts/font", CREDITS_FONT)
		newLabel.text = newText
		newLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		container.add_child(newLabel)
	newText = ""
	newLabel = Label.new()
	newLabel.set("theme_override_fonts/font", CREDITS_FONT)
	newLabel.text = newText
	container.add_child(newLabel)

func _ready():
	for key in credits.keys():
		load_section(key, credits[key], $CanvasLayer/Credits)

func _physics_process(delta):
	$CanvasLayer/Credits.position.y -= 2

func _on_GoBackButton_pressed():
	get_tree().change_scene_to_file("res://game/menus/mainmenu/MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_GoBackButton_pressed()
