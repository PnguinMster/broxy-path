extern vec4 start_color;
extern vec4 end_color;
extern vec2 direction;
extern float offset;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 normalized_direction = normalize(direction);
    vec2 normalized_coords = screen_coords / love_ScreenSize.xy;
    
    float t = dot(normalized_coords, normalized_direction) + offset;
    t = clamp(t, 0.0, 1.0);
    
    return mix(start_color, end_color, t);
}
