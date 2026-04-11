#ifndef GL_ES
#  define lowp
#  define mediump
#endif

varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;

uniform sampler2D Texture0;

uniform vec4	Colorize;
uniform vec3	ColorOffset;
uniform vec2	TextureSize;
uniform float	PixelationAmount;
uniform vec3	ClipPlane;

const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

float cubic(float x, float a1, float b1, float a2, float b2, float xt)
{
	return x < xt ? (a1*pow(x,3.0)+b1*x) : (a2*pow(x-1.0,3.0)+b2*(x-1.0)+1.0);
}

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlane.xy) < ClipPlane.z)
		discard;
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmount, 1.0+PixelationAmount) / TextureSize;
	vec4 Color = Color0 * texture2D(Texture0, PixelationAmount > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);

	if( Color.a == 0.0 )	discard;
	
	//Color.rgb = dot(Color.rgb, _lum) * vec3(1.0, 1.0, 1.0);
	//Color.rgb = clamp((Color.rgb - vec3(0.6, 0.6, 0.6)) * 1.4 + vec3(0.5, 0.5, 0.5), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
	
	float t = Colorize.a*10.0*3.1415926535 + 3.1415926535*(TexCoord0.x * (TextureSize.x / TextureSize.y) + TexCoord0.y);
	t = 1.0-pow(max(0.0,sin(t)), 20.0)-sin(t)/4.0;
	Color.rgb = clamp(Color.rgb * vec3(2.0 - t, 1.8 - t, 1.0 - t) + step(-dot(Color.rgb, _lum), -0.007)*(-0.2*t+0.2)*vec3(1.0,1.0,1.0), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
	
	Color.r = clamp(cubic(Color.r, -6.52644, 3.05795, 1.36096, -0.320444, 0.172549), 0.0, 1.0);
	Color.g = clamp(cubic(Color.g, -1.65228, 2.07291, 1.138, 0.0512927, 0.407843), 0.0, 1.0);
	Color.b = clamp(cubic(Color.b, 4.86766, -3.82087, -44.7824, 9.35043, 0.901961), 0.0, 1.0);
	
	//vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * vec3(1.0,1.0,0.0), 1.0);
	vec3 Colorized = Color.rgb;
	gl_FragColor = vec4(Colorized + ColorOffset * Color.a, Color.a);
	
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmount, 0.0, 1.0));
}

