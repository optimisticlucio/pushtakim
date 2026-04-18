extends Node2D

## The sprite layer of the krembo wrapping.
@export
var wrapping_layer: Sprite2D = null;

## The sprite layer of the krembo outer chocolate.
@export
var outer_chocolate_layer: Sprite2D = null;

## The sprite layer of the krembo inner chocolate. If missing, will end minigame after outer chocolate eaten.
@export
var inner_layer: Sprite2D = null;

## The radius of bites by users.
@export
var bite_radius: int = 10;


var mask_image_for_current_layer: Image = null;
var mask_texture_for_current_layer: ImageTexture = null;
var mask_node_for_current_layer: Sprite2D = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	verify_assumptions();
	
	create_mask_layer(wrapping_layer);

## Returns the amount of krembo that needs to be eaten in this layer.
func get_krembo_percentage_left() -> float:
	return 0.0; # TODO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Throws an error for every fundamental element of the minigame that isn't set.
func verify_assumptions() -> void:
	if wrapping_layer == null:
		push_error("[CONFIG ERROR] Krembo is missing `wrapping_layer`");

## Given a layer of krembo, creates a mask for it that is manipulated on click.
func create_mask_layer(krembo_layer: Sprite2D) -> void:
	var sprite_dimensions = krembo_layer.get_rect().size;
	mask_image_for_current_layer = Image.create(sprite_dimensions.x, sprite_dimensions.y, false, Image.FORMAT_RGBA8);
	
	# Set the image colors, based on which sprite pixels have alpha channels.
	var rect = krembo_layer.get_rect()
	rect.position += krembo_layer.texture.get_size() / 2
	var sprite_image = krembo_layer.texture.get_image().get_region(rect)
	for x in range(sprite_dimensions.x):
		for y in range(sprite_dimensions.y):
			var alpha_value = sprite_image.get_pixel(x, y).a;
			if alpha_value > 0:
				mask_image_for_current_layer.set_pixel(x, y, Color.WHITE);
			else:
				mask_image_for_current_layer.set_pixel(x, y, Color.BLACK);
	
	mask_texture_for_current_layer = ImageTexture.create_from_image(mask_image_for_current_layer);
	
	mask_node_for_current_layer = Sprite2D.new();
	mask_node_for_current_layer.texture = mask_texture_for_current_layer;
	mask_node_for_current_layer.clip_children = CanvasItem.CLIP_CHILDREN_ONLY;
	
	krembo_layer.get_parent().add_child(mask_node_for_current_layer);
	krembo_layer.reparent(mask_node_for_current_layer);


## Given an appropriate X and Y, creates a black circle in the texture image, with the X and Y being its center.
func add_black_circle_to_spritemask(x: int, y: int) -> void:
	pass # TODO
