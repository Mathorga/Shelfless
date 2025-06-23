#include <flutter/runtime_effect.glsl>

uniform sampler2D image;
uniform vec2 uSize;
uniform float iTime;

out vec4 fragColor;

float inverseLerp(float v, float minValue, float maxValue) {
    return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

void main() {
    vec2 iResolution = uSize;
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord / iResolution.xy;

    vec3 col = texture(image, uv).xyz;

    // Ripples
    float distToCenter = length(uv - 0.5);
    float d = sin(distToCenter * 30.0 - iTime * 2.0);
    vec2 dir = normalize(uv - 0.5);
    vec2 rippleCoords = uv + d * dir * 0.05;
    col = texture(image, rippleCoords).xyz;

    // Output to screen
    fragColor = vec4(col, 1.0);
}