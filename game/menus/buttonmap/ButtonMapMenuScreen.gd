extends Node2D

signal complete()

@onready var BUTTON_MAP_MENU = preload("res://game/menus/buttonmap/ButtonMapMenu.tscn")
@onready var KEY_BUTTON_MAP_MENU = preload("res://game/menus/buttonmap/KeyboardButtonMapMenu.tscn")

var ButtonMap1: Node2D
var ButtonMap2: Node2D

var p1_ready: bool = false
var p2_ready: bool = false
var single_player_mode: bool = false
var single_player_is_p1: bool = true
var single_player_is_gamepad: bool = false
var audio_players: Array[AudioStreamPlayer] = []
var audio_player_process_modes: Array[int] = []

func configure_single_player(event: InputEvent, fallback_is_p1: bool) -> void:
	single_player_mode = true
	single_player_is_p1 = fallback_is_p1
	single_player_is_gamepad = event is InputEventJoypadButton or event is InputEventJoypadMotion

	if (single_player_is_gamepad):
		if (event.device == Global.p1_device_id):
			single_player_is_p1 = true
		elif (event.device == Global.p2_device_id):
			single_player_is_p1 = false
	elif (Global.p1_is_gamepad != Global.p2_is_gamepad):
		single_player_is_p1 = not Global.p1_is_gamepad

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	audio_players = [MainMenuMusicControl.audio_player, MainMenuMusicControl.menu_sounds]
	for audio_player in audio_players:
		audio_player_process_modes.append(audio_player.process_mode)
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	p1_ready = false
	p2_ready = false
	if (single_player_mode):
		p1_ready = not single_player_is_p1
		p2_ready = single_player_is_p1
		var player_menu: Node2D
		if (single_player_is_gamepad):
			player_menu = BUTTON_MAP_MENU.instantiate()
		else:
			player_menu = KEY_BUTTON_MAP_MENU.instantiate()
		add_child(player_menu)
		if (single_player_is_p1):
			ButtonMap1 = player_menu
			player_menu.position = Vector2(43, 92)
		else:
			ButtonMap2 = player_menu
			player_menu.position = Vector2(1243, 92)
		player_menu.set_is_p1(single_player_is_p1)
		player_menu.connect("button_set_complete", Callable(self, "button_set_complete"))
		return
	
	if (Global.p1_is_gamepad):
		ButtonMap1 = BUTTON_MAP_MENU.instantiate()
	else:
		ButtonMap1 = KEY_BUTTON_MAP_MENU.instantiate()
	
	if (Global.p2_is_gamepad):
		ButtonMap2 = BUTTON_MAP_MENU.instantiate()
	else:
		ButtonMap2 = KEY_BUTTON_MAP_MENU.instantiate()
	
	add_child(ButtonMap1)
	add_child(ButtonMap2)
	
	ButtonMap1.position.x = 43
	ButtonMap1.position.y = 92
	
	ButtonMap2.position.x = 1243
	ButtonMap2.position.y = 92
	
	
	ButtonMap1.set_is_p1(true)
	ButtonMap2.set_is_p1(false)
	ButtonMap1.connect("button_set_complete", Callable(self, "button_set_complete"))
	ButtonMap2.connect("button_set_complete", Callable(self, "button_set_complete"))

func remove_player(is_p1: bool):
	if (is_p1 and not p1_ready):
		ButtonMap1.free_button_menu()
		ButtonMap1 = null
		p1_ready = true
	elif (not is_p1 and not p2_ready):
		ButtonMap2.free_button_menu()
		ButtonMap2 = null
		p2_ready = true

func button_set_complete(is_p1:bool):
	if (is_p1):
		p1_ready = true
	else:
		p2_ready = true
	if p1_ready and p2_ready:
		exit()

func exit():
	emit_signal("complete")
	for index in range(audio_players.size()):
		if is_instance_valid(audio_players[index]):
			audio_players[index].process_mode = audio_player_process_modes[index]

func free_button_map():
	if (ButtonMap1 != null):
		ButtonMap1.queue_free()
		ButtonMap1 = null
	if (ButtonMap2 != null):
		ButtonMap2.queue_free()
		ButtonMap2 = null
	super.queue_free()

func _input(event):
	if (not single_player_mode and (event.is_action_pressed("player1_start") or event.is_action_pressed("player2_start"))):
		exit()
