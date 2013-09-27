#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;
uniform sampler2D u_overlayTexture;

void main()
{
    vec4 normalColor = texture2D(u_texture, v_texCoord).rgba;
    vec4 maskColor = texture2D(u_overlayTexture, v_texCoord).rgba;
    gl_FragColor = vec4(maskColor.r, maskColor.g, maskColor.b, normalColor.a);
    
}