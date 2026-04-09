shader_type canvas_item;

uniform sampler3D noise;
uniform sampler3D noise2;
uniform sampler2D ramp;
uniform float v_speed: hint_range(0.0, 1.0, 0.01);
uniform float d_speed: hint_range(0.0, 1.0, 0.01);
uniform float offset: hint_range(0.0, 1.0, 0.1);
const float pixel_size = 1.0;
const float offset_scale = 0.25;

vec4 sample_noise(sampler3D sample, vec2 uv) {
	return texture(sample, vec3(vec2(mod(uv.x + offset, 1.0), mod(uv.y + offset + TIME * v_speed, 1.0)), mod(TIME * d_speed, 1.0)));
}

vec2 center_quantized_uv(vec2 base_uv, float quanta_size, sampler2D base_texture) {
	vec2 texture_size = vec2(textureSize(base_texture,0));
	vec2 pixel_coords = base_uv * texture_size;
	vec2 block_index = floor(pixel_coords / quanta_size);
	vec2 block_center = (block_index + 0.5) * quanta_size;
	return block_center / texture_size;
}

void fragment() {
	
	// center offset noise ranges between -0.5 and 0.5
	vec4 offset_nuv = sample_noise(noise, UV) - vec4(0.5);
	vec4 offset_nuv2 = sample_noise(noise2, UV) - vec4(0.5);
	
	vec2 cquv = center_quantized_uv(UV + vec2(offset_nuv.r * offset_scale, offset_nuv2.r * offset_scale), pixel_size, TEXTURE);
	float a = texture(TEXTURE, cquv).a;
	vec4 nuv = sample_noise(noise, cquv);
	vec4 nuv2 = sample_noise(noise2, cquv);
	
	COLOR = vec4(texture(ramp, vec2(nuv.r, 0.0)).rgb, min(a, step(0.45, nuv2.r)));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
