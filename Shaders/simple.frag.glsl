#version 450

// inputs
in vec3 pos;
in vec3 norm;

// outputs
out vec4 fragColour;

void main() {
    vec3 colour = vec3(0.0, 0.0, 0.0);

    // direction light 0
	/*float dLight0 = clamp(dot(norm, vec3(0, 0.70710678118, 0.70710678118)), 0.0, 1.0);
    colour += vec3(1.0, 1.0, 1.0) * dLight0 * vec3(0.0, 1.0, 0.0);*/

    /*vec3 pLightDir = vec3(0.0, 2.0, 2.0) - pos;
    float pDist = length(pLightDir);
    float pLight = clamp(dot(norm, pLightDir), 0.0, 1.0) * 2 / (pDist * pDist);
    colour += vec3(1.0, 1.0, 1.0) * pLight * vec3(0.8, 0.8, 0.8);*/

    // output!
    fragColour = vec4(norm, 1.0);
}
