extends Node2D

var fullround = preload("res://game/assets/sprites/UI/RoundCounterFull.png")
var emptyround = preload("res://game/assets/sprites/UI/RoundCounterEmpty.png")

var round_tracker: RoundTracker

@export var is_p1: bool

func setup_signal() -> void:
	round_tracker.rounds_updated.connect(self.updateUI)

func updateUI(p_is_p1: bool) -> void:
	if (self.is_p1 == p_is_p1):
		match round_tracker.read_rounds_won(self.is_p1):
			0:
				$Count0.texture = emptyround
				$Count1.texture = emptyround
			1:
				$Count0.texture = fullround
				$Count1.texture = emptyround
			2:
				$Count0.texture = fullround
				$Count1.texture = fullround
			_:
				print("Invalid round count")
