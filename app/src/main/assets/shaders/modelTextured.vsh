/*
 *    Copyright 2016 Anand Muralidhar
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

// shader associated with AssimpLoader

attribute   vec3 vertexPosition;
attribute   vec2 vertexUV;
varying     vec2 textureCoords;
attribute   vec3 vertexNormal;
uniform     mat4 mvpMat;
uniform     float lightSwitch;
varying     float  lightIntensity;
varying     vec3 fragColour_spec;
varying     float normalDotLight;
varying     vec3 v_Position;
varying     vec3 v_Normal;
void main()
{
/* [Setup scene vectors.] */
    vec3 modelViewVertex = vec3(mvpMat * vec4(vertexPosition, 1.0));
    v_Position = modelViewVertex;
    //the front normal vector
    vec4  normalVec = vec4(1.0, 0, 0.0, 0.0);

    vec3 modelViewNormal = normalize((mvpMat * normalVec).xyz);

    v_Normal = modelViewNormal;
    vec3 inverseLightDirection = normalize(vec3(0.0, 1.0, 1.0));

    /* [Calculate the diffuse component.] */
    // normalDotLight variable is not used for rendering any more. Please ignore this variable.
    //In the fragment shader, diffuse variable is used instead.
    //normalDotLight = max(0.1, dot(modelViewNormal, inverseLightDirection));
    // Attenuate the light based on distance.
    // normalDotLight variable is not used for rendering any more. Please ignore this variable.
    //In the fragment shader, diffuse variable is used instead.
    //normalDotLight = normalDotLight * (1.0 / (1.0 + (0.000025 * distance * distance)));

/* [Calculate the specular component.] */
    vec3 inverseEyeDirection = normalize(vec3(0.0, 0.0, 1.0));
    vec3 specularLightIntensity = vec3(1.0, 1.0, 1.0);
    vec3 vertexSpecularReflectionConstant = vec3(1.0, 1.0, 1.0);
    float shininess = 3.0;
    vec3 lightReflectionDirection = reflect(vec3(0, 0, 0) - inverseLightDirection, modelViewNormal);
    float normalDotReflection = max(0.0, dot(inverseEyeDirection, lightReflectionDirection));
    fragColour_spec= (pow(normalDotReflection, shininess) * vertexSpecularReflectionConstant * specularLightIntensity).xyz;

    lightIntensity = lightSwitch;
    gl_Position     = mvpMat * vec4(vertexPosition, 1.0);
    textureCoords   = vertexUV;
}
