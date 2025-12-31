#version 300 es

precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

void main() {

    vec4 pixColor = texture(tex, v_texcoord);

    float brightness = -0.05;
    float contrast = 1.1;

    pixColor.rgb = (pixColor.rgb - 0.5) * contrast + 0.5;
    pixColor.rgb += brightness;

    fragColor = pixColor;
}
