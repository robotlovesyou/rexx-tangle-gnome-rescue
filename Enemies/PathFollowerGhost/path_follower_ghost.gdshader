shader_type canvas_item;

uniform float alpha_base: hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float n_cycles: hint_range(0.0, 10.0, 0.1) = 1.25;
uniform float offset_scale = 0.01;

void fragment() {
	float offset = (1.0 + sin(2.0 * PI * TIME + 2.0 * PI * n_cycles * UV.x)) * 0.5;
	COLOR = texture(TEXTURE, vec2(UV.x, UV.y - offset * offset_scale));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
