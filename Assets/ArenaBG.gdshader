shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.05, 0.05, 0.08, 1.0);
uniform vec4 grid_color : source_color = vec4(0.2, 0.8, 0.4, 0.3); 

void fragment() {
    vec2 uv = UV * 10.0;
    
    vec2 grid = abs(fract(uv - vec2(TIME * 0.05)) - 0.5) * 2.0;
    float line = min(grid.x, grid.y);
    line = smoothstep(0.95, 1.0, line);
    float fog = sin(uv.x + TIME * 0.2) * cos(uv.y + TIME * 0.1) * 0.5 + 0.5;
    vec4 final_color = mix(bg_color, grid_color, line);
    final_color += grid_color * fog * 0.2; 
    
    COLOR = final_color;
}