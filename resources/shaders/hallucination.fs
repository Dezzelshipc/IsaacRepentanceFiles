varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform float Amount;
//uniform vec2 Noise;
uniform vec4 ScreenSize;

/*float random (vec2 st) {
	return fract(sin(dot(st.xy,
		vec2(12.9898,78.233)))*
		43758.5453123);
}*/

void main(void)
{
	vec2 screenRatio = ScreenSize.zw / ScreenSize.xy;
	vec2 screenUV = TexCoord0 * screenRatio;

	/*Vigneting*/
	vec2 vigUV = (screenUV - 0.5) * vec2(1.5, 1.0) * 2.0;
	float vignete = 1.0 - pow(clamp(length(vigUV) * 0.65, 0.0, 1.0), 5.0) * 0.9;

	vec4 origColor = texture2D(Texture0, TexCoord0);
	/*Small bloom*/
	int i, j;
	vec4 sum = vec4(0);
	for(i = -1; i <= 1; i++) {
		for (j = -1; j <= 1; j++) {
			vec4 col = texture2D(Texture0, TexCoord0 + vec2(i, j) * 3.0 / ScreenSize.zw);
			sum += col * col * 0.13;
		}
	}
	vec4 color = origColor + sum;
	color.a = origColor.a;
	/*Desaturate + Sepia*/
	color.rgb = vec3(dot(vec3(0.2126,0.7152,0.0722), color.rgb));
	color.rgb *= vec3(1.1, 1.0, 0.9);
	color.rgb *= vignete;
	vec4 finalColor = mix(origColor, color, Amount);
	/*Apply noise*/
	//finalColor.rgb = mix(finalColor.rgb, vec3(random(TexCoord0 * (Noise.y * 100.0))), Noise.x);
	gl_FragColor = finalColor;
}
