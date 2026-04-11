varying vec4 Color0;
varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform float Amount;
uniform float Brightness;
uniform float Contrast;

const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

void main()
{
	//ColorizeOut = vec4(-1.2, -0.8, 0.0, -0.15);
	//ColorizeOut = vec4(0.0, 1.0, -1.0, -0.4); // downpour
	//BrightnessOut = -0.02;
	//ContrastOut = 0.9;
	
	vec4 color = texture2D(Texture0, TexCoord0);
	color.rgb = mix(color.rgb, dot(color.rgb, _lum) * Color0.rgb, Amount);
	color.rgb += vec3(Brightness, Brightness, Brightness);
	color.rgb = (color.rgb - vec3(0.5, 0.5, 0.5)) * Contrast + vec3(0.5, 0.5, 0.5);
	
	gl_FragColor = color;
}
