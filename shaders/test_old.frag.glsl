#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
uniform vec2 uSize;
uniform sampler2D image;
uniform float iTime;


//equality threshold of 2 colors before forming lines
uniform float THRESHOLD = 0.1;

//anti aliasing scaling, smaller value make lines more blurry
uniform float AA_SCALE = 1.0;

const float dist = 1.0;


//draw diagonal line connecting 2 pixels if within threshold
vec4 diag(vec4 sum, vec2 uv, vec2 p1, vec2 p2, sampler2D iChannel0, float lineThickness) {
    vec4 v1 = texture(iChannel0, uv + p1);
    vec4 v2 = texture(iChannel0, uv + p2);

    if (length(v1 - v2) < THRESHOLD) {
    	vec2 dir = p2 - p1;
        vec2 lp = uv - (uv + p1 + (0.5 / uSize));
    	dir = normalize(vec2(dir.y, -dir.x));
        float l = clamp((lineThickness - dot(lp, dir)) * AA_SCALE, 0.0, 1.0);
        sum = mix(sum, v1, l);
    }
    return sum;
}

void main() {
    float lineThickness = 0.4;
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 ip = uv;
    // ip = uv * (1.0 / TEXTURE_PIXEL_SIZE);

    //start with nearest pixel as 'background'
    vec4 s = texture(image, ip);

    //draw anti aliased diagonal lines of surrounding pixels as 'foreground'
    s = diag(s, ip, vec2(-dist, 0.0) / uSize, vec2(0.0, dist) / uSize, image, lineThickness);
    s = diag(s, ip, vec2(0.0, dist) / uSize, vec2(dist, 0.0) / uSize, image, lineThickness);
    s = diag(s, ip, vec2(dist, 0.0) / uSize, vec2(0.0, -dist) / uSize, image, lineThickness);
    s = diag(s, ip, vec2(0.0, -dist) / uSize, vec2(-dist, 0.0) / uSize, image, lineThickness);

    fragColor = s;// * vec4(0.2, 0.5, 0.8, 1.0);
}