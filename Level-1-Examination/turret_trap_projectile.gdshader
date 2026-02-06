shader_type canvas_item;
uniform sampler2D gradient;

float unary_sin(float f, float t, float p) {
	return (1.0 + sin(TAU * f * t + p)) / 2.0;
}

vec2 center_quantized_uv(vec2 base_uv, float pixel_size, sampler2D base_texture) {
	vec2 texture_size = vec2(textureSize(base_texture,0));
	vec2 pixel_coords = base_uv * texture_size;
	vec2 block_index = floor(pixel_coords / pixel_size);
	vec2 block_center = (block_index + 0.5) * pixel_size;
	return block_center / texture_size;
	//vec2 uv = (base_uv * texture_size);
	//uv = floor(uv / pixel_size) * pixel_size + pixel_size * 0.5 ;
	//uv = uv / texture_size;
	//return uv;
}

void fragment() {
	vec2 center = vec2(0.5);
	vec2 uv = center_quantized_uv(UV, 1.0, TEXTURE);
	float base_alpha = texture(TEXTURE, UV).a;
	vec4 gradient_color = texture(gradient, vec2(distance(center, uv) + unary_sin(2.0, TIME, -20.0 * distance(center, uv)), 0.0));
	COLOR = vec4(gradient_color.rgb, base_alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
