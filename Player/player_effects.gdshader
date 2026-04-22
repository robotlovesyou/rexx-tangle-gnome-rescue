shader_type canvas_item;

uniform vec2 frame_offset = vec2(0.0);
uniform vec2 frame_scale = vec2(1.0);
uniform float burn_amount: hint_range(0.0, 1.0, 0.01) = 0;
uniform float hide_amount: hint_range(0.0, 1.0, 0.01) = 0;
uniform vec4 burn_color: source_color = vec4(vec3(0.0), 1.0);
const float hide_width = 0.05;
const float burn_width = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 frame_uv = (UV - frame_offset) / frame_scale;
	float burned = 1.0 - burn_amount + burn_width;
	float hidden = 1.0 - hide_amount + hide_width;
	
	float alpha = 1.0 - smoothstep(hidden - hide_width, hidden, frame_uv.y);
	float burn_amt = smoothstep(burned - burn_width, burned, frame_uv.y);
	vec4 mixed = vec4(mix(COLOR, burn_color, burn_amt).rgb, COLOR.a * alpha);
	COLOR = mixed;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
