//https://www.reddit.com/r/godot/comments/zpwhnp/clean4x_a_pixel_art_upscaling_algorithm_for/

shader_type canvas_item;
//the color with the highest priority.
// other colors will be tested based on distance to this
// color to determine which colors take priority for overlaps.
uniform vec3 highestColor = vec3(1.,1.,1.);
//how close two colors should be to be considered "similar".
// can group shapes of visually similar colors, but creates
// some artifacting and should be kept as low as possible.
uniform float similarThreshold = 0.0;
const float scale = 4.0;
const mat3 yuv_matrix = mat3(vec3(0.299, 0.587, 0.114), vec3(-0.169, -0.331, 0.5), vec3(0.5, -0.419, -0.081));
vec3 yuv(vec3 col){
    mat3 yuv = transpose(yuv_matrix);
    return yuv * col;
}
bool similar(vec4 col1, vec4 col2){
    return (col1.a == 0. && col2.a == 0.) || distance(col1, col2) <= similarThreshold;
}
//multiple versions because godot doesn't support function overloading
//note: inner check should ideally check between all permutations
//  but this is good enough, and faster
bool similar3(vec4 col1, vec4 col2, vec4 col3){
    return similar(col1, col2) && similar(col2, col3);
}
bool similar4(vec4 col1, vec4 col2, vec4 col3, vec4 col4){
    return similar(col1, col2) && similar(col2, col3) && similar(col3, col4);
}
bool similar5(vec4 col1, vec4 col2, vec4 col3, vec4 col4, vec4 col5){
    return similar(col1, col2) && similar(col2, col3) && similar(col3, col4) && similar(col4, col5);
}
bool higher(vec4 thisCol, vec4 otherCol){
    if(similar(thisCol, otherCol)) return false;
    if(thisCol.a == otherCol.a){
//      return yuv(thisCol.rgb).x > yuv(otherCol.rgb).x;
//      return distance(yuv(thisCol.rgb), yuv(highestColor)) < distance(yuv(otherCol.rgb), yuv(highestColor));
        return distance(thisCol.rgb, highestColor) < distance(otherCol.rgb, highestColor);
    } else {
        return thisCol.a > otherCol.a;
    }
}
void fragment() {
    vec2 size = 1.0/TEXTURE_PIXEL_SIZE+0.00001; //???
    vec2 px = UV*size;
    vec2 local = floor(mod(px,1.0)*scale);
    vec2 localDiff = (local/1.0) - vec2(1.5, 1.5);
    vec2 edge = floor(local/(scale/2.0))*(scale/2.0) - vec2(1.0, 1.0);
    px = ceil(px);
    
    vec4 baseCol = texture(TEXTURE, px/size);
    vec4 col = baseCol;
    
    vec4 c = baseCol;
    
    
//  vec4 c = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+edge/4.0))/size);
    vec2 ot = vec2(edge.x, edge.y * 4.0);
    vec4 t = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+ot/4.0))/size);
    vec2 otl = vec2(edge.x * 4.0, edge.y * 4.0);
    vec4 tl = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+otl/4.0))/size);
    vec2 otr = vec2(-edge.x * 4.0, edge.y * 4.0);
    vec4 tr = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+otr/4.0))/size);
    vec2 ol = vec2(edge.x * 4.0, edge.y);
    vec4 l = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+ol/4.0))/size);
    vec2 ob = vec2(edge.x, -edge.y * 4.0);
    vec4 b = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+ob/4.0))/size);
    vec2 obl = vec2(edge.x * 4.0, -edge.y * 4.0);
    vec4 bl = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+obl/4.0))/size);
    vec2 obr = vec2(-edge.x * 4.0, -edge.y * 4.0);
    vec4 br = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+obr/4.0))/size);
    vec2 or = vec2(-edge.x * 4.0, edge.y);
    vec4 r = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+or/4.0))/size);
    
    vec2 os = vec2(localDiff.x, localDiff.y);
    vec4 s = texture(TEXTURE, floor(px+(vec2(0.5,0.5)+os/2.0))/size);
    
    
    //checkerboard special case
    if(similar5(c, tl, tr, bl, br) && similar4(t, r, b, l) && higher(t, c)){
//      if(local == vec2(0.,0.)){
//          col = l;
//      } else if(local == vec2(3.,0.)){
//          col = r;
//      } else if(local == vec2(0.,3.)){
//          col = l;
//      } else if(local == vec2(3.,3.)){
//          col = r;
//      }
    } else {
        //corner
        if(length(localDiff) > 2.1){
            if(similar(t, l) && !(similar(tl, c) && !higher(t, c))){
                col = t;
            } else if(higher(c, l) && higher(c, t) && (similar(tr, c) || similar(bl, c)) && !similar(tl, c)){
                if(higher(t, l)){
                    col = t;
                } else {
                    col = l;
                }
            }
        //edge
        } else if(length(localDiff) > 1.58) {
            
            if(similar(t, l)){
                if(higher(s, c)){
                    col = s;
                }
            }
            
            if(similar3(r, s, tl) && similar3(br, c, l) && higher(s, c)/* && !similar(b, t)*/){
                col = t;
            }
            if(!similar(tl, c) && similar3(r, c, bl) && similar3(tr, t, l) && higher(c, l)){
                col = s;
            }
            if(!similar(tr, c) && similar3(l, c, br) && similar3(tl, s, r) && higher(c, r)){
                col = s;
            }
            
            if(similar3(b, s, tl) && similar3(br, c, t) && higher(b, c)/* && !similar(r, l)*/){
                col = s;
            }
            if(!similar(tl, c) && similar3(tr, c, b) && similar3(t, l, bl) && higher(c, l)){
                col = s;
            }
            if(!similar(bl, c) && similar3(br, c, t) && similar3(b, s, tl) && higher(c, s)){
                col = s;
            }
        }
    }
    //set alpha back to full, for manually adjusted pixels 
    if(col.a > 0.00001){
        col.a = 1.0;
    }
    COLOR = col;
}