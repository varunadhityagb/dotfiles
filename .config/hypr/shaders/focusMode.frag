#version 300 es

precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

void main() {

    vec4 pixColor = texture(tex, v_texcoord);

    float gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));
    pixColor.rgb = vec3(gray);

    fragColor = pixColor;
}
