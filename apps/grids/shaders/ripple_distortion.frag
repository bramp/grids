// Ripple distortion shader — displaces UV coordinates radially to simulate
// concentric waves warping the underlying image.

#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;   // viewport width, height
uniform float uProgress;    // 0 → 1 normalised animation time
uniform float uWaveCount;   // number of staggered wave rings
uniform float uAmplitude;    // distortion strength (default 0.06)
uniform float uWaveSpacing;  // time delay between successive waves (default 0.18)
uniform float uWaveDecay;    // per-wave amplitude multiplier (default 0.65)
uniform vec3 uColor;        // accent RGB (0–1)

uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    vec2 center = vec2(0.5, 0.5);

    // Aspect-correct distance so the ripple is circular on non-square screens.
    vec2 aspect = vec2(uResolution.x / uResolution.y, 1.0);
    float dist = length((uv - center) * aspect);
    float maxDist = length(vec2(0.5, 0.5) * aspect);

    // Overshoot so the ease-out wave comfortably reaches every corner
    // before its amplitude decays to nothing.
    float travelDist = maxDist * 1.3;

    // Accumulate displacement and glow across all wave fronts.
    float displacement = 0.0;
    float glow = 0.0;

    for (float i = 0.0; i < 8.0; i += 1.0) {
        if (i >= uWaveCount) break;

        float delay = 0.02 + i * uWaveSpacing;
        if (uProgress <= delay) continue;

        float t = clamp((uProgress - delay) / (1.0 - delay), 0.0, 1.0);

        // Ease-out expansion.
        float eased = 1.0 - pow(1.0 - t, 3.0);
        float waveRadius = eased * travelDist;

        // Signed distance to the wave front.
        float waveDist = dist - waveRadius;

        // Wave band width — wide enough for a visible warp zone.
        float waveWidth = 0.15 * (1.0 - t * 0.5);

        if (abs(waveDist) < waveWidth) {
            // Sinusoidal displacement: naturally pushes outward on the leading
            // edge and pulls inward on the trailing edge.
            float wave = sin(waveDist / waveWidth * 3.14159265);
            float decay = (1.0 - t * 0.6) * pow(uWaveDecay, i);

            // Attenuate near centre — waves compress into fewer pixels there,
            // making the warp look disproportionately strong.
            float radialAtten = smoothstep(0.0, 0.25, waveRadius / maxDist);

            displacement += wave * uAmplitude * decay * radialAtten;

            // Subtle colored glow band (envelope uses abs for brightness).
            float envelope = cos(waveDist / waveWidth * 3.14159265) * 0.5 + 0.5;
            glow += envelope * 0.2 * decay * radialAtten;
        }
    }

    // Displace UV radially from centre.
    vec2 dir = (dist > 0.001) ? normalize((uv - center) * aspect) : vec2(0.0);
    // Convert direction back from aspect-corrected space.
    dir /= aspect;
    vec2 distortedUV = clamp(uv + dir * displacement, 0.0, 1.0);

    // Sample the captured scene.
    vec4 texColor = texture(uTexture, distortedUV);

    // Centre flash (first 12% of animation).
    float flash = 0.0;
    if (uProgress < 0.12) {
        float ft = uProgress / 0.12;
        float r = dist / maxDist;
        flash = 0.25 * (1.0 - ft) * smoothstep(0.3, 0.0, r);
    }

    // Composite: original + glow tint + white flash.
    vec3 glowVec = uColor * glow;
    fragColor = vec4(texColor.rgb + glowVec + vec3(flash), texColor.a);
}
