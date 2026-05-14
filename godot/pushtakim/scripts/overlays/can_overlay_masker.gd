extends Path2D

## The sprite that will be masked according to the path's progress.
@export var sprite_to_mask: Sprite2D = null;
@export var duration: float = 3.0
@onready var path_follow = $PathFollow2D

@export var debug_rect: TextureRect = null;

func _process(delta):
	path_follow.progress_ratio += (1.0 / duration) * delta
	sprite_to_mask.material.set_shader_parameter("progress", path_follow.progress_ratio)
	print(path_follow.progress_ratio)
func _ready():
	var tex_size_full = Vector2(sprite_to_mask.texture.get_size())
	var region: Rect2
	if sprite_to_mask.region_enabled:
		region = sprite_to_mask.region_rect
	else:
		region = Rect2(Vector2.ZERO, tex_size_full)

	var region_uv_offset = region.position / tex_size_full
	var region_uv_scale = region.size / tex_size_full

	sprite_to_mask.material.set_shader_parameter("region_uv_offset", region_uv_offset)
	sprite_to_mask.material.set_shader_parameter("region_uv_scale", region_uv_scale)

	var distance_tex = bake_distance_texture()
	sprite_to_mask.material.set_shader_parameter("distance_tex", distance_tex)
	debug_rect.texture = distance_tex


func bake_distance_texture() -> ImageTexture:
	var tex_size_full = Vector2(sprite_to_mask.texture.get_size())
	var region: Rect2
	if sprite_to_mask.region_enabled:
		region = sprite_to_mask.region_rect
	else:
		region = Rect2(Vector2.ZERO, tex_size_full)

	var scale_factor = 8
	var tex_size = Vector2i(region.size / scale_factor)
	var img = Image.create(tex_size.x, tex_size.y, false, Image.FORMAT_RF)
	var total = curve.get_baked_length()
	var origin_offset = region.size * 0.5 if sprite_to_mask.centered else Vector2.ZERO

	var t = sprite_to_mask.global_transform
	var sprite_scale = sprite_to_mask.scale

	var offsets = []
	for x in tex_size.x:
		for y in tex_size.y:
			var pixel = Vector2(x, y) * scale_factor
			var local_pos = (pixel - origin_offset) * sprite_scale
			var world_pos = Transform2D(t.get_rotation(), t.get_origin()) * local_pos
			var local_to_path = global_transform.inverse() * world_pos
			offsets.append(curve.get_closest_offset(local_to_path))

	var min_offset = offsets.min()
	var max_offset = offsets.max()
	var offset_range = max_offset - min_offset

	var i = 0
	for x in tex_size.x:
		for y in tex_size.y:
			var normalized = ((offsets[i] - min_offset) / offset_range)
			img.set_pixel(x, y, Color(normalized, 0.0, 0.0, 1.0))
			i += 1

	return ImageTexture.create_from_image(img)
