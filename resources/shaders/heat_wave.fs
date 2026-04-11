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
	
	newTexCoord.y += (0.001 / Ratio.y) * sin(
		(newTexCoord.x - Ratio.z) * 50.0 * Ratio.x +
		(newTexCoord.y - Ratio.w) * 100.0 * Ratio.y +
		Amount * 6.28318530718 * 2.0
	);
	gl_FragColor = texture2D(Texture0, newTexCoord.xy) * Color0;
}
