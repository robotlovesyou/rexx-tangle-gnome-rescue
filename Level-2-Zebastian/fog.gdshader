shader_type canvas_item;
#include "res://Shared/ShaderIncludes/classic_noise3D.gdshaderinc"
#include "res://Shared/ShaderIncludes/center_quantized_uv.gdshaderinc"

uniform float speed = 0.1;
uniform float frequency = 10.0;
uniform float influence: hint_range(0.0, 1.0, 0.01) = 0.5;
const float world_px_size = 0.0025; // this is used to quantize the fog effect.

varying vec2 world_uv;

void vertex() {
    // VERTEX is in local space, MODEL_MATRIX transforms to world space
    vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
    world_uv = world_pos / vec2(2000.0, 2000.0);
}

float remap(float value, float inMin, float inMax, float outMin, float outMax) {
    return outMin + (value - inMin) / (inMax - inMin) * (outMax - outMin);
}

void fragment() {
	vec3 at = vec3(center_quantized_uv(world_uv, world_px_size, TEXTURE), TIME * speed) * frequency;
	float alpha = COLOR.a * (remap(pnoise(at, vec3(100.0, 100.0, 100.0)), -1.0, 1.0, 0.0, influence) + (1.0 - influence));
	COLOR = vec4(COLOR.xyz, alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
