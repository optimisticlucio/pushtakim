@abstract class_name Microgame extends Node2D
## The top node of every microgame. 
## Interfaces with the main game handler by giving access to level-relevant data in a convenient way.
## Level metadata should be stored here as @export-ed variables.
##
## If you make a new microgame, extend this, and remember to do `super._process()` in your `_process`.

## The name/title of this microgame, mostly gonna be used in debugging.
@export
var microgame_name: String = "Level Name Missing";

## The act the user is told to perform before a minigame starts. In hebrew!
@export 
var hebrew_action_verb: String = "לשחק";

## The length of this microgame, in seconds. It's a float incase you need 3.5 seconds for some reason.
@export
var length_in_seconds: float = 3.0;

## If true, the player will win upon minigame timeout. If false, the player will lose upon minigame timeout.
@export
var player_wins_upon_timeout: bool = false;


## Whether or not player has won at the microgame.
## Should only be modified by `set_player_won_at_microgame()` and `set_player_lost_at_microgame()`.
var player_won_at_microgame: bool = false;

## Whether the player's victory state was explicitly set yet.
## If this is false, the value of `player_won_at_minigame` is not to be trusted.
## If this is true, do NOT re-set it.
var players_victory_status_was_set: bool = false;

## Signal that triggers when the player completes this microgame's win condition.
signal player_wins_at_microgame;

## Signal that triggers if the player irreversibly fails at the microgame.
signal player_loses_at_microgame;

## When run, sets the player winning or losing depending on what's the default for this microgame.
func set_default_victory_state() -> void:
	if player_wins_upon_timeout:
		set_player_won_at_microgame();
	else:
		set_player_lost_at_microgame();

## When run, declares the player the victor of the current microgame.
func set_player_won_at_microgame() -> void:
	# You shouldn't be running this twice. If the player won, they won. It's final.
	if players_victory_status_was_set:
		return;
	
	player_won_at_microgame = true;
	players_victory_status_was_set = true;
	on_player_victory();
	player_wins_at_microgame.emit();

## When run, declares the player has lost the microgame.
func set_player_lost_at_microgame() -> void:
	# You shouldn't be running this twice. If they lost, don't rub it in.
	if players_victory_status_was_set:
		return;
	
	player_won_at_microgame = false;
	players_victory_status_was_set = true;
	on_player_loss();
	player_loses_at_microgame.emit();

## Returns whether or not the player won at the microgame.
func player_has_won_at_microgame() -> bool:
	return player_won_at_microgame;

## Runs if the player wins.
func on_player_victory() -> void:
	pass

## Runs if the player loses
func on_player_loss() -> void:
	pass
