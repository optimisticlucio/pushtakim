class_name Tossable extends Sprite2D


## The maximal horizontal and vertical strength to throw initially. Assumed to be positive.
@export 
var throw_strength: Vector2 = Vector2(600, 600);

## how strong the tossable will spin on average. 1 is an entire spin per second.
@export
var spin_strength: float = 2;

## The pixels-per-second maximum speed for the fall.
@export
var terminal_velocity: float = 1000;

var speed: Vector2 = Vector2(0,0);

@export 
var acceleration: Vector2 = Vector2(0,1000);

var spin_speed: float = 20;

## When false, does not move.
@export
var being_thrown: bool = true;

var notifier: VisibleOnScreenNotifier2D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = Vector2(randf_range(-throw_strength.x, throw_strength.x), -randf_range(0, throw_strength.y));
	
	spin_speed = sin(randf_range(-spin_strength, spin_strength)) * 6;
	
	notifier = $VisibleOnScreenNotifier2D;
	notifier.rect = self.get_rect();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().process_frame;
	
	if !being_thrown:
		return;
	
	if !notifier.is_on_screen():
		self.queue_free();
	
	self.rotate(spin_speed * delta);
	
	self.speed += acceleration * delta;
	
	if self.speed.y > terminal_velocity:
		self.speed.y = terminal_velocity;
	
	self.transform.origin += speed * delta;
