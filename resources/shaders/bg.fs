varying vec4 Color0;
varying vec2 TexCoord0;

uniform sampler2D Texture0;
uniform vec2 WrapSize;

vec2 wrapx(vec2 uv, vec2 m)
{
	return uv + floor(uv / m) * (vec2(1.0, 1.0) - m);
}

void main(void)
{
	gl_FragColor = texture2D(Texture0, wrapx(TexCoord0, WrapSize)) * Color0;
}
