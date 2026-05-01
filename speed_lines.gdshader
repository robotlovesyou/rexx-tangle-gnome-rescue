shader_type canvas_item;
#include "Level-2-Zebastian/classic_noise2D.gdshaderinc"
#include "Level-2-Zebastian/center_quantized_uv.gdshaderinc"

uniform float frequency: hint_range(0.0, 100.0, 0.1) = 1.0;
uniform float y_stretch: hint_range(0.0, 100.0, 0.1) = 1.0;
uniform float speed: hint_range(0.0, 100.0, 0.1) = 1.0;
uniform float brightness: hint_range(-1.0, 1.0, 0.1) = 0.0;
uniform float contrast: hint_range(0.0, 2.0, 0.1) = 1.0;
const float alpha_pivot = 0.4;
const float alpha_pivot_width = 0.05;
const float edge_width = 0.4;

vec3 adjust_brightness(vec3 color) {
	return color + brightness;
}

vec3 adjust_contrast(vec3 color) {
	return (color - 0.5) * contrast + 0.5;
}

float calculate_factor(float value) {
	float factor = 1.0;
	float top = edge_width;
	float bottom = 1.0 - edge_width;
	float top_factor = value / top;
	float bottom_factor = (1.0 - (value - bottom) / (1.0 - bottom));
	factor -= (1.0 - top_factor) * step(1.0 - edge_width, 1.0 - value);
	factor -= (1.0 - bottom_factor) * step(bottom, value);
	return pow(factor, 2.0);
}

void fragment() {
	vec2 uv = center_quantized_uv(UV * frequency, 1.0, TEXTURE);
	
	// create the speed stripes by stretching noise and then adjusting the brightness and contrast
	vec4 noise = vec4(pnoise(vec2(uv.x, (UV.y / y_stretch) + (speed * TIME)), vec2(400.0)));
	vec3 adjusted = adjust_brightness(adjust_contrast(noise.rgb));
	
	COLOR = vec4(adjusted, adjusted.r * calculate_factor(UV.y) * calculate_factor(UV.x));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
