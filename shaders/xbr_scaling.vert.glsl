#version 400

vec4 position : POSITION,
vec4 color : COLOR,
vec2 texCoord : TEXCOORD0,

out vec4 OUT;
out vec3 texture_coords;

uniform half4x4 modelViewProj,
uniform input IN

void main() {
    // OUT.position = mul(modelViewProj, position);
    OUT.position = position;
    OUT.color = color;

    float2 ps = float2(1.0 / IN.texture_size.x, 1.0 / IN.texture_size.y);
    float dx = ps.x;
    float dy = ps.y;

    //    A1 B1 C1
    // A0  A  B  C C4
    // D0  D  E  F F4
    // G0  G  H  I I4
    //    G5 H5 I5

    OUT.texCoord = texCoord;
    OUT.t1 = texCoord.xxxy + vec4(-dx, 0, dx, -2.0 * dy); // A1 B1 C1
    OUT.t2 = texCoord.xxxy + vec4(-dx, 0, dx, -dy);       //  A  B  C
    OUT.t3 = texCoord.xxxy + vec4(-dx, 0, dx, 0);         //  D  E  F
    OUT.t4 = texCoord.xxxy + vec4(-dx, 0, dx, dy);        //  G  H  I
    OUT.t5 = texCoord.xxxy + vec4(-dx, 0, dx, 2.0 * dy);  // G5 H5 I5
    OUT.t6 = texCoord.xyyy + vec4(-2.0 * dx, -dy, 0, dy); // A0 D0 G0
    OUT.t7 = texCoord.xyyy + vec4(2.0 * dx, -dy, 0, dy);  // C4 F4 I4
    OUT.pos = texCoord * IN.texture_size;

    return OUT;
}