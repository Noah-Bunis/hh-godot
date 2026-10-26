extends Node2D
# from video: https://www.youtube.com/watch?v=aF9tqVOf8Rc

# Declare member variables here. Examples:
var col = 1
var row = 1

signal select_chara()
signal deselect_chara()
signal change_character(row, col)

@export var input_prefix: String
@export var is_p1: bool
@export var is_assist: bool
@export var portraitOffset: Vector2
@export var gridY: int
@export var gridX: int
@export var start_col: int
@export var start_row: int
@export var deselect_ok: bool
@export var selectable_cells: Array[Vector2i] = []

var frame_delay: int
var last_valid_position: Vector2
var last_valid_row: int
var last_valid_col: int

var selected: bool
var enabled: bool
var prev_input_is_N5: bool

var AUp: bool
var BUp: bool
var CUp: bool
var DUp: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	selected = false
	enabled = true
	prev_input_is_N5 = false
	col = start_col
	row = start_row
	if (col >= gridX):
		col = gridX - 1
	if (row >= gridY):
		row = gridY - 1
	last_valid_position = position
	last_valid_row = row
	last_valid_col = col
	play_idle_anim()
	AUp = true
	BUp = true
	CUp = true
	DUp = true
	frame_delay = 1
#	print(input_prefix)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if (enabled and not selected):
		if (frame_delay == 0):
			if (prev_input_is_N5):
				if (Util.is_left_pressed_prefix(input_prefix)):
					if (col > 0):
						col -= 1
						position.x -= portraitOffset.x
						cursor_move()
					prev_input_is_N5 = false
				elif (Util.is_up_pressed_prefix(input_prefix)):
					if (row > 0):
						row -= 1
						position.y -= portraitOffset.y
						cursor_move()
					prev_input_is_N5 = false
				elif (Util.is_right_pressed_prefix(input_prefix)):
					if (col < gridX - 1):
						col += 1
						position.x += portraitOffset.x
						cursor_move()
					prev_input_is_N5 = false
				elif (Util.is_down_pressed_prefix(input_prefix)):
					if (row < gridY - 1):
						row += 1
						position.y += portraitOffset.y
						cursor_move()
					prev_input_is_N5 = false
			if (not(
				Input.is_action_pressed(input_prefix+"down") or Input.is_action_pressed(input_prefix+"down_stick") or
				Input.is_action_pressed(input_prefix+"up") or Input.is_action_pressed(input_prefix+"up_stick") or
				Input.is_action_pressed(input_prefix+"left") or Input.is_action_pressed(input_prefix+"left_stick") or
				Input.is_action_pressed(input_prefix+"right") or Input.is_action_pressed(input_prefix+"right_stick")
			)):
				prev_input_is_N5 = true
				play_idle_anim()
			else:
				play_hold_anim()
			
			if (AUp and Input.is_action_just_pressed(input_prefix+"a")):
				AUp = false
				select()
			elif (BUp and Input.is_action_just_pressed(input_prefix+"b")):
				BUp = false
				select()
			elif (CUp and Input.is_action_just_pressed(input_prefix+"c")):
				CUp = false
				select()
			elif (DUp and Input.is_action_just_pressed(input_prefix+"d")):
				DUp = false
				select()
		else:
			frame_delay -= 1
	if (Input.is_action_just_released(input_prefix+"a")):
		AUp = true
	if (Input.is_action_just_released(input_prefix+"b")):
		BUp = true
	if (Input.is_action_just_released(input_prefix+"c")):
		CUp = true
	if (Input.is_action_just_released(input_prefix+"d")):
		DUp = true

func cursor_move():
	if (not selectable_cells.is_empty() and not selectable_cells.has(Vector2i(row, col))):
		position = last_valid_position
		row = last_valid_row
		col = last_valid_col
		return
	last_valid_position = position
	last_valid_row = row
	last_valid_col = col
	if (enabled):
		emit_signal("change_character", self.row, self.col)
		MainMenuMusicControl.play_cursor_move()

func select():
	frame_delay = 1
	if (enabled and (selectable_cells.is_empty() or Vector2i(row, col) in selectable_cells)):
		selected = true
		emit_signal("select_chara")
		MainMenuMusicControl.play_cursor_select()
		play_select_anim()

func deselect():
	frame_delay = 1
	if (enabled and deselect_ok):
		selected = false
		emit_signal("deselect_chara")
		MainMenuMusicControl.play_cursor_deselect()
		play_idle_anim()

func play_idle_anim():
	if (is_assist):
		if (is_p1):
			$AnimationPlayer.play("A1Idle")
		else:
			$AnimationPlayer.play("A2Idle")
	else:
		if (is_p1):
			$AnimationPlayer.play("P1Idle")
		else:
			$AnimationPlayer.play("P2Idle")

func play_hold_anim():
	if (not selected):
		if (is_assist):
			if (is_p1):
				$AnimationPlayer.play("A1Hold")
			else:
				$AnimationPlayer.play("A2Hold")
		else:
			if (is_p1):
				$AnimationPlayer.play("P1Hold")
			else:
				$AnimationPlayer.play("P2Hold")

func play_select_anim():
	if (is_assist):
		if (is_p1):
			$AnimationPlayer.play("A1Select")
		else:
			$AnimationPlayer.play("A2Select")
	else:
		if (is_p1):
			$AnimationPlayer.play("P1Select")
		else:
			$AnimationPlayer.play("P2Select")

func enable(yes: bool):
	frame_delay = 1
	enabled = yes
	if (yes):
		play_idle_anim()
	else:
		play_hold_anim()
