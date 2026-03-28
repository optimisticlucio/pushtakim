class_name Microgame extends Node
## The top node of every microgame. 
## Interfaces with the main game handler by giving access to level-relevant data in a convenient way.
## Level metadata should be stored here as @export-ed variables.
##
## If you make a new microgame, extend this, and implement the following methods:
## player_won_at_microgame: Returns whether or not the player won, simple enough.

## The name/title of this microgame, mostly gonna be used in debugging.
@export
var microgame_name: String = "Level Name Missing";

## The length of this microgame, in seconds. It's a float incase you need 3.5 seconds for some reason.
@export
var length_in_seconds: float = 3.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_won_at_microgame() -> bool:
	push_error("Minigame `%s` did not implement `player_won_at_microgame` function." % microgame_name);
	return false;
