#version 450

in vec3 position;
in vec3 normal;

// camera uniforms
uniform mat4 MVP;
uniform mat4 M;

// material uniforms
uniform vec3 albedoColour;
uniform vec3 ambientColour;

// outputs
out vec3 pos;
out vec3 norm;
out vec3 col;

void main() {
    // transform position to world space
    pos = (M * vec4(position, 1.0)).xyz;

    // transform normals into world space
    norm = (M * vec4(normal, 0.0)).xyz;

    // interpolate colour
    col = albedoColour * ambientColour;

    // set the camera-space position of the vertex
    gl_Position = MVP * vec4(position, 1.0);
}
