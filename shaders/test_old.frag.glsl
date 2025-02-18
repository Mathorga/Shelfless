#include <flutter/runtime_effect.glsl>

//anti aliasing scaling, smaller value make lines more blurry
const float AA_SCALE = 1.0;

const float DIST = 4.0;

//equality threshold of 2 colors before forming lines
const float THRESHOLD = 0.2;

const vec2 IMAGE_SIZE = vec2(16.0, 16.0);


uniform sampler2D image;
uniform vec2 uSize;
uniform float iTime;


out vec4 fragColor;


//draw diagonal line connecting 2 pixels if within threshold
vec4 diag(vec4 sum, vec2 uv, vec2 p1, vec2 p2, sampler2D img, float lineThickness) {
    vec4 v1 = texture(img, uv + p1);
    vec4 v2 = texture(img, uv + p2);

    if (length(v1 - v2) < THRESHOLD) {
        vec2 dir = p2 - p1;
        vec2 lp = uv - (uv + p1);
        // vec2 lp = uv - ((floor((uv + p1) * IMAGE_SIZE) + 0.5) / IMAGE_SIZE);
        dir = normalize(vec2(dir.y, -dir.x));
        float l = clamp((lineThickness - dot(lp, dir)) * AA_SCALE, 0.0, 1.0);
        sum = mix(sum, v1, l);
    }
    return sum;
}

void main() {
    float lineThickness = 0.5;
    vec2 uv = FlutterFragCoord().xy / uSize;

    // Center uv on original size pixel.
    // vec2 ip = uv;
    vec2 ip = (floor(uv * IMAGE_SIZE) + 0.5) / IMAGE_SIZE;
    vec2 size = uSize;
    // vec2 size = vec2(1.0, 1.0);
    float dist = 1.0 / IMAGE_SIZE.x;
    // float dist = (uSize / IMAGE_SIZE);
    // float dist = ((uSize / IMAGE_SIZE) / IMAGE_SIZE).x;

    //start with nearest pixel as 'background'
    vec4 s = texture(image, ip);

    //draw anti aliased diagonal lines of surrounding pixels as 'foreground'
    s = diag(s, ip, vec2(-dist, 0.0) / size, vec2(0.0, dist) / size, image, lineThickness);
    s = diag(s, ip, vec2(0.0, dist) / size, vec2(dist, 0.0) / size, image, lineThickness);
    s = diag(s, ip, vec2(dist, 0.0) / size, vec2(0.0, -dist) / size, image, lineThickness);
    s = diag(s, ip, vec2(0.0, -dist) / size, vec2(-dist, 0.0) / size, image, lineThickness);

    fragColor = s;
}