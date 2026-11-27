extends Control

class_name FrameBarRow

const COLUMNS := 120
const CELL_HEIGHT := 20.0
const BORDER_COLOR := Color(0.06, 0.08, 0.1, 1)
const EMPTY_COLOR := Color("3d4754ff")
const INVINCIBILITY_TEXTURE = preload(
	"res://game/assets/sprites/UI/WIN/Timeline 1_0000.png"
)
const FRAME_TYPE_COLORS := {
	FrameEvent.EventType.STARTUP: Color("00b83d"),
	FrameEvent.EventType.ACTIVE: Color("c63567"),
	FrameEvent.EventType.RECOVERY: Color("186eb8"),
	FrameEvent.EventType.HITSTUN: Color("fcdf5b"),
	FrameEvent.EventType.BLOCKSTUN: Color("4ecaf1"),
	FrameEvent.EventType.FIRST_ACTIVE: Color("ff8b00"),
}

var frame_types := PackedInt32Array()
var invincible := PackedByteArray()

func _init() -> void:
	frame_types.resize(COLUMNS)
	frame_types.fill(-1)
	invincible.resize(COLUMNS)
	invincible.fill(0)

func get_cell_width() -> float:
	return size.x / COLUMNS

func set_cell(column: int, frame_type: int, is_invincible: bool) -> void:
	frame_types[column] = frame_type
	invincible[column] = 1 if is_invincible else 0

func _draw() -> void:
	var cell_width := get_cell_width()
	var top := maxf(size.y - CELL_HEIGHT, 0.0)
	for column in range(COLUMNS):
		var cell_rect := Rect2(column * cell_width, top, cell_width, CELL_HEIGHT)
		var inner_rect := cell_rect.grow(-1.0)
		draw_rect(cell_rect, BORDER_COLOR)
		draw_rect(inner_rect, FRAME_TYPE_COLORS.get(frame_types[column], EMPTY_COLOR))
		if invincible[column] != 0:
			draw_texture_rect(INVINCIBILITY_TEXTURE, inner_rect, false)

func _notification(notif: int) -> void:
	if notif == NOTIFICATION_RESIZED:
		queue_redraw()
