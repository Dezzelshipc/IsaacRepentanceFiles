attribute vec3 Position;
attribute vec2 TexCoord;

varying vec2 TexCoord0;

uniform mat4 ProjectionMatrix;

void	main( void )
{
	gl_Position = ProjectionMatrix * vec4( Position.xyz, 1.0 );
	TexCoord0 = TexCoord;
}
