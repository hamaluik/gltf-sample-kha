#version 450

in vec3 position;
in vec2 texcoord;
in vec3 normal;

// camera uniforms
uniform mat4 MVP;
uniform mat4 M;

// outputs
out vec3 pos;
out vec2 uv;
out vec3 norm;

void main() {
    pos = (M * vec4(position, 1.0)).xyz;
    uv = texcoord;
    norm = (M * vec4(normal, 1.0)).xyz;

    gl_Position = MVP * vec4(position, 1.0);
}
