/**
MIT LICENSE
Copyright (c) 2022 torcado

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
**/

/**
WARNING: Does not work as well with upscaled textures: use only on true size textures.
**/

#include <flutter/runtime_effect.glsl>

uniform sampler2D image;
uniform vec2 canvas_size;
uniform vec2 texture_size;

out vec4 fragColor;

// The color with the highest priority.
// other colors will be tested based on distance to this
// color to determine which colors take priority for overlaps.
vec3 highest_color = vec3(1.0, 1.0, 1.0);

// How close two colors should be to be considered "similar".
// can group shapes of visually similar colors, but creates
// some artifacting and should be kept as low as possible.
float similar_threshold = 0.2;

float line_width = 0.75;

const float scale = 4.0;
const mat3 yuv_matrix = mat3(
    vec3(0.299, 0.587, 0.114),
    vec3(-0.169, -0.331, 0.5),
    vec3(0.5, -0.419, -0.081)
);
const mat3 yuv_transposed = mat3(
    vec3(0.299, -0.169, 0.5),
    vec3(0.587, -0.331, -0.419),
    vec3(0.114, 0.5, -0.081)
);

vec3 yuv(vec3 col) {
    return yuv_transposed * col;
}

bool similar(vec4 col1, vec4 col2) {
    return (col1.a == 0.0 && col2.a == 0.0) || distance(col1, col2) <= similar_threshold;
}

//multiple versions because godot doesn't support function overloading
//note: inner check should ideally check between all permutations
//  but this is good enough, and faster
bool similar3(vec4 col1, vec4 col2, vec4 col3) {
    return similar(col1, col2) && similar(col2, col3);
}

bool similar4(vec4 col1, vec4 col2, vec4 col3, vec4 col4) {
    return similar(col1, col2) && similar(col2, col3) && similar(col3, col4);
}

bool similar5(vec4 col1, vec4 col2, vec4 col3, vec4 col4, vec4 col5) {
    return similar(col1, col2) && similar(col2, col3) && similar(col3, col4) && similar(col4, col5);
}

bool higher(vec4 thisCol, vec4 otherCol) {
    if(similar(thisCol, otherCol)) return false;
    if(thisCol.a == otherCol.a){
        return distance(thisCol.rgb, highest_color) < distance(otherCol.rgb, highest_color);
    } else {
        return thisCol.a > otherCol.a;
    }
}

vec4 higherCol(vec4 thisCol, vec4 otherCol) {
    return higher(thisCol, otherCol) ? thisCol : otherCol;
}

//color distance
float cd(vec4 col1, vec4 col2) {
    return distance(col1.rgba, col2.rgba);
}

float distToLine(vec2 testPt, vec2 pt1, vec2 pt2, vec2 dir) {
  vec2 lineDir = pt2 - pt1;
  vec2 perpDir = vec2(lineDir.y, -lineDir.x);
  vec2 dirToPt1 = pt1 - testPt;
  return (dot(perpDir, dir) > 0.0 ? 1.0 : -1.0) * (dot(normalize(perpDir), dirToPt1));
}

//based on down-forward direction
vec4 slice_dist(
    vec2 point,
    vec2 mainDir,
    vec2 point_dir,
    vec4 data[15]
){

    vec4 ub = data[0];
    vec4 u = data[1];
    vec4 uf = data[2];
    vec4 uff = data[3];
    vec4 b = data[4];
    vec4 c = data[5];
    vec4 f = data[6];
    vec4 ff = data[7];
    vec4 db = data[8];
    vec4 d = data[9];
    vec4 df = data[10];
    vec4 dff = data[11];
    vec4 ddb = data[12];
    vec4 dd = data[13];
    vec4 ddf = data[14];

    //clamped range prevents inacccurate identity (no change) result, feel free to disable if necessary
    float minWidth = 0.0;
    float maxWidth = 1.4;

    float _line_width = max(minWidth, min(maxWidth, line_width));
    point = mainDir * (point - 0.5) + 0.5; //flip point
    
    //edge detection
    float distAgainst = 4.0*cd(f,d) + cd(uf,c) + cd(c,db) + cd(ff,df) + cd(df,dd);
    float distTowards = 4.0*cd(c,df) + cd(u,f) + cd(f,dff) + cd(b,d) + cd(d,ddf);
    bool shouldSlice = 
      (distAgainst < distTowards)
      || (distAgainst < distTowards + 0.001) && !higher(c, f); //equivalent edges edge case
    if(similar4(f, d, b, u) && similar4(uf, df, db, ub) && !similar(c, f)){ //checkerboard edge case
        shouldSlice = false;
    }
    if(!shouldSlice) return vec4(-1.0);
    
    //only applicable for very large line_width (>1.3)
//    if(similar3(c, f, df)){ //don't make slice for same color
//        return vec4(-1.0);
//    }
    float dist = 1.0;
    bool flip = false;
    vec2 center = vec2(0.5,0.5);

    if(similar(f, d)) { //45 diagonal
        if(similar(c, df) && higher(c, f)){ //single pixel diagonal along neighbors, dont flip
            if(!similar(c, dd) && !similar(c, ff)){ //line against triple color stripe edge case
                flip = true; 
            }
        } else {
            //priority edge cases
            if(higher(c, f)){
                flip = true; 
            }
            if(!similar(c, b) && similar4(b, f, d, u)){
                flip = true;
            }
        }
        //single pixel 2:1 slope, dont flip
        if((( (similar(f, db) && similar3(u, f, df)) || (similar(uf, d) && similar3(b, d, df)) ) && !similar(c, df))){
            flip = true;
        } 
        
        if(flip){
            dist = _line_width-distToLine(point, center+vec2(1.0, -1.0)*point_dir, center+vec2(-1.0, 1.0)*point_dir, -point_dir); //midpoints of own diagonal pixels
        } else {
            dist = distToLine(point, center+vec2(1.0, 0.0)*point_dir, center+vec2(0.0, 1.0)*point_dir, point_dir); //midpoints of corner neighbor pixels
        }

        dist -= (_line_width/2.0);
        return dist <= 0.0 ? ((cd(c,f) <= cd(c,d)) ? f : d) : vec4(-1.0);
    } 

    return vec4(-1.0);
}

void main() {
    vec2 resolution = texture_size;
    vec2 size = resolution.xy + 0.0001; //fix for some sort of rounding error
    vec2 texture_coords = FlutterFragCoord().xy / canvas_size;
    vec2 px = texture_coords.xy * size;
    vec2 local = fract(px);
    px = ceil(px);

    vec2 point_dir = round(local) * 2.0 - 1.0;
    
    // Neighbor pixels
    // Up, Down, Forward, and Back
    // relative to quadrant of current location within pixel.
    //         [uub]   [u u]   [uuf]
    // [ubb]   [u b]   [ u ]   [u f]   [uff]
    // [b b]   [ b ]   [ c ]   [ f ]   [f f]
    // [dbb]   [d b]   [ d ]   [d f]   [dff]
    //         [ddb]   [d d]   [ddf]

    vec4 uub = texture(image, (px + vec2(-1.0,-2.0) * point_dir) / size);
    vec4 uu = texture(image, (px + vec2( 0.0,-2.0) * point_dir) / size);
    vec4 uuf = texture(image, (px + vec2( 1.0,-2.0) * point_dir) / size);

    vec4 ubb = texture(image, (px + vec2(-2.0,-2.0) * point_dir) / size);
    vec4 ub = texture(image, (px + vec2(-1.0,-1.0) * point_dir) / size);
    vec4 u = texture(image, (px + vec2( 0.0,-1.0) * point_dir) / size);
    vec4 uf = texture(image, (px + vec2( 1.0,-1.0) * point_dir) / size);
    vec4 uff = texture(image, (px + vec2( 2.0,-1.0) * point_dir) / size);

    vec4 bb = texture(image, (px + vec2(-2.0, 0.0) * point_dir) / size);
    vec4 b = texture(image, (px + vec2(-1.0, 0.0) * point_dir) / size);
    vec4 c = texture(image, (px + vec2( 0.0, 0.0) * point_dir) / size);
    vec4 f = texture(image, (px + vec2( 1.0, 0.0) * point_dir) / size);
    vec4 ff = texture(image, (px + vec2( 2.0, 0.0) * point_dir) / size);

    vec4 dbb = texture(image, (px + vec2(-2.0, 1.0) * point_dir) / size);
    vec4 db = texture(image, (px + vec2(-1.0, 1.0) * point_dir) / size);
    vec4 d = texture(image, (px + vec2( 0.0, 1.0) * point_dir) / size);
    vec4 df = texture(image, (px + vec2( 1.0, 1.0) * point_dir) / size);
    vec4 dff = texture(image, (px + vec2( 2.0, 1.0) * point_dir) / size);

    vec4 ddb = texture(image, (px + vec2(-1.0, 2.0) * point_dir) / size);
    vec4 dd = texture(image, (px + vec2( 0.0, 2.0) * point_dir) / size);
    vec4 ddf = texture(image, (px + vec2( 1.0, 2.0) * point_dir) / size);

    vec4 col = c;

    // c_orner, b_ack, and u_p slices
    // slices from neighbor pixels will only ever reach these 3 quadrants
    vec4 c_col = slice_dist(local, vec2( 1.0, 1.0), point_dir, vec4[15](ub, u, uf, uff, b, c, f, ff, db, d, df, dff, ddb, dd, ddf));
    vec4 b_col = slice_dist(local, vec2(-1.0, 1.0), point_dir, vec4[15](uf, u, ub, ubb, f, c, b, bb, df, d, db, dbb, ddf, dd, ddb));
    vec4 u_col = slice_dist(local, vec2( 1.0,-1.0), point_dir, vec4[15](db, d, df, dff, b, c, f, ff, ub, u, uf, uff, uub, uu, uuf));

    if (c_col.r >= 0.0) {
        col = c_col;
    }
    if (b_col.r >= 0.0) {
        col = b_col;
    }
    if (u_col.r >= 0.0) {
        col = u_col;
    }

    // fragColor = texture(image, FlutterFragCoord());
    fragColor = col;
}
