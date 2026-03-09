shader_type canvas_item;

uniform sampler2D noise;
uniform float amount: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float threshold: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform vec4 edge_color: source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
	vec4 nf = texture(noise, UV);
	vec4 color = texture(TEXTURE, UV);
	if (amount  == 1.0) {
		//
	} else if (amount < nf.r) {
		color.a = 0.0;
	} else if (amount - threshold < nf.r) {
		color = vec4(edge_color.rgb, color.a);
	}
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
