extends Microgame

@export 
var bullets_to_fill_in: Array[Node2D] = [];

@onready
var amount_of_bullets_to_fill_in: int = bullets_to_fill_in.size();

@onready
var magazine: BulletMagazine = $Magazine;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	magazine.bullet_inserted.connect(on_bullet_insertion)

func on_bullet_insertion() -> void:
	amount_of_bullets_to_fill_in -= 1;
	if amount_of_bullets_to_fill_in <= 0:
		set_player_won_at_microgame();
