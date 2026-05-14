@abstract class_name MicrogameOverlay extends Node2D
## A node representing the overlay that will be shown over a microgame, 
## giving players consistent information like whether they won or not and how much time they have left.
##
## If you make a new overlay, extend this, and implement the following methods:
## `on_player_win()` <- runs when the player completed the win condition of a microgame.
## `reset()` <- runs between microgames to reset everything that is moving in the window.
##
## If you reimplement `_process`, remember to call `super._process` at the start.

var time_left_in_microgame: float = 0;
var total_microgame_length: float = 0;

func set_variables(microgame_length: float) -> void:
	time_left_in_microgame = microgame_length;
	total_microgame_length = microgame_length;

## Returns a float between 0 to 1 representing what percent of the microgame is left.
func get_time_percent_left() -> float:
	return time_left_in_microgame / total_microgame_length;

## Function that's run when the parent game session says the player won.
@abstract func on_player_win() -> void;

## Function that's run when the parent game session says the player lost.
@abstract func on_player_loss() -> void;

## Function that should reset all moving parts of this overlay to zero, to be run between microgames.
@abstract func reset() -> void;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left_in_microgame = max(0, time_left_in_microgame - delta);
