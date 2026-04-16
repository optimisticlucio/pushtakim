class_name Microgame_MamadDoorHandle extends Area2D


## The max amount of degrees that the handle can be spun left from the initial position.
@export
var max_degrees_left: int = 100;

## The max amount of degrees that the handle can be spun right from its initial position.
@export 
var max_degrees_right: int = 10;

## The amount of degrees left that the handle needs to be spun for the minigame to be won.
## The player should not be able to go below these once the threshold is passed.
@export 
var victory_degrees_left: int = 85;

## The max speed at which the door handle tracks the player's movement.
@export
var handle_spin_speed: float = 20;

## Whether the player is actively dragging the door handle.
var is_dragging: bool = false;

## To make sure we don't fire it 200 times - true if we fired `door_was_locked` already.
var signal_was_fired: bool = false;


## This signal is triggered when the handle spins past `victory_degrees_left`.
signal door_was_locked;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging:
		spin_handle_towards_mouse(delta);
	
	if rotation_degrees > victory_degrees_left and !signal_was_fired:
		door_was_locked.emit();
		signal_was_fired = true;

## When ran, spins the handle towards the mouse's current position, acknowledging the max degrees and deltatime.
func spin_handle_towards_mouse(delta: float) -> void:
	var mouse_position = get_global_mouse_position();
	var local_mouse = to_local(mouse_position);
	
	var movement_modifier = 1 if local_mouse.x < 0 else -1
	
	var next_mouse_degrees = rotation_degrees;
	
	next_mouse_degrees += movement_modifier * delta * handle_spin_speed;
	
	if next_mouse_degrees > max_degrees_left:
		next_mouse_degrees = max_degrees_left;
	
	if next_mouse_degrees < -max_degrees_right:
		next_mouse_degrees = -max_degrees_right;
	
	if signal_was_fired && next_mouse_degrees < victory_degrees_left:
		next_mouse_degrees = victory_degrees_left;
	
	rotation_degrees = next_mouse_degrees;
