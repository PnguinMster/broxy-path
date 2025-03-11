// Adjustable parameters
const float scanlineIntensity = 0.2;
const float scanlineCount = 200.0;
const float vignetteStrength = 0.2;
const float curvature = 0.01; // Very minimal curvature, mostly visual
const float rgbOffset = 0.002;
const float cornerRounding = 0.02; // Subtle rounded corners

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Convert to normalized coordinates using built-in love_ScreenSize
    vec2 uv = screen_coords / love_ScreenSize.xy;
    
    // Convert to -1 to 1 range
    vec2 dc = uv * 2.0 - 1.0;
    
    // Apply very minimal barrel distortion - just enough for visual effect
    // but not enough to significantly move elements
    float distortionFactor = 1.0 + curvature * (dc.x * dc.x + dc.y * dc.y);
    vec2 distortedDC = dc * distortionFactor;
    
    // Convert back to 0-1 range
    vec2 curvedUV = distortedDC * 0.5 + 0.5;
    
    // Create slightly rounded corners
    float corner = length(max(abs(dc) - (1.0 - cornerRounding), 0.0)) / cornerRounding;
    float fadeCorner = smoothstep(0.0, 1.0, corner);
    
    // If pixel is in the rounded corner area, make it black
    if (fadeCorner > 0.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }
    
    // If pixel would be outside screen due to minor distortion,
    // use the original coordinates instead
    vec2 finalUV = curvedUV;
    if (curvedUV.x < 0.0 || curvedUV.x > 1.0 || curvedUV.y < 0.0 || curvedUV.y > 1.0) {
        finalUV = texture_coords; // Use original coordinates
    }
    
    // Apply color channel separation/chromatic aberration
    vec4 colorR = Texel(texture, vec2(finalUV.x + rgbOffset, finalUV.y));
    vec4 colorG = Texel(texture, finalUV);
    vec4 colorB = Texel(texture, vec2(finalUV.x - rgbOffset, finalUV.y));
    
    vec4 fragColor = vec4(colorR.r, colorG.g, colorB.b, 1.0);
    
    // Apply scanlines
    float scanline = sin(finalUV.y * scanlineCount * 3.14159 * 2.0) * 0.5 + 0.5;
    scanline = 1.0 - (scanline * scanlineIntensity);
    fragColor.rgb *= scanline;
    
    // Apply vignette (darker corners)
    float vignette = 1.0 - dot(dc, dc) * vignetteStrength;
    fragColor.rgb *= vignette;
    
    // Final color
    return fragColor * color;
}
