extends "res://game/menus/minigame/instructions/MinigameInstruction.gd"
class_name DealDamage


@export_range(1, 999999, 1) var required_damage: int = 100

var damage_dealt: int = 0
var _target_player: BasePlayer
var _on_success: Callable


func get_instruction() -> String:
	return "DEAL %d DAMAGE!" % required_damage


func get_progress_text() -> String:
	return "%d / %d DAMAGE" % [damage_dealt, required_damage]


func start(target_player: BasePlayer, on_success: Callable) -> void:
	stop()

	if target_player == null:
		push_error("DealDamage: Target player is null.")
		return
	if not on_success.is_valid():
		push_error("DealDamage: Success callback is invalid.")
		return

	damage_dealt = 0
	_target_player = target_player
	_on_success = on_success
	_target_player.strike_hurt.connect(_on_target_strike_hurt)
	progress_changed.emit(get_progress_text())


func stop() -> void:
	if (
		is_instance_valid(_target_player)
		and _target_player.strike_hurt.is_connected(_on_target_strike_hurt)
	):
		_target_player.strike_hurt.disconnect(_on_target_strike_hurt)

	_target_player = null
	_on_success = Callable()
	damage_dealt = 0


func _on_target_strike_hurt(
	damage: int,
	_hit_count: int,
	_invalid: bool,
	_block: bool,
	_guard: int
) -> void:
	if damage <= 0:
		return

	damage_dealt += damage
	progress_changed.emit(get_progress_text())
	if damage_dealt >= required_damage and _on_success.is_valid():
		_on_success.call()
