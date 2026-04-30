shader_type canvas_item;

uniform float darken_factor: hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
	COLOR *= vec4(vec3(darken_factor), 1.0);
}
