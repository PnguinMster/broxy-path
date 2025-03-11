// Adjustable parameters
const float scanlineIntensity = 0.2;
const float scanlineCount = 200.0;
const float vignetteStrength = 0.5;
const float curvature = 0.1; 
const float rgbOffset = 0.002;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Use texture_coords instead of calculating our own
    vec2 uv = texture_coords;
    
    // Apply screen curvature to UV coordinates
    vec2 curvedUV = uv * 2.0 - 1.0;  // -1 to 1
    curvedUV *= 1.0 + curvature * (curvedUV * curvedUV);
    curvedUV = curvedUV * 0.5 + 0.5;  // back to 0-1
    
    // If pixel is outside curved screen, make it black
    if (curvedUV.x < 0.0 || curvedUV.x > 1.0 || curvedUV.y < 0.0 || curvedUV.y > 1.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    }
    
    // Apply color channel separation/chromatic aberration
    vec4 baseColor = Texel(texture, curvedUV);
    vec4 colorR = Texel(texture, vec2(curvedUV.x + rgbOffset, curvedUV.y));
    vec4 colorB = Texel(texture, vec2(curvedUV.x - rgbOffset, curvedUV.y));
    
    vec4 fragColor = vec4(colorR.r, baseColor.g, colorB.b, baseColor.a);
    
    // Apply scanlines based on screen position
    float scanline = sin((screen_coords.y / love_ScreenSize.y) * scanlineCount * 3.14159 * 2.0) * 0.5 + 0.5;
    scanline = 1.0 - (scanline * scanlineIntensity);
    fragColor.rgb *= scanline;
    
    // Apply vignette (darker corners)
    vec2 vignetteUV = curvedUV * 2.0 - 1.0;
    float vignette = 1.0 - dot(vignetteUV, vignetteUV) * vignetteStrength;
    fragColor.rgb *= vignette;
    
    // Multiply by the input color to respect Love2D's color settings
    return fragColor * color;
}
