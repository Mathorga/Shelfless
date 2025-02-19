//https://godotshaders.com/shader/pixelart-upscaler-filter-2/

#include <flutter/runtime_effect.glsl>

const float FILTER_GAMMA = 1.0;
const float COLOR_GAMMA = 1.0;


uniform sampler2D image;
uniform vec2 canvas_size;
uniform vec2 image_size;


out vec4 frag_color;


vec2 snap_UV1(vec2 uv, vec2 steps) {
    return (floor(uv / steps) + 0.5) * steps;
}


float length_squared(vec4 v0) {
	return v0.x * v0.x + v0.y * v0.y + v0.z * v0.z + v0.w * v0.w ;
}
void main() {
	vec2 texture_pixel_size = 1.0 / image_size;
	vec2 shift = vec2(-texture_pixel_size * 0.5);
    vec2 uv = FlutterFragCoord().xy / canvas_size;

	// sample the color from the filtered image
	vec4 color_sample0 = texture(image, uv + texture_pixel_size * 0.5 + shift);

	// sample the color from 4 points at positions with a small influence of interpolation
	vec2 sample_uv = snap_UV1(uv + shift, texture_pixel_size);
	vec2 offset = texture_pixel_size; 
	vec4 color_sample1 = texture(image, sample_uv + vec2(0.0, 0.0));
	vec4 color_sample2 = texture(image, sample_uv + vec2(offset.x, 0.0));
	vec4 color_sample3 = texture(image, sample_uv + vec2(0.0, offset.y));
	vec4 color_sample4 = texture(image, sample_uv + vec2(offset.x, offset.y));

	frag_color = color_sample0;

	// gamma adjusment for filtering, affects the brightness influence
	color_sample0 = pow(color_sample0, vec4(FILTER_GAMMA));
	color_sample1 = pow(color_sample1, vec4(FILTER_GAMMA));
	color_sample2 = pow(color_sample2, vec4(FILTER_GAMMA));
	color_sample3 = pow(color_sample3, vec4(FILTER_GAMMA));
	color_sample4 = pow(color_sample4, vec4(FILTER_GAMMA));

	// calculating the diviation 
	float d1 = length_squared(color_sample0 - color_sample1);
	float d2 = length_squared(color_sample0 - color_sample2);
	float d3 = length_squared(color_sample0 - color_sample3);
	float d4 = length_squared(color_sample0 - color_sample4);

	float d0 = 1000.0;

	frag_color = color_sample0;

	if (d0 > d1) {
		d0 = d1;
		frag_color = color_sample1;
	}

	if (d0 > d2) {
		d0 = d2;
		frag_color = color_sample2;
	}

	if (d0 > d3) {
		d0 = d3;
		frag_color = color_sample3;
	}

	if (d0 > d4) {
		d0 = d4;
		frag_color = color_sample4;
	}

	frag_color = pow(frag_color, vec4(COLOR_GAMMA / FILTER_GAMMA));
}