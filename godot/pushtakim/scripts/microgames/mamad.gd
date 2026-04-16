extends Microgame

## The doorhandle the player needs to spin.
@export
var doorhandle: Microgame_MamadDoorHandle = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	validate_assumptions();
	
	doorhandle.door_was_locked.connect(set_player_won_at_microgame);

func validate_assumptions() -> void:
	if doorhandle == null:
		push_error("[CONFIG ERROR] Mamad microgame is missing a doorhandle!");
