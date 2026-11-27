extends Control

class_name FrameBarLabels

const FONT = preload("res://game/assets/monogram_extended.ttf")
const FONT_SIZE := 36
const LABEL_OFFSET := Vector2(2.0, -7.0)
const TEXT_COLOR := Color(0.93, 0.95, 1, 1)
const SHADOW_COLOR := Color(0, 0, 0, 1)

var rows: Array = []
var durations: Array = [{}, {}, {}, {}]

func _draw() -> void:
	var inverse_transform := get_global_transform().affine_inverse()
	var ascent := FONT.get_ascent(FONT_SIZE)
	for row_index in range(rows.size()):
		var row: FrameBarRow = rows[row_index]
		if not row.is_visible_in_tree():
			continue
		var cell_width := row.get_cell_width()
		var row_origin: Vector2 = inverse_transform * row.get_global_transform().origin
		for column in durations[row_index]:
			var cell_origin := row_origin + Vector2(column * cell_width, 0.0)
			var baseline := cell_origin + LABEL_OFFSET + Vector2(0.0, ascent)
			var text := str(durations[row_index][column])
			draw_string(
				FONT, baseline + Vector2(1.0, 1.0), text,
				HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, SHADOW_COLOR
			)
			draw_string(
				FONT, baseline, text,
				HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, TEXT_COLOR
			)
