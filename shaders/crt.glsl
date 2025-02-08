#ifdef GL_ES
precision mediump float;
GLSL_VERSION 330
#endif

uniform float uTime;
uniform int uRes;
void main()
{
  vec2 uv = gl_FragCoord/uRes;

  gl_FragColor= vec4(uv.x,uv.y,0.0,1.0);
}
