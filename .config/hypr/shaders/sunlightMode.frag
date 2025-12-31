#version 300 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // Contrast boost
    float contrast = 1.25;
    color.rgb = (color.rgb - 0.5) * contrast + 0.5;

    // Slight brightness lift
    color.rgb += 0.04;

    // Mild gamma correction
    color.rgb = pow(color.rgb, vec3(1.0 / 1.08));

    fragColor = color;
}
