#include <flutter/runtime_effect.glsl>
//anti aliasing scaling, smaller value make lines more blurry
const float AA_SCALE = 11.0;

const float DIST = 1.0;

//equality threshold of 2 colors before forming lines
const float THRESHOLD = 0.1;

const vec2 IMAGE_SIZE = vec2(128.0, 128.0);


uniform sampler2D image;
uniform vec2 uSize;
uniform float iTime;


out vec4 fragColor;


//draw diagonal line connecting 2 pixels if within threshold
vec4 diag(vec4 sum, vec2 uv, vec2 p1, vec2 p2, vec4 c1, vec4 c2, float LINE_THICKNESS) {
    if (length(c1 - c2) < THRESHOLD) {
        vec2 dir = p2 - p1;
        vec2 lp = uv - (floor(uv + p1) + 0.5);
        dir = normalize(vec2(dir.y, -dir.x));
        float l = clamp((LINE_THICKNESS - dot(lp, dir)) * AA_SCALE, 0.0, 1.0);
        sum = mix(sum, c1, l);
    }
    return sum;
}

void main() {
    float LINE_THICKNESS = 8.0;
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 ip = uv;
    float dist = DIST;

    vec4 texCenter = texture(image, ip);
    vec4 texLeft = texture(image, ip + vec2(-dist, 0) / uSize);
    vec4 texUp = texture(image, ip + vec2(0, dist) / uSize);
    vec4 texRight = texture(image, ip + vec2(dist, 0) / uSize);
    vec4 texDown = texture(image, ip + vec2(0, -dist) / uSize);
    
    //start with nearest pixel as 'background'
    vec4 s = texCenter;
    
    //draw anti aliased diagonal lines of surrounding pixels as 'foreground'
    s = diag(s, ip, vec2(-dist, 0), vec2(0, dist), texLeft, texUp, LINE_THICKNESS);
    s = diag(s, ip, vec2(0, dist), vec2(dist, 0), texUp, texRight, LINE_THICKNESS);
    s = diag(s, ip, vec2(dist, 0), vec2(0, -dist), texRight, texDown, LINE_THICKNESS);
    s = diag(s, ip, vec2(0, -dist), vec2(-dist, 0), texDown, texLeft, LINE_THICKNESS);
    
    fragColor = s;
}