shader_type canvas_item;
uniform vec4 highlight_color: source_color;
const float pixel_size = 1.0;

float unary_saw(float f, float t) {
	return fract(TAU * f * t);
}

float unary_tri(float t, float f, float skew) {
    float phase = fract(TAU * f * t);
    
    if (phase < skew) {
        // Rising edge: 0 to skew maps to 0 to 1
        return mix(0.0, 1.0, phase / skew);
    } else {
        // Falling edge: skew to 1.0 maps to 1 to 0
        return mix(1.0, 0.0, (phase - skew) / (1.0 - skew));
    }
}
void fragment() {
	vec2 texture_size = vec2(textureSize(TEXTURE,0));
	vec2 uv = UV * texture_size;
	uv = floor(uv / pixel_size) * pixel_size;
	uv = uv / texture_size;
	vec4 base_color = texture(TEXTURE, uv);
	vec2 reflection_point = vec2(UV.x, unary_tri(0.125, TIME, 0.1));
	COLOR = mix(base_color, base_color*base_color, distance(uv, reflection_point));
	//if (base_color == highlight_color) {
		////COLOR = vec4(1.0,0.0,0.0,1.0);
		//
	//} else {
		//COLOR = base_color;
	//}
}
