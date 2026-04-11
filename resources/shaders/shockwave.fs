varying vec4 Color0;
varying vec2 TexCoord0;

uniform sampler2D Texture0;

uniform vec4 Shockwave1;
uniform vec4 Shockwave2;
uniform vec2 Ratio;

void main(void)
{
	vec2 newTexCoord = TexCoord0;
	float distance1 = length((TexCoord0.st - Shockwave1.xy) * Ratio);
	float time1 = Shockwave1.z;
	bool combine = false;
	if (Shockwave1.x > -100.0 && distance1 <= time1 + 0.05 && distance1 >= time1 - 0.05) {
		float diff = (distance1 - time1);
		float powDiff = 1.0-pow(abs(diff*20.0), 0.8);
		vec2 diffUV = normalize((TexCoord0.st - Shockwave1.xy) * Ratio);
		newTexCoord = TexCoord0.st + (diffUV * powDiff * Shockwave1.a) / Ratio;
		combine = true;
	}
	float distance2 = length((TexCoord0.st - Shockwave2.xy) * Ratio);
	float time2 = Shockwave2.z;
	if (Shockwave2.x > -100.0 && distance2 <= time2 + 0.05 && distance2 >= time2 - 0.05) {
		float diff = (distance2 - time2);
		float powDiff = 1.0-pow(abs(diff*20.0), 0.8);
		vec2 diffUV = normalize((TexCoord0.st - Shockwave2.xy) * Ratio);
		vec2 calcCoord = TexCoord0.st + (diffUV * powDiff * Shockwave2.a) / Ratio;
		if (combine)
			newTexCoord = (calcCoord + newTexCoord) * 0.5;
		else
			newTexCoord = calcCoord;
	}
	gl_FragColor = texture2D(Texture0, newTexCoord.st) * Color0;
}
