extends Microgame

@export
var total_movement_to_lose: float = 500;

var movement_so_far: float = 0;

var previous_mouse_location: Vector2 = Vector2(0,0);



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_mouse_location = get_local_mouse_position();
	
	$Holding.visible = true;
	$Fallen.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_mouse_location = get_local_mouse_position();
	var total_movement_this_delta = current_mouse_location.distance_to(previous_mouse_location);
	previous_mouse_location = current_mouse_location;
	
	movement_so_far += total_movement_this_delta;

	if !players_victory_status_was_set && movement_so_far > total_movement_to_lose:
		set_player_lost_at_microgame();
		$Fallen.visible = true;
		$Holding.visible = false;
		$Splat.play();
