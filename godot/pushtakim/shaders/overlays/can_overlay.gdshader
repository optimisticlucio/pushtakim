shader_type canvas_item;

uniform sampler2D distance_tex;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 region_uv_offset = vec2(0.0);
uniform vec2 region_uv_scale = vec2(1.0);

void fragment() {
	vec2 region_uv = (UV - region_uv_offset) / region_uv_scale;
	float dist = texture(distance_tex, region_uv).r;

	if (dist < progress) {
		discard;
	}

	COLOR = texture(TEXTURE, UV);
}