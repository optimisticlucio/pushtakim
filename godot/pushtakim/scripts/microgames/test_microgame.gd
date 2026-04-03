extends Microgame


var time_passed_since_initialization: float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_won_at_microgame();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed_since_initialization += delta;
	
	if time_passed_since_initialization > 1:
		set_player_won_at_microgame()
