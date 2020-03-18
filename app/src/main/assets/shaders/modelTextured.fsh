/*
 *    Copyright 2020 Seungmo Kang
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

precision mediump float; // required in GLSL ES 1.00

varying vec2      textureCoords;
uniform sampler2D textureSampler;
varying float lightIntensity;
varying float normalDotLight;
varying vec3 fragColour_spec;
varying vec3 v_Position;        // Interpolated position for this fragment.
//varying vec4 v_Color;           // This is the color from the vertex shader interpolated across the
// triangle per fragment.
varying vec3 v_Normal;          // Interpolated normal for this fragment.
void main()
{
    float ambientStrength = 0.0;
    vec3 lightColor = vec3(1.0, 1.0, 1.0);
    vec3 ambient = ambientStrength * lightColor;
    vec3 result;
    ambientStrength = lightIntensity;
    if(lightIntensity > 0.9){
        result = texture2D( textureSampler, textureCoords ).xyz;
    }
    else
    {
        float d = 0.5;
        //hardcoded light position
        vec3 u_LightPos = vec3(-0.5*d, 0.5*d, 0.5*d);
        float distance = length(u_LightPos - v_Position);
        // Get a lighting direction vector from the light to the vertex.
        vec3 lightVector = normalize(u_LightPos - v_Position);
        // Calculate the dot product of the light vector and vertex normal. If the normal and light vector are
        // pointing in the same direction then it will get max illumination.
        float diffuse = max(dot(v_Normal, lightVector), 0.0);

        // Attenuate the light based on distance.
        diffuse = diffuse * (1.0 / (1.0 + (0.0025*distance*distance)));

        // Add ambient lighting
        diffuse = diffuse + 0.05;

        vec3 fragColour = vec3(0.1, 0.1, 0.1);
        vec3 vertexDiffuseReflectionConstant = texture2D( textureSampler, textureCoords ).xyz;
        vec3 diffuseLightIntensity = vec3(1.0, 1.0, 1.0);
        fragColour +=  diffuse*vertexDiffuseReflectionConstant * diffuseLightIntensity;
        

        fragColour += fragColour_spec;
        result= fragColour;
    }



    gl_FragColor.xyz = result.xyz; //texture2D( textureSampler, textureCoords ).xyz;
}
