#version 450

// inputs
in vec3 pos;
in vec2 uv;
in vec3 norm;

// outputs
out vec4 fragColour;

void main() {
    fragColour = vec4(norm, 1.0);
}
