varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform float Exposure;
uniform float Gamma;

void main(void)
{
	gl_FragColor = texture2D( Texture0, TexCoord0 );
	vec4 Exposed = gl_FragColor * Exposure;
	vec4 FinalColor = pow(clamp(Exposed, 0.0, 1.0), vec4(Gamma));
	gl_FragColor.rgb = FinalColor.rgb;
}
