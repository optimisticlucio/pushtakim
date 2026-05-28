extends MicrogameOverlay

@onready var can_masker: CanOverlayMasker = $Path2D;

@export var spark_sprite: Sprite2D = null;

var flame_burning: bool = true;

@export var success_sprite: Sprite2D = null;
@export var fail_sprite: Sprite2D = null;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta);
	
	if !flame_burning:
		return;
	
	var progress = 1 - get_time_percent_left();
	can_masker.set_progress(progress);

func on_player_win() -> void:
	extinguish_flame()
	success_sprite.visible = true;

func on_player_loss() -> void:
	extinguish_flame()
	fail_sprite.visible = true;
	
func reset() -> void:
	can_masker.set_progress(0);
	$Path2D/PathFollow2D/Spark.visible = true;
	flame_burning = true;
	success_sprite.visible = false;
	fail_sprite.visible = false;

func extinguish_flame() -> void:
	$Path2D/PathFollow2D/Spark.visible = false;
	flame_burning = false;
