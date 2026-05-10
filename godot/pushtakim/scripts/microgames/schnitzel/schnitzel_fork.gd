class_name SchnitzelFork extends Area2D

## Where the food is, and what needs to be inserted into the relevant mouth.
@export var food_area: Area2D = null;

## Whether or not this object is actively being dragged.
var is_dragging = false;

## When set to false, stops moving.
var is_active = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging and is_active:
		global_position = get_global_mouse_position();


func _input_event(_viewport, event, _shape_idx) -> void:
	# If you're holding down the handle, set is dragging to true.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true

func _input(event: InputEvent) -> void:
	# If you let go of the mouse ANYWHERE on the screen, stop dragging.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			is_dragging = false
