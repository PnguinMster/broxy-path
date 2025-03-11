extern float time;  // Pass in the current time for animation

// Function to generate 2D Perlin noise
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Smooth interpolation function
float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    // Bilinear interpolation
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion (FBM) for more organic noise
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 1.0;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        total += smoothNoise(p * frequency) * amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return total;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Normalized coordinates
    vec2 normalized_coords = screen_coords / love_ScreenSize.xy;

    // Animate the nebula over time
    vec2 animated_coords = normalized_coords + vec2(time * 0.03, time * 0.02);

    // Generate FBM noise for the nebula effect
    float noise1 = fbm(animated_coords * 2.0);
    float noise2 = fbm(animated_coords * 4.0 + vec2(10.0));
    float noise3 = fbm(animated_coords * 8.0 + vec2(20.0));

    // Combine noise layers for a more complex effect
    float nebula = noise1 * 0.5 + noise2 * 0.3 + noise3 * 0.2;

    // Define nebula colors (you can customize these)
    vec3 color1 = vec3(0.2, 0.1, 0.4);  // Deep purple
    vec3 color2 = vec3(0.5, 0.2, 0.6);  // Bright purple
    vec3 color3 = vec3(0.1, 0.3, 0.7);  // Blue

    // Blend colors based on the noise
    vec3 final_color = mix(color1, color2, nebula);
    final_color = mix(final_color, color3, noise2);

    // Add some brightness variation
    final_color *= 0.8 + 0.2 * sin(time + nebula * 10.0);

    return vec4(final_color, 0.1);  // Return the final nebula color
}
