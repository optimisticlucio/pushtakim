@abstract class_name Microgame extends Node2D
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

## Whether or not the player IRREVERSIBLY lost at the microgame. 
## This should only be used in microgames where the player needs some visible indication that they fucked up,
## rather than merely didn't complete the microgame yet.
## Should only be modified by `set_player_lost_at_microgame()`.
var player_lost_at_microgame: bool = false;

## Signal that triggers when the player completes this microgame's win condition.
signal player_wins_at_microgame;

## Signal that triggers if the player irreversibly fails at the microgame.
signal player_loses_at_microgame;

## When run, declares the player the victor of the current microgame.
func set_player_won_at_microgame() -> void:
	# You shouldn't be running this twice. If the player won, they won. It's final.
	if player_won_at_microgame || player_lost_at_microgame:
		return;
	
	player_won_at_microgame = true;
	player_wins_at_microgame.emit();

## When run, declares the player has lost the microgame.
func set_player_lost_at_microgame() -> void:
	# You shouldn't be running this twice. If they lost, don't rub it in.
	if player_won_at_microgame || player_lost_at_microgame:
		return;
	
	player_lost_at_microgame = true;
	player_loses_at_microgame.emit();

## Returns whether or not the player won at the microgame.
func player_has_won_at_microgame() -> bool:
	return player_won_at_microgame;
