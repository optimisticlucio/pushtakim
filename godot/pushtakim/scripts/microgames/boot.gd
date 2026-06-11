extends Microgame

@export
var clean_boot: Sprite2D = null;

@export
var dirty_boot: Sprite2D = null;

@export
var brush: Sprite2D = null;

@export
var total_movement_to_win: float = 5_000;

@export
var brushing_sfx: AudioStreamPlayer = null;

var brush_movement_so_far: float = 0;

var previous_brush_location: Vector2 = Vector2(0,0);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_brush_location = brush.position;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update brush location to mouse.
	brush.transform.origin = get_local_mouse_position();
	
	# Update `brush_movement_so_far`
	var current_brush_location = brush.position;
	var total_movement_this_delta = current_brush_location.distance_to(previous_brush_location);
	previous_brush_location = current_brush_location;
	
	brush_movement_so_far += total_movement_this_delta;
	# Update opacities
	var progress = get_progress_in_microgame()
	clean_boot.self_modulate.a = progress
	
	# Check if user wins 
	if brush_movement_so_far > total_movement_to_win:
		set_player_won_at_microgame();


func get_progress_in_microgame() -> float:
	return min(1, brush_movement_so_far/total_movement_to_win)
