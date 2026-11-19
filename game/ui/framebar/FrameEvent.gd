class_name FrameEvent
extends RefCounted

enum EventType {
    STARTUP,
    ACTIVE,
    RECOVERY,
    HITSTUN,
    BLOCKSTUN,
    INVINCIBILITY,
    PARRY_CATCH,
    STATE_CHANGE,
    PROPERTY_CHANGE,
}

var type: EventType
var start_frame: int
var duration: int
var source_name: String = ""
var previous_state_name: String = ""
var state_name: String = ""
var property_changes: Dictionary = {}

func _init(
    p_type: EventType,
    p_start_frame: int,
    p_duration: int,
):
    type = p_type
    start_frame = p_start_frame
    duration = p_duration