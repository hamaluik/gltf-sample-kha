#version 450

// inputs
in vec3 pos;
in vec3 norm;
in vec3 col;

// directional lights
struct SDirectionalLight {
    vec3 direction;
    vec3 colour;
};
uniform SDirectionalLight directionalLights[1];

// point lights
struct SPointLight {
    vec3 position;
    vec3 colour;
    float distance;
};
uniform SPointLight pointLights[3];

// material uniforms
uniform vec3 albedoColour;
uniform vec3 ambientColour;

// outputs
out vec4 fragColour;

void main() {
    vec3 colour = col;

    // apply directional lights
	float dLight0 = clamp(dot(norm, directionalLights[0].direction), 0.0, 1.0);
    colour += directionalLights[0].colour * dLight0 * albedoColour;

    // apply point lights
    for(int i = 0; i < 3; i++) {
        vec3 pLightDir = pointLights[i].position - pos;
        float pDist = length(pLightDir);
        float pLight = clamp(dot(norm, pLightDir), 0.0, 1.0) * pointLights[i].distance / (pDist * pDist);
        colour += pointLights[i].colour * pLight * albedoColour;
    }

    // output!
    fragColour = vec4(colour, 1.0);
}
