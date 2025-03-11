// CRT shader without geometric distortion
// Adjustable parameters
const float scanlineIntensity = 0.2;
const float scanlineCount = 200.0;
const float vignetteStrength = 0.3;
const float rgbOffsetScale = 0.002; // This is now a scale factor, not absolute pixels
const float brightness = 1.1;
const float contrast = 1.1;
const float hazeIntensity = 0.07;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Use original texture coordinates (no distortion)
    vec2 uv = texture_coords;
    
    // Convert to normalized coordinates for effects
    vec2 normalizedCoords = screen_coords / love_ScreenSize.xy;
    
    // Calculate RGB offset based on screen width to keep the effect consistent
    float rgbOffset = rgbOffsetScale * (1.0 / love_ScreenSize.x) * 800.0; // Normalized for 800px reference width
    
    // Apply color channel separation/chromatic aberration
    vec4 colorR = Texel(texture, vec2(uv.x + rgbOffset, uv.y));
    vec4 colorG = Texel(texture, uv);
    vec4 colorB = Texel(texture, vec2(uv.x - rgbOffset, uv.y));
    
    vec4 fragColor = vec4(colorR.r, colorG.g, colorB.b, colorG.a);
    
    // Apply scanlines
    float scanline = sin(normalizedCoords.y * scanlineCount * 3.14159 * 2.0) * 0.5 + 0.5;
    scanline = 1.0 - (scanline * scanlineIntensity);
    fragColor.rgb *= scanline;
    
    // Apply vignette (darker corners)
    vec2 vignetteCoord = normalizedCoords * 2.0 - 1.0;
    float vignette = 1.0 - dot(vignetteCoord, vignetteCoord) * vignetteStrength;
    fragColor.rgb *= vignette;
    
    // Add white haze effect
    fragColor.rgb = mix(fragColor.rgb, vec3(1.0, 1.0, 1.0), hazeIntensity);
    
    // Adjust brightness and contrast
    fragColor.rgb = (fragColor.rgb - 0.5) * contrast + 0.5;
    fragColor.rgb *= brightness;
    
    // Final color
    return fragColor * color;
}
