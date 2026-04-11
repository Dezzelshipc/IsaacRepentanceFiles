//
// Same thing as coloroffset.fs except Colorize and ColorOffset are attributes instead of uniforms (for things that need per-vertex colors)
//

#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec4 Color0;
in vec2 TexCoord0;
in vec4 Colorize;
in vec3 ColorOffset;
out vec4 fragColor;

#else

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 Colorize;
varying vec3 ColorOffset;
#define fragColor gl_FragColor
#define texture texture2D

#endif

uniform sampler2D Texture0;

uniform vec2	TextureSize;
uniform float	PixelationAmount;
uniform vec3	ClipPlane;

const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

/*
void main(void)
{
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * Colorize.rgb, Colorize.a);
	gl_FragColor = vec4(Colorized + ColorOffset * Color.a, Color.a);
}
*/

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlane.xy) < ClipPlane.z)
		discard;
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmount, 1.0+PixelationAmount) / TextureSize;

	// vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	vec4 Color = Color0 * texture(Texture0, PixelationAmount > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	
	if( Color.a == 0.0 )	discard;
	
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * Colorize.rgb, Colorize.a);
	fragColor = vec4(Colorized + ColorOffset * Color.a, Color.a);
	
	fragColor.rgb = mix(fragColor.rgb, fragColor.rgb - mod(fragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmount, 0.0, 1.0));
}

/*
void main(void)
{
	// Pixelate
    ivec2 TexSize = textureSize(Texture0, 0);
	vec2 pa = vec2(2, 2) / vec2(TexSize);
	
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0 - mod(TexCoord0, pa) + pa * 0.5);
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * Colorize.rgb, Colorize.a);
	gl_FragColor = vec4(Colorized + ColorOffset * Color.a, Color.a);
	
	// Apply color reduction
	gl_FragColor.rgb = gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0);
}
*/
