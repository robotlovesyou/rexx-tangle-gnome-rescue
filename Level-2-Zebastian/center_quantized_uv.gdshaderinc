vec2 center_quantized_uv(vec2 base_uv, float quanta_size, sampler2D base_texture) {
	vec2 texture_size = vec2(textureSize(base_texture,0));
	vec2 pixel_coords = base_uv * texture_size;
	vec2 block_index = floor(pixel_coords / quanta_size);
	vec2 block_center = (block_index + 0.5) * quanta_size;
	return block_center / texture_size;
}