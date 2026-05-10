extends Microgame

## The area where the schnitzel needs to be brought to.
@export var bitedown_area: Area2D = null

## The schnitzel fork in question.
@export var schnitzel_fork: SchnitzelFork = null;

## The sprite for when the mouth is open
@export var open_mouth_sprite: Sprite2D = null;

## The sprite for when the mouth is closed
@export var closed_mouth_sprite: Sprite2D = null;

## Played on victory.
@export var victory_sfx: AudioStreamPlayer = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_mouth_sprite.visible = true;
	closed_mouth_sprite.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bitedown_area.overlaps_area(schnitzel_fork.food_area) and !player_won_at_microgame:
		schnitzel_fork.is_active = false;
		open_mouth_sprite.visible = false;
		closed_mouth_sprite.visible = true;
		
		set_player_won_at_microgame();
		
		victory_sfx.play(); 
