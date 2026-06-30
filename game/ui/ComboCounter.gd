extends Node2D

class_name ComboCounter

@onready var anim = $NetworkAnimationPlayer
@onready var count_anim = $CounterAnimation

var COMBO_0 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0009.png")
var COMBO_1 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0008.png")
var COMBO_2 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0007.png")
var COMBO_3 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0006.png")
var COMBO_4 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0005.png")
var COMBO_5 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0004.png")
var COMBO_6 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0003.png")
var COMBO_7 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0002.png")
var COMBO_8 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0001.png")
var COMBO_9 = load("res://game/assets/sprites/UI/Meters/Combo/Timeline 1_0000.png")
var COMBO_EMPTY = load("res://game/assets/sprites/Empty_0000.png")

func _init():
	hide_counter()
#	invalid_hits = []

func _ready():
	change_color(Color("fcdf5b"))
	anim.play("Resting")

func count_up(damage: int, hitCount: int, invalid: bool, block: bool, guard:int) -> void:
	show_counter()
	display_text(hitCount)
	count_anim.stop()
	count_anim.play("CountHit")
	if (block):
		change_color(Color("4ecaf1"))
#		print ("Block.")
	else:
		change_color(Color("fcdf5b"))
#		print ("Valid")

	if (invalid and hitCount > 1):
		change_color(Color("912309"))
		anim.stop(true)
		anim.play("Invalid")
#		invalid_hits += hitCount
	
func drop_combo() -> void:
	hide_counter()
	change_color(Color("fcdf5b"))
	anim.play("Resting")

func hide_counter():
	self.visible = false

func show_counter():
	self.visible = true

func change_color(color):
	get_node("Counter").modulate = color

func reset_to_game_start():
	drop_combo()

func display_text(number):
	var digit_names = ["Digit1", "Digit2", "Digit3"]
	for name in digit_names:
		var digit = number % 10
		number /= 10
		get_node("Counter/"+name).texture = number_to_texture(digit, number)

func number_to_texture(digit, number) -> Texture:
	match digit:
		1:
			return COMBO_1
		2:
			return COMBO_2
		3:
			return COMBO_3
		4:
			return COMBO_4
		5:
			return COMBO_5
		6:
			return COMBO_6
		7:
			return COMBO_7
		8:
			return COMBO_8
		9:
			return COMBO_9
		_:
			if (int(number) <= 0):
				return COMBO_EMPTY
			else:
				return COMBO_0
