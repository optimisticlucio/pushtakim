class_name TheKremboInQuestion extends Node2D

## The sprite layer of the krembo wrapping.
@export
var wrapping_layer: Sprite2D = null;

## The sprite layer of the krembo outer chocolate.
@export
var outer_chocolate_layer: Sprite2D = null;

## The radius of bites by users.
@export
var bite_radius: int = 10;

## The unwrapping SFX node
@export
var unwrap_sfx_node: AudioStreamPlayer = null;

## The bite SFX node
@export
var bite_sfx_node: AudioStreamPlayer = null;

## The max percentage of pixels that we allow the player to not finish eating, as a number between 0 to 100;
## This is to help with cases where there's a phantom pixel uneaten.
@export
var uneaten_pixel_leniency_percentage: float = 5;

## The max amount of pixels that we allow the player to not finish eating.
var uneaten_pixel_leniency: int = 0;

var mask_image_for_current_layer: Image = null;
var mask_texture_for_current_layer: ImageTexture = null;
var current_layer: Sprite2D = null;
## The amount of white pixels left to eat in this image.
var white_pixels_to_fill_for_current_layer: int = 0;

## Triggers when the krembo has been fully eaten.
signal krembo_eaten;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	verify_assumptions();

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if mask_texture_for_current_layer == null:
			if wrapping_layer != null:
				# Unwrap the krembo
				wrapping_layer.free();
				unwrap_sfx_node.play();
				create_mask_layer(outer_chocolate_layer);
			return;
		# Eat the krembo
		if current_layer.get_rect().has_point(current_layer.to_local(event.global_position)):
			var local_pos = current_layer.to_local(event.global_position)
			var img_size = current_layer.get_rect().size
			var pixel_x = int(local_pos.x + img_size.x / 2)
			var pixel_y = int(local_pos.y + img_size.y / 2)
			
			add_black_circle_to_spritemask(pixel_x, pixel_y);
			if white_pixels_to_fill_for_current_layer <= uneaten_pixel_leniency:
				current_layer.free();
				mask_image_for_current_layer = null;
				mask_texture_for_current_layer = null;
				white_pixels_to_fill_for_current_layer = 0;
				
				krembo_eaten.emit();

## Throws an error for every fundamental element of the minigame that isn't set.
func verify_assumptions() -> void:
	if wrapping_layer == null:
		push_error("[CONFIG ERROR] Krembo is missing `wrapping_layer`");
	if outer_chocolate_layer == null:
		push_error("[CONFIG ERROR] Krembo is missing `outer_chocolate_layer`");
	if unwrap_sfx_node == null:
		push_error("[CONFIG ERROR] Krembo is missing `unwrap_sfx_node`");
	if bite_sfx_node == null:
		push_error("[CONFIG ERROR] Krembo is missing `bite_sfx_node`");
	

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
				white_pixels_to_fill_for_current_layer += 1;
				mask_image_for_current_layer.set_pixel(x, y, Color.WHITE);
			else:
				mask_image_for_current_layer.set_pixel(x, y, Color.BLACK);
	
	mask_texture_for_current_layer = ImageTexture.create_from_image(mask_image_for_current_layer);
	
	var shader_material = ShaderMaterial.new()
	var shader = Shader.new()
	shader.code = """
	shader_type canvas_item;

	uniform sampler2D mask_texture;
	uniform float hframes;
	uniform float vframes;
	uniform float frame;

	void fragment() {
	    vec4 col = texture(TEXTURE, UV);
	    
	    float frame_x = mod(frame, hframes) / hframes;
	    float frame_y = floor(frame / hframes) / vframes;
	    
	    // UV within just this frame (0 to 1)
	    vec2 frame_uv = vec2(
	        (UV.x - frame_x) * hframes,
	        (UV.y - frame_y) * vframes
	    );
	    
	    vec4 mask = texture(mask_texture, frame_uv);
	    col.a *= mask.r;
	    COLOR = col;
	}
	""";
	shader_material.shader = shader
	shader_material.set_shader_parameter("hframes", float(krembo_layer.hframes));
	shader_material.set_shader_parameter("vframes", float(krembo_layer.vframes));
	shader_material.set_shader_parameter("frame", float(krembo_layer.frame));
	shader_material.set_shader_parameter("mask_texture", mask_texture_for_current_layer)
	krembo_layer.material = shader_material
	
	uneaten_pixel_leniency = white_pixels_to_fill_for_current_layer * uneaten_pixel_leniency_percentage / 100;
	
	current_layer = krembo_layer;

## Given an appropriate X and Y, creates a black circle in the texture image, with the X and Y being its center.
func add_black_circle_to_spritemask(center_x: int, center_y: int) -> void:
	var white_pixels_before_bite = white_pixels_to_fill_for_current_layer;
	
	for y in range(center_y - bite_radius, center_y + bite_radius + 1):
		for x in range(center_x - bite_radius, center_x + bite_radius + 1):
			var dx = x - center_x;
			var dy = y - center_y;
			if dx * dx + dy * dy <= bite_radius * bite_radius:
				if x >= 0 and x < mask_image_for_current_layer.get_width() and y >= 0 and y < mask_image_for_current_layer.get_height():
					if mask_image_for_current_layer.get_pixel(x, y) != Color.BLACK:
						white_pixels_to_fill_for_current_layer -= 1;
						mask_image_for_current_layer.set_pixel(x, y, Color.BLACK);
	
	mask_texture_for_current_layer.update(mask_image_for_current_layer);
	current_layer.set_instance_shader_parameter("mask_texture", mask_texture_for_current_layer);
	print("BITE TAKEN! Remaining white pixels: %s" % white_pixels_to_fill_for_current_layer);
	if white_pixels_to_fill_for_current_layer != white_pixels_before_bite:
		bite_sfx_node.play();
