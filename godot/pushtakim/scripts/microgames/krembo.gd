extends Microgame

@export
var the_krembo: TheKremboInQuestion = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_krembo.krembo_eaten.connect(set_player_won_at_microgame);

func verify_assumptions() -> void:
	if the_krembo == null:
		push_error("[CONFIG ERROR] Krembo missing from krembo minigame!");
