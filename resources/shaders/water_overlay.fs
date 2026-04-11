#ifndef GL_ES
#  define lowp
#endif

varying vec4 Color0;
varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform vec4 Ratio;
uniform lowp float Amount;

void main(void)
{
	vec2 newTexCoord = TexCoord0;
	
	newTexCoord.x += (0.001 / Ratio.x) * sin(
		(newTexCoord.x - Ratio.z) * 10.0 * Ratio.x +
		(newTexCoord.y - Ratio.w) * 100.0 * Ratio.y +
		Amount * 6.28318530718
	);
	gl_FragColor = texture2D(Texture0, newTexCoord.xy) * Color0;
}
