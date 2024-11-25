#ifndef GL_ES
#  define lowp
#endif

attribute vec3 Position;
attribute vec2 TexCoord;
attribute vec2 TextureSize;
attribute vec4 Ratio;
attribute float Time;
attribute float Amount;

varying vec2 TexCoord0;
varying vec2 TextureSize0;
varying vec4 Ratio0;
varying lowp float Time0;
varying lowp float Amount0;

uniform mat4 Transform;

void main()
{
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
	TextureSize0 = TextureSize;
	Ratio0 = Ratio;
	Time0 = Time;
	Amount0 = Amount;
}
