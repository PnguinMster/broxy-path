extern vec4 start_color;
extern vec4 end_color;
extern vec2 direction;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	float t = dot(texture_coords, direction);
	return mix(start_color, end_color, t);
}
