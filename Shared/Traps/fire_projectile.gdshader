shader_type canvas_item;
#include "res://Shared/ShaderIncludes/center_quantized_uv.gdshaderinc"

uniform sampler3D noise;
uniform sampler3D noise2;
uniform sampler2D ramp;
uniform float v_speed: hint_range(0.0, 1.0, 0.01);
uniform float d_speed: hint_range(0.0, 1.0, 0.01);
const float pixel_size = 2.0;
const float offset_scale = 0.25;

vec4 sample_noise(sampler3D sample, vec2 uv) {
	return texture(sample, vec3(vec2(mod(uv.x, 1.0), mod(uv.y + TIME * v_speed, 1.0)), mod(TIME * d_speed, 1.0)));
}

vec4 rotate_uv(vec4 v, float angle) {
    float sn = sin(angle);
    float cs = cos(angle);
    mat2 rot = mat2(vec2(cs, -sn), vec2(sn, cs));
    return vec4(rot * v.xy, v.z, v.w);
}

void fragment() {
	//vec2 frame_uv = (UV - REGION_RECT.xy) / REGION_RECT.zw;
	
	// center offset noise ranges between -0.5 and 0.5
	vec4 offset_nuv = rotate_uv(sample_noise(noise, UV) - vec4(0.5), TIME * PI);
	
	vec2 cquv = center_quantized_uv(UV + vec2(offset_nuv.r * offset_scale, offset_nuv.g * offset_scale), pixel_size, TEXTURE);
	float a = texture(TEXTURE, cquv).a;
	vec4 nuv = sample_noise(noise, cquv);
	COLOR = vec4(texture(ramp, vec2(nuv.r, 0.0)).rgb, a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
