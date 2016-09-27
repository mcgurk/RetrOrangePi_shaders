#if defined(VERTEX)

#if __VERSION__ >= 130
#define COMPAT_VARYING out
#define COMPAT_ATTRIBUTE in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying 
#define COMPAT_ATTRIBUTE attribute 
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif
COMPAT_VARYING     float _frame_rotation;

struct input_dummy {
    vec2 _video_size;
    vec2 _texture_size;
    vec2 _output_dummy_size;
    float _frame_count;
    float _frame_direction;
    float _frame_rotation;
};

COMPAT_ATTRIBUTE vec4 VertexCoord;
COMPAT_ATTRIBUTE vec4 COLOR;
COMPAT_VARYING vec4 COL0;
COMPAT_ATTRIBUTE vec4 TexCoord;
COMPAT_VARYING vec4 TEX0;
 
uniform mat4 MVPMatrix;
uniform int FrameDirection;
uniform int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;

void main() {
  gl_Position = VertexCoord.x*MVPMatrix[0] + VertexCoord.y*MVPMatrix[1] + VertexCoord.z*MVPMatrix[2] + VertexCoord.w*MVPMatrix[3];
  TEX0.xy = TexCoord.xy;
} 

#elif defined(FRAGMENT)

#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
out vec4 FragColor;
#else
#define COMPAT_VARYING varying
#define FragColor gl_FragColor
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif
COMPAT_VARYING     float _frame_rotation;

struct input_dummy {
    vec2 _video_size;
    vec2 _texture_size;
    vec2 _output_dummy_size;
    float _frame_count;
    float _frame_direction;
    float _frame_rotation;
};

float _TMP2;
float _TMP1;
uniform sampler2D Texture;
input_dummy _IN1;
COMPAT_VARYING vec4 TEX0;
 
uniform int FrameDirection;
uniform int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;


void main() {

  vec3 col;
  float x = floor(gl_FragCoord.x / 3.0) + 0.5;
  float y = floor(gl_FragCoord.y / 3.0) + 0.5;
  float xmod = mod(gl_FragCoord.x, 3.0);
  float ymod = mod(gl_FragCoord.y, 3.0);
  vec2 f0 = vec2(x, y);
  vec2 uv0 = f0 / TextureSize.xy;
  float p = 1.0;
  vec3 t0 = COMPAT_TEXTURE(Texture, uv0).xyz;
  if (ymod > 2.0) {
    vec2 f1 = vec2(x, y + 1.0);
    vec2 uv1 = f1 / TextureSize.xy;
    vec3 t1 = COMPAT_TEXTURE(Texture, uv1).xyz;
    if (xmod > 2.0) p = 0.8;
    col = (t0 + t1) / 2.0 * 0.6 * p;
  } else {
    if (xmod > 2.0) {
      vec2 f1 = vec2(x + 1.0, y);
      vec2 uv1 = f1 / TextureSize.xy;
      vec3 t1 = COMPAT_TEXTURE(Texture, uv1).xyz;
      col = (t0 + t1) / 2.0 * 1.0;//0.95;
    } else col = t0;
  } 
  FragColor = vec4( col, 1.0 );

}


#endif
