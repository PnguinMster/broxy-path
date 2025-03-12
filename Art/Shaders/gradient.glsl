extern vec4 start_color;
extern vec4 end_color;
extern vec2 direction;
extern float offset;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Normalize the direction vector
    vec2 normalized_direction = normalize(direction);

    // Calculate aspect ratio correction
    float aspect_ratio = love_ScreenSize.x / love_ScreenSize.y;
    vec2 aspect_corrected_coords = screen_coords / love_ScreenSize.xy;
    aspect_corrected_coords.x *= aspect_ratio;

    // Calculate the gradient position
    float t = dot(aspect_corrected_coords, normalized_direction) + offset;
    t = clamp(t, 0.0, 1.0);

    // Mix the colors based on the gradient position
    return mix(start_color, end_color, t);
}
