#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform sampler2D image;
out vec4 fragColor;

void main() {
    fragColor = texture(image, FlutterFragCoord().xy / textureSize(image, 0));
}
