#include <flutter/runtime_effect.glsl>

uniform sampler2D image;
uniform vec2 canvas_size;
// uniform vec2 texture_size;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord / canvas_size.xy;

    vec3 col = texture(image, uv).xyz;
    fragColor = vec4(col, 1.0);
}