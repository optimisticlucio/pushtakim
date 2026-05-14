extends MicrogameOverlay

@onready var can_masker: CanOverlayMasker = $Path2D;

@export var spark_sprite: Sprite2D = null;

var flame_burning: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta);
	
	if !flame_burning:
		return;
	
	var progress = 1 - get_time_percent_left();
	can_masker.set_progress(progress);

func on_player_win() -> void:
	extinguish_flame()

func on_player_loss() -> void:
	extinguish_flame()
	
func reset() -> void:
	can_masker.set_progress(0);
	$Path2D/PathFollow2D/Spark.visible = true;
	flame_burning = true;

func extinguish_flame() -> void:
	$Path2D/PathFollow2D/Spark.visible = false;
	flame_burning = false;
