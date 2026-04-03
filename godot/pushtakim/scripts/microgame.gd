class_name Microgame extends Node2D
## The top node of every microgame. 
## Interfaces with the main game handler by giving access to level-relevant data in a convenient way.
## Level metadata should be stored here as @export-ed variables.
##
## If you make a new microgame, extend this, and implement the following methods:
## TODO

## The name/title of this microgame, mostly gonna be used in debugging.
@export
var microgame_name: String = "Level Name Missing";

## The length of this microgame, in seconds. It's a float incase you need 3.5 seconds for some reason.
@export
var length_in_seconds: float = 3.0;


## Whether or not player has won at the microgame. Should only be modified by `set_player_won_at_microgame()`.
var player_won_at_microgame: bool = false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## When run, declares the player the victor of the current microgame.
func set_player_won_at_microgame() -> void:
	# You shouldn't be running this twice. If the player won, they won. It's final.
	if player_won_at_microgame:
		return;
	
	player_won_at_microgame = true;
	# TODO: Have an event that announces the player won.

## Returns whether or not the player won at the microgame.
func player_has_won_at_microgame() -> bool:
	return player_won_at_microgame;
