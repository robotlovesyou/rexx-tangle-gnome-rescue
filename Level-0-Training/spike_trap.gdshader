shader_type canvas_item;
uniform vec4 highlight_color: source_color;
const float pixel_size = 1.0;
float unary_saw(float f, float t) {
	return fract(TAU * f * t);
}
void fragment() {
	vec2 texture_size = vec2(textureSize(TEXTURE,0));
	vec2 uv = UV * texture_size;
	uv = floor(uv / pixel_size) * pixel_size;
	uv = uv / texture_size;
	vec4 base_color = texture(TEXTURE, uv);
	vec2 reflection_point = vec2(UV.x, unary_saw(0.125, TIME));
	COLOR = mix(base_color, base_color*base_color, distance(uv, reflection_point));
	//if (base_color == highlight_color) {
		////COLOR = vec4(1.0,0.0,0.0,1.0);
		//
	//} else {
		//COLOR = base_color;
	//}
}
