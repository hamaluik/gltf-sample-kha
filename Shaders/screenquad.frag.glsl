#version 450

in vec2 uv;
uniform sampler2D tex;

out vec4 fragColour;

void main() {
    vec4 tc = texture(tex, uv);
    tc *= step(0.5, mod(gl_FragCoord.y, 2.0) - 1.0);
    fragColour = tc;
}
