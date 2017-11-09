#version 450

// inputs
in vec3 pos;
in vec2 uv;
in vec3 norm;

uniform sampler2D albedoTex;

// outputs
out vec4 fragColour;

void main() {
    vec3 colour = vec3(0.1, 0.1, 0.1);

    float dLight0 = clamp(dot(norm, vec3(0, 0.70710678118, 0.70710678118)), 0.0, 1.0);
    colour += dLight0;

    vec4 outColour = vec4(colour, 1.0);
    outColour *= texture(albedoTex, uv);

    // gamma
    fragColour = vec4(pow(outColour.rgb, vec3(1.0/2.2)), outColour.a);
}
