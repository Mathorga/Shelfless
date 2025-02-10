// Adapted to Flutter from https://godotshaders.com/shader/circle-pixel/

#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
uniform vec2 uSize;
uniform sampler2D image;

uniform float amount_x = 1.0;
uniform float amount_y = 1.0;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 pos = uv;
    pos *= vec2(amount_x, amount_y);
    pos = ceil(pos);
    pos /= vec2(amount_x, amount_y);
    vec2 cellpos = pos - (0.5 / vec2(amount_x, amount_y));

    pos -= uv;
    pos *= vec2(amount_x, amount_y);
    pos = vec2(1.0) - pos;

    float dist = distance(pos, vec2(0.5));

    vec4 c = texture(image, cellpos);
    fragColor = c * step(0.0, (0.5 * c.a) - dist);
}