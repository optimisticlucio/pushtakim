extends Microgame

## The box in which ads will spawn.
@export
var ad_spawn_area: Control = null;

## The amount of ads created at the start of the minigame.
@export
var amount_of_created_ads: int = 4;

## The MoovitAd scene to be used to spawn more ads.
@export
var moovit_ad: PackedScene = null;

var amount_of_remaining_ads: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	amount_of_remaining_ads = amount_of_created_ads;
	
	for i in range(amount_of_created_ads):
		spawn_ad();

## Spawn a random ad within the ad spawn area. 
func spawn_ad() -> void:
	var new_ad: MoovitAd = moovit_ad.instantiate();
	ad_spawn_area.add_child(new_ad);
	
	new_ad.transform.origin = Vector2(randf_range(0, ad_spawn_area.size.x), randf_range(0, ad_spawn_area.size.y));
	new_ad.closed.connect(ad_was_destroyed);

## Called every time an ad is destroyed.
func ad_was_destroyed() -> void:
	amount_of_remaining_ads -= 1;
	
	if amount_of_remaining_ads == 0:
		set_player_won_at_microgame();
