extends RigidBody2D

### Whether or not the player is currently dragging this bullet.
var is_dragging: bool = false;

### How quickly the object snaps to the mouse.
var spring_strength := 140.0
### How quickly the object "settles down", so to speak.
var damping := 16.0

### The offset on which the object was grabbed, when grabbed initially.
var grab_offset := Vector2.ZERO  # set on pickup, in local space

signal left_screen;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(func(): left_screen.emit());

func _physics_process(_delta):
	if is_dragging:
		var grab_world = global_position + grab_offset.rotated(rotation)
		var to_target = get_global_mouse_position() - grab_world
		var force = to_target * spring_strength - linear_velocity * damping
		apply_force(force * mass, grab_offset.rotated(rotation))
		angular_velocity *= 0.95  # angular damping so it settles


func _input_event(_viewport, event, _shape_idx) -> void:
	# If you're holding down the handle, set is dragging to true.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			grab_offset = (get_global_mouse_position() - global_position).rotated(-rotation)

func _input(event: InputEvent) -> void:
	# If you let go of the mouse ANYWHERE on the screen, stop dragging.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			is_dragging = false
