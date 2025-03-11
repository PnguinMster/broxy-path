extern float time;  // Pass in the current time for flickering

// Function to generate a random float based on a seed
float random(float seed) {
    return fract(sin(seed) * 43758.5453);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Normalized coords
    vec2 normalized_coords = screen_coords / love_ScreenSize.xy;

    // Generate a unique seed for each star based on screen coordinates
    float seed = dot(normalized_coords * 100.0, vec2(12.9898, 78.233));

    // Random star positions
    float star = fract(sin(seed) * 43758.5453);
    if (star > 0.999) {  // Adjust threshold for star density
        // Generate unique flicker properties for each star
        float flickerSpeed = random(seed) * 0.3 + 0.2;  // Slower speed (ranges from 0.5 to 1.0)
        float minAlpha = random(seed + 1.0) * 0.5 + 0.2;  // Minimum alpha (20% to 70%)
        float maxAlpha = minAlpha + random(seed + 2.0) * 0.3;  // Maximum alpha (slightly above minAlpha)

        // Calculate flickering brightness
        float brightness = 0.5 + 0.5 * sin(time * flickerSpeed + seed * 10.0);
        float alpha = minAlpha + (maxAlpha - minAlpha) * brightness;

        // Apply brightness and alpha to the star
        return vec4(brightness, brightness, brightness, alpha);
    }
    return vec4(0.0, 0.0, 0.0, 0.0);  // Empty space
}
