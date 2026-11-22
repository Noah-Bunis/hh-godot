extends Control

class_name FrameBarCell

@onready var _base_color: ColorRect = $BaseColor
@onready var _invincibility_texture: TextureRect = $InvincibilityTexture
@onready var _duration_label: Label = $DurationLabel

func set_frame_type(event_type: int) -> void:
	match event_type:
		FrameEvent.EventType.STARTUP:
			_base_color.color = Color("00b83d")
		FrameEvent.EventType.ACTIVE:
			_base_color.color = Color("c63567")
		FrameEvent.EventType.RECOVERY:
			_base_color.color = Color("186eb8")
		FrameEvent.EventType.HITSTUN:
			_base_color.color = Color("fcdf5b")
		FrameEvent.EventType.BLOCKSTUN:
			_base_color.color = Color("4ecaf1")
		FrameEvent.EventType.FIRST_ACTIVE:
			_base_color.color = Color("ff8b00")
		_:
			_base_color.color = Color("3d4754ff")

func set_invincible(is_invincible: bool) -> void:
	_invincibility_texture.visible = is_invincible

func set_duration_label(duration: int) -> void:
	_duration_label.text = str(duration)
	_duration_label.visible = true

func clear_duration_label() -> void:
	_duration_label.text = ""
	_duration_label.visible = false

func set_duration_label_position(position: Vector2) -> void:
	_duration_label.position = position + Vector2(0.0, -9.0)
