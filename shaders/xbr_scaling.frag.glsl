in out_vertex VAR,
uniform sampler2D decal : TEXUNIT0,
uniform input IN

void main() {
    bool4 edr, edr_left, edr_up, px; // px = pixel, edr = edge detection rule
    bool4 interp_restriction_lv1, interp_restriction_lv2_left, interp_restriction_lv2_up;
    bool4 nc, nc30, nc60, nc45;          // new_color
    float4 fx, fx_left, fx_up, final_fx; // inequations of straight lines.

    float2 fp = frac(VAR.pos);

    half3 A1 = tex2D(decal, VAR.t1.xw).rgb;
    half3 B1 = tex2D(decal, VAR.t1.yw).rgb;
    half3 C1 = tex2D(decal, VAR.t1.zw).rgb;

    half3 A = tex2D(decal, VAR.t2.xw).rgb;
    half3 B = tex2D(decal, VAR.t2.yw).rgb;
    half3 C = tex2D(decal, VAR.t2.zw).rgb;

    half3 D = tex2D(decal, VAR.t3.xw).rgb;
    half3 E = tex2D(decal, VAR.t3.yw).rgb;
    half3 F = tex2D(decal, VAR.t3.zw).rgb;

    half3 G = tex2D(decal, VAR.t4.xw).rgb;
    half3 H = tex2D(decal, VAR.t4.yw).rgb;
    half3 I = tex2D(decal, VAR.t4.zw).rgb;

    half3 G5 = tex2D(decal, VAR.t5.xw).rgb;
    half3 H5 = tex2D(decal, VAR.t5.yw).rgb;
    half3 I5 = tex2D(decal, VAR.t5.zw).rgb;

    half3 A0 = tex2D(decal, VAR.t6.xy).rgb;
    half3 D0 = tex2D(decal, VAR.t6.xz).rgb;
    half3 G0 = tex2D(decal, VAR.t6.xw).rgb;

    half3 C4 = tex2D(decal, VAR.t7.xy).rgb;
    half3 F4 = tex2D(decal, VAR.t7.xz).rgb;
    half3 I4 = tex2D(decal, VAR.t7.xw).rgb;

    float4 b = mul(half4x3(B, D, H, F), yuv_weighted[0]);
    float4 c = mul(half4x3(C, A, G, I), yuv_weighted[0]);
    float4 e = mul(half4x3(E, E, E, E), yuv_weighted[0]);
    float4 d = b.yzwx;
    float4 f = b.wxyz;
    float4 g = c.zwxy;
    float4 h = b.zwxy;
    float4 i = c.wxyz;

    float4 i4 = mul(half4x3(I4, C1, A0, G5), yuv_weighted[0]);
    float4 i5 = mul(half4x3(I5, C4, A1, G0), yuv_weighted[0]);
    float4 h5 = mul(half4x3(H5, F4, B1, D0), yuv_weighted[0]);
    float4 f4 = h5.yzwx;

    float4 Ao = float4(1.0, -1.0, -1.0, 1.0);
    float4 Bo = float4(1.0, 1.0, -1.0, -1.0);
    float4 Co = float4(1.5, 0.5, -0.5, 0.5);
    float4 Ax = float4(1.0, -1.0, -1.0, 1.0);
    float4 Bx = float4(0.5, 2.0, -0.5, -2.0);
    float4 Cx = float4(1.0, 1.0, -0.5, 0.0);
    float4 Ay = float4(1.0, -1.0, -1.0, 1.0);
    float4 By = float4(2.0, 0.5, -2.0, -0.5);
    float4 Cy = float4(2.0, 0.0, -1.0, 0.5);

    // These inequations define the line below which interpolation occurs.
    fx = (Ao * fp.y + Bo * fp.x);
    fx_left = (Ax * fp.y + Bx * fp.x);
    fx_up = (Ay * fp.y + By * fp.x);

    interp_restriction_lv1 = ((e != f) && (e != h) && (!eq(f, b) && !eq(f, c) || !eq(h, d) && !eq(h, g) || eq(e, i) && (!eq(f, f4) && !eq(f, i4) || !eq(h, h5) && !eq(h, i5)) || eq(e, g) || eq(e, c)));
    interp_restriction_lv2_left = ((e != g) && (d != g));
    interp_restriction_lv2_up = ((e != c) && (b != c));

    float4 fx45 = smoothstep(Co - delta, Co + delta, fx);
    float4 fx30 = smoothstep(Cx - delta, Cx + delta, fx_left);
    float4 fx60 = smoothstep(Cy - delta, Cy + delta, fx_up);

    edr = (weighted_distance(e, c, g, i, h5, f4, h, f) < weighted_distance(h, d, i5, f, i4, b, e, i)) && interp_restriction_lv1;
    edr_left = ((coef * df(f, g)) <= df(h, c)) && interp_restriction_lv2_left;
    edr_up = (df(f, g) >= (coef * df(h, c))) && interp_restriction_lv2_up;

    nc45 = (edr && bool4(fx45));
    nc30 = (edr && edr_left && bool4(fx30));
    nc60 = (edr && edr_up && bool4(fx60));

    px = (df(e, f) <= df(e, h));

    nc = (nc30 || nc60 || nc45);

    float final45 = dot(nc45, fx45);
    float final30 = dot(nc30, fx30);
    float final60 = dot(nc60, fx60);

    float blend = max(max(final30, final60), final45);

    half3 pix = nc.x ? px.x ? F : H : nc.y ? px.y ? B : F
                                  : nc.z   ? px.z ? D : B
                                  : nc.w   ? px.w ? H : D
                                           : E;

    half3 res = lerp(E, pix, blend);

    return half4(res, 1.0);
}