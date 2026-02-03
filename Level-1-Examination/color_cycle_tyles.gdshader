shader_type canvas_item;

group_uniforms BaseColors;
uniform vec4 hi_color: source_color;
uniform vec4 mid_color: source_color;
uniform vec4 low_color: source_color;
group_uniforms Gradients;
uniform sampler2D hi_gradient;
uniform sampler2D mid_gradient;
uniform sampler2D low_gradient;
group_uniforms Cycling;
uniform float base_frequency = 1.0;
uniform float envelope_value: hint_range(0.0, 1.0) = 0.0;
uniform float balance: hint_range(0.0, 1.0, 0.1);


void fragment() {
	float s = (1.0 + sin(TIME * PI * base_frequency)) / 2.0;
	float offset = balance * s + (1.0 - balance) * envelope_value;
	vec4 base_color = texture(TEXTURE, UV);
	if (base_color == hi_color) {
		COLOR = texture(hi_gradient, vec2(offset));
	} else if (base_color == mid_color) {
		COLOR = texture(mid_gradient, vec2(offset));
	} else if (base_color == low_color) {
		COLOR = texture(low_gradient, vec2(offset));
	} else {
		COLOR = base_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
