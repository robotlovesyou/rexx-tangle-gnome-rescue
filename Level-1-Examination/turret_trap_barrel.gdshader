shader_type canvas_item;

uniform vec4 replacement_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 0.9, 1.0);
uniform vec4 shadow_color : source_color = vec4(0.2, 0.2, 0.3, 1.0);
uniform float parent_rotation = 0.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color == replacement_color) {
		vec2 texture_size = vec2(textureSize(TEXTURE, 0));
        // Rotate UV coordinates based on parent rotation
	    vec2 centered_uv = UV - 0.5;
	    
	    float s = sin(-parent_rotation);
	    float c = cos(-parent_rotation);
	    mat2 rot = mat2(vec2(c, -s), vec2(s, c));
	    vec2 rotated_pos = rot * centered_uv;
	    
	    // Now use rotated_pos for quadrant logic
	    //bool is_top = rotated_pos.y < 0.0;
		//if (is_top) {
			//COLOR = highlight_color;
		//} else {
			//COLOR = shadow_color;
		//}
		float blend = smoothstep(-0.1, 0.1, rotated_pos.y);
		COLOR = mix(highlight_color, shadow_color, blend);
	}
	
}