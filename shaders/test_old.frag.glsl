// https://godotshaders.com/shader/basic-vector-sprite-upscaling/

#include <flutter/runtime_effect.glsl>

//anti aliasing scaling, smaller value make lines more blurry
const float AA_SCALE = 2.0;

const float DIST = 1.0;

//equality threshold of 2 colors before forming lines
const float THRESHOLD = 0.5;

const vec2 IMAGE_SIZE = vec2(32.0, 32.0);

const vec2 PIXEL_SIZE = 1.0 / IMAGE_SIZE;


uniform sampler2D image;
uniform vec2 uSize;
uniform float iTime;


out vec4 fragColor;


//draw diagonal line connecting 2 pixels if within threshold
vec4 diag(vec4 sum, vec2 uv, vec2 p1, vec2 p2, sampler2D img, float lineThickness) {
    vec4 v1 = texture(img, uv + p1);
    vec4 v2 = texture(img, uv + p2);

    // Convert points coordinates to 
    vec2 ip = uv * IMAGE_SIZE;
    vec2 ip1 = p1 * IMAGE_SIZE;
    vec2 ip2 = p2 * IMAGE_SIZE;

    if (length(v1 - v2) < THRESHOLD) {
        vec2 dir = p2 - p1;
        vec2 lp = (ip - (floor(ip + ip1) + 0.5));
        vec2 uvlp = lp * PIXEL_SIZE;
        dir = normalize(vec2(dir.y, -dir.x));
        float l = clamp((lineThickness - dot(uvlp, dir)) * AA_SCALE, 0.0, 1.0);
        sum = mix(sum, v1, l);
    }
    return sum;
}

void main() {
    float lineThickness = 0.4;
    vec2 uv = FlutterFragCoord().xy / uSize;

    // Center uv on original size pixel.
    vec2 ip = uv;
    vec2 dist = DIST * PIXEL_SIZE;

    //start with nearest pixel as 'background'
    vec4 s = texture(image, ip);

    //draw anti aliased diagonal lines of surrounding pixels as 'foreground'
    s = diag(s, ip, vec2(-1.0, 0.0) * dist, vec2(0.0, 1.0) * dist, image, lineThickness);
    s = diag(s, ip, vec2(0.0, 1.0) * dist, vec2(1.0, 0.0) * dist, image, lineThickness);
    s = diag(s, ip, vec2(1.0, 0.0) * dist, vec2(0.0, -1.0) * dist, image, lineThickness);
    s = diag(s, ip, vec2(0.0, -1.0) * dist, vec2(-1.0, 0.0) * dist, image, lineThickness);

    fragColor = s;
}