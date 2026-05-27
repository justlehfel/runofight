shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.1, 0.1, 0.15, 1.0);
uniform vec4 pattern_color : source_color = vec4(0.2, 0.6, 0.4, 0.5);

void fragment() {
    vec2 uv = UV * 5.0; 
    uv.x += TIME * 0.2; 
    uv.y += sin(TIME * 0.5 + uv.x) * 0.5;
   
    float pattern = sin(uv.x) * cos(uv.y);
    pattern = smoothstep(0.1, 0.2, pattern);
    
    COLOR = mix(bg_color, pattern_color, pattern);
}