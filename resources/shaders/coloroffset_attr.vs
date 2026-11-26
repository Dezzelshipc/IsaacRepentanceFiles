//
// Same thing as coloroffset.vs except Colorize and ColorOffset are attributes instead of uniforms (for things that need per-vertex colors)
//

#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec3 Position;
in vec4 Color;
in vec2 TexCoord;
in vec4 InColorize;
in vec3 InColorOffset;

out vec4 Color0;
out vec2 TexCoord0;
out vec4 Colorize;
out vec3 ColorOffset;

#else

attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute vec4 InColorize;
attribute vec3 InColorOffset;

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 Colorize;
varying vec3 ColorOffset;

#endif

uniform mat4 ProjectionMatrix;

void main(void)
{
	gl_Position = ProjectionMatrix * vec4(Position.xyz, 1.0);
	Color0 = Color;
	TexCoord0 = TexCoord;
	Colorize = InColorize;
	ColorOffset = InColorOffset;
}
