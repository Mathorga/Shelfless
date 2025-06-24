#include <flutter/runtime_effect.glsl>

const int ML = 0;
const float THRESHOLD = 0.001;
const float AA_SCALE = 11.0;
const float DIST = 4.0;

uniform sampler2D image;
uniform vec2 canvas_size;
uniform vec2 texture_size;

out vec4 fragColor;

bool eq(vec4 col1, vec4 col2) {
    vec4 diff = col1 - col2;
    float length_squared = diff.r * diff.r + diff.g * diff.g + diff.b * diff.b + diff.a * diff.a;
    return length_squared < THRESHOLD * THRESHOLD;
}

// draw diagonal line connecting 2 pixels if within threshold
vec4 diag(vec4 sum, vec2 uv, vec2 point1, vec2 point2, vec4 color1, vec4 color2, float LINE_THICKNESS) {
    if (eq(color1, color2)) {
        vec2 dir = point2 - point1;
        vec2 lp = uv - (floor(uv + point1) + 0.5);
        dir = normalize(vec2(dir.y, -dir.x));
        float l = clamp((LINE_THICKNESS - dot(lp, dir)) * AA_SCALE, 0.0, 1.0);
        sum = mix(sum, color1, l);
    }
    return sum;
}

void main() {
    float LINE_THICKNESS = 0.4;
    vec2 uv = FlutterFragCoord().xy / canvas_size;
    // ip = uv * (1.0 / TEXTURE_PIXEL_SIZE);
    vec2 ip = uv;
    // vec2 ip = uv * texture_size;

    /*
        lu	u	ru
        l	c	r
        ld	d	rd
    */

    vec4 c = texture(image, ip);
    vec4 l = texture(image, ip + (vec2(-DIST, 0.0) / canvas_size));
    vec4 d = texture(image, ip + (vec2(0.0, DIST) / canvas_size));
    vec4 r = texture(image, ip + (vec2(DIST, 0.0) / canvas_size));
    vec4 u = texture(image, ip + (vec2(0.0, -DIST) / canvas_size));

    vec4 ld = texture(image, ip + (vec2(-DIST, DIST) / canvas_size));
    vec4 lu = texture(image, ip + (vec2(-DIST, -DIST) / canvas_size));
    vec4 rd = texture(image, ip + (vec2(DIST, DIST) / canvas_size));
    vec4 ru = texture(image, ip + (vec2(DIST, -DIST) / canvas_size));

    vec4 s = c;

    ivec4 mask = ivec4(1);

    if (eq(ld, c)) mask.x = 0;
    if (eq(lu, c)) mask.y = 0;
    if (eq(rd, c)) mask.z = 0;
    if (eq(ru, c)) mask.w = 0;

    if (mask.x == 1) s = diag(s, ip, vec2(-DIST, 0) / canvas_size, vec2(0, DIST) / canvas_size, l, d, LINE_THICKNESS);
    if (mask.y == 1) s = diag(s, ip, vec2(0, -DIST) / canvas_size, vec2(-DIST, 0) / canvas_size, l, u, LINE_THICKNESS);
    if (mask.z == 1) s = diag(s, ip, vec2(0, DIST) / canvas_size, vec2(DIST, 0) / canvas_size, r, d, LINE_THICKNESS);
    if (mask.w == 1) s = diag(s, ip, vec2(DIST, 0) / canvas_size, vec2(0, -DIST) / canvas_size, r, u, LINE_THICKNESS);

    vec4 f = c;
    f = diag(f, ip, vec2(-DIST, 0) / canvas_size, vec2(0, DIST) / canvas_size, l, d, LINE_THICKNESS);
    f = diag(f, ip, vec2(0, -DIST) / canvas_size, vec2(-DIST, 0) / canvas_size, l, u, LINE_THICKNESS);
    f = diag(f, ip, vec2(0, DIST) / canvas_size, vec2(DIST, 0) / canvas_size, r, d, LINE_THICKNESS);
    f = diag(f, ip, vec2(DIST, 0) / canvas_size, vec2(0, -DIST) / canvas_size, r, u, LINE_THICKNESS);

    fragColor = (s + f) / 2.0;
}