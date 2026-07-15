extends Microgame

@export
var clean_boot: Sprite2D = null;

@export
var dirty_boot: Sprite2D = null;

@export
var brush: Sprite2D = null;

@export
var total_movement_to_win: float = 5_000;

@onready
var brushing_sfx: AudioStreamPlayer = $Brush2;

var brush_movement_so_far: float = 0;

var previous_brush_location: Vector2 = Vector2(0,0);

var mouse_is_in_brushable_area: bool = false;

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
	
	# If the mouse isn't cleaning the boot - it's not cleaning anything.
	if !is_mouse_over_area():
		total_movement_this_delta = 0;
	
	brush_movement_so_far += total_movement_this_delta;
	# Update opacities
	var progress = get_progress_in_microgame()
	clean_boot.self_modulate.a = progress
	
	# If the user moved the brush enough do the funky noise. If not shut up.
	var minimal_movement = total_movement_this_delta > 0.3;
	if brushing_sfx.playing and !minimal_movement:
		brushing_sfx.stop()
	if !brushing_sfx.playing and minimal_movement:
		brushing_sfx.play();
	
	# Check if user wins 
	if brush_movement_so_far > total_movement_to_win:
		set_player_won_at_microgame();


func get_progress_in_microgame() -> float:
	return min(1, brush_movement_so_far/total_movement_to_win)


func is_mouse_over_area() -> bool:
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var results = get_world_2d().direct_space_state.intersect_point(params)
	for result in results:
		if result.collider == $BrushableArea:
			return true
	return false
