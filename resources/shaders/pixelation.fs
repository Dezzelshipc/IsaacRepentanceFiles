#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec2 TexCoord0;
out vec4 fragColor;

#else

varying vec2 TexCoord0;
#define fragColor gl_FragColor
#define texture texture2D

#endif

uniform sampler2D Texture0;

uniform float PixelationAmount;
uniform vec4 ScreenSize;

void main(void)
{
	vec2 pa = PixelationAmount * 0.5 * min(ScreenSize.z, ScreenSize.w) / ScreenSize.zw;
	//vec2 snapCoord = TexCoord0.st - mod(TexCoord0.st, pa) + pa * 0.5;
	
	// Centered pixelation
	// This is less faithful to the SNES mosaic effect but it looks better overall
	vec2 center = ScreenSize.xy * 0.5 / ScreenSize.zw;
	vec2 snapCoord = TexCoord0.st - mod(TexCoord0.st - center, pa) + pa * 0.5;
	
	fragColor = texture(Texture0, snapCoord);
}
