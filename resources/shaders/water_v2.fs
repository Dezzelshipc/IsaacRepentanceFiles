#ifndef GL_ES
#  define lowp
#endif

varying lowp vec4 Color0;
varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform float Time;
uniform vec3 ColorMul;
uniform vec2 CurrentDir;
uniform lowp vec2 TextureSize;
uniform lowp float PixelationAmount;

vec2 waterGradientRadial(vec2 uv, float time, vec2 origin, float amp, float freq, float speed, float exponent)
{
	//vec2 pos = (uv - origin) * vec2(0.7, 1.0);
	//vec2 pos = (uv - origin) * vec2(1.0, 0.7);
	vec2 pos = (uv - origin);
	vec2 d = -normalize(pos);
	return vec2(
		exponent * d.x * amp * pow(0.5 * (sin(dot(d, pos) * freq + time * speed) + 1.0), exponent - 1.0)
			* cos(dot(d, pos) * freq + time * speed),
		exponent * d.y * amp * pow(0.5 * (sin(dot(d, pos) * freq + time * speed) + 1.0), exponent - 1.0)
			* cos(dot(d, pos) * freq + time * speed)
	);
}

vec2 waterGradientLinear(vec2 uv, float time, vec2 dir, float amp, float freq, float speed, float exponent)
{
	vec2 pos = uv * vec2(1.8, 1.0);
	vec2 spd = speed * vec2(1.0, 1.4);
	return vec2(
		exponent * dir.x * amp * pow(0.5 * (sin(dot(dir, pos) * freq + time * spd.x) + 1.0), exponent - 1.0)
			* cos(dot(dir, pos) * freq + time * spd.x),
		exponent * dir.y * amp * pow(0.5 * (sin(dot(dir, pos) * freq + time * spd.y) + 1.0), exponent - 1.0)
			* cos(dot(dir, pos) * freq + time * spd.y)
	);
}

void main()
{	
	vec3 v = vec3(0.0, 0.0, 1.0);
	vec3 l = normalize(vec3(-1.0, -1.0, -1.0));
	vec3 h = normalize(l-v);
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmount, 1.0+PixelationAmount) / TextureSize;
	vec2 tc = PixelationAmount > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0;
	
	vec2 gradientSum =
	-	waterGradientRadial(tc, Time, vec2(-0.1, 0.15), 0.12, 80.0, 0.05, 1.4)
	-	waterGradientRadial(tc, Time, vec2(1.0, 0.3)  , 0.12, 290.0, 0.04, 1.4)
	-	waterGradientRadial(tc, Time, vec2(0.5, -0.2) , 0.12, 120.0, 0.04, 1.4)
	-	waterGradientRadial(tc, Time, vec2(0.3, 1.0)  , 0.12, 240.0, 0.04, 1.4);
	
	if(CurrentDir.x != 0.0 || CurrentDir.y != 0.0)
	{
		gradientSum *= 0.5;
		gradientSum -= waterGradientLinear(tc, Time, -CurrentDir, 0.3, 100.0, 0.3, 1.4);
		gradientSum -= waterGradientLinear(tc, Time, vec2(CurrentDir.y, CurrentDir.x), 0.12, 600.0, 0.0, 1.0);
	}
	
	vec3 n = normalize(vec3(gradientSum, -1.0));
	
	vec3 ref = refract(v, n, 1.08);
	float fresnel = dot(v, n);
	
	float spec = 0.04 * step(0.005, pow(dot(n, h), 160.0));
	
	fresnel = (1.0 + fresnel) * 2.0;
	
	vec4 color = texture2D(Texture0, tc + 0.1 * ref.xy);
	gl_FragColor = vec4((mix(color.xyz/color.a, Color0.xyz, Color0.a - fresnel) + vec3(spec, spec, spec)) * ColorMul * color.a, color.a);
	
	// Color reduction
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0), clamp(PixelationAmount, 0.0, 1.0));
}
