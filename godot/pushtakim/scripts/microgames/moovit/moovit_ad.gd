class_name MoovitAd extends Node2D


## The list of possible ads to be shown when this is generated initially
## Assumed to be non-empty.
@export
var advertising_images: Array[Texture2D] = [];

## Triggered when the ad is closed by the user.
signal closed;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AdImage.texture = advertising_images.pick_random();
	$ExitButton.pressed.connect(close_ad);

## Closes the ad and frees it.
func close_ad() -> void:
	
	closed.emit();
	queue_free();
