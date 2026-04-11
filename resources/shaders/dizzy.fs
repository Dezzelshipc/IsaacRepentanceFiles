#ifndef GL_ES
#  define lowp
#endif

varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform vec2 TextureSize;
uniform vec4 Ratio;
uniform lowp float Time;
uniform lowp float Amount;

vec2 mirrorclamp(vec2 uv, vec2 m)
{
	return uv + max(vec2(0.0, 0.0), -2.0 * uv) + min(vec2(0.0, 0.0), -2.0 * (uv - m));
}

void main(void)
{
	float time = Time * 6.28318530718;
	float amount = Amount;
	float am2 = pow(amount, 0.5);
	
	float rot = amount * 0.3 * cos(0.8 * time);
	mat2 rmat = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
	
	vec2 center = 0.5 * TextureSize.xy;
	vec2 texcoord = rmat * (TexCoord0 - center) + center;
	
	vec2 amp = amount * vec2(0.016, 0.016) / Ratio.xy;
	vec2 freq = vec2(8.0, 12.0);
	float speed = 1.0;
	vec2 uv = mirrorclamp(texcoord + amp * sin(freq * 3.141593 * Ratio.xy * (TexCoord0.yx - Ratio.wz) + speed*time), TextureSize.xy);
	
	float mul = 1.0 + am2 * 0.6;
	float saturate = min(amount, 1.0) * 0.7;
	float exponent = 1.0 + pow(amount, 5.0) * 100.0;
	vec3 colorAdd = min(am2, 1.0) * (0.16 + 0.1 * sin(vec3(0.0, 1.0, 2.0) + vec3(0.4, 0.5, 0.6) * time));
	
	gl_FragColor = vec4(mul * (pow(saturate + colorAdd + texture2D(Texture0, uv).xyz, vec3(exponent, exponent, exponent))), 1.0);
}
