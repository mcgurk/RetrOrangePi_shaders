<?xml version="1.0" encoding="UTF-8"?>
<!--
    CRT shader

    Copyright (C) 2014 kurg, SKR!

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the Free
    Software Foundation; either version 2 of the License, or (at your option)
    any later version.
    -->
<shader language="GLSL">

<vertex><![CDATA[

void main(void) {
    gl_Position = ftransform();
    gl_TexCoord[0] = gl_MultiTexCoord0;
}

]]></vertex>

<fragment><![CDATA[
	uniform sampler2D rubyTexture;
	uniform vec2 rubyTextureSize;

    #define ILLUMASPECT  2.4
	#define DIST(dx, dy)  clamp((2.0 - sqrt(dx*dx+(dy*ILLUMASPECT)*(dy*ILLUMASPECT))) / 2.0, 0.0, 1.0)
    #define ATT(dx, dy)   DIST(dx, pow(dy, 1.3) * 0.6)
	
    void main(void) {
		//rubyTextureSize = vec2(320,400);
		rubyTextureSize.x = rubyTextureSize.x / 1.0; rubyTextureSize.y = rubyTextureSize.y / 2.0;
        float column = gl_TexCoord[0].s * rubyTextureSize.x;
        float line = gl_TexCoord[0].t * rubyTextureSize.y;
        float dx1 = fract(column);
        float dy1 = fract(line);
        
        vec2 texel;
        texel.x = gl_TexCoord[0].s - dx1/rubyTextureSize.x + 1.0/rubyTextureSize.x/2.0;
        texel.y = gl_TexCoord[0].t - dy1/rubyTextureSize.y + 1.0/rubyTextureSize.y/2.0;
        vec4 rgb1 = texture2D(rubyTexture, texel.xy);
        vec4 rgb2 = texture2D(rubyTexture, vec2(texel.s + 1.0/rubyTextureSize.x, texel.t));
        vec4 rgb3 = texture2D(rubyTexture, vec2(texel.s, texel.t + 1.0/rubyTextureSize.y));
        vec4 rgb4 = texture2D(rubyTexture, vec2(texel.s + 1.0/rubyTextureSize.x, texel.t + 1.0/rubyTextureSize.y));

        vec4 rgb5 = texture2D(rubyTexture, vec2(texel.s - 1.0/rubyTextureSize.x, texel.t - 1.0/rubyTextureSize.y));
        vec4 rgb6 = texture2D(rubyTexture, vec2(texel.s + 0.0/rubyTextureSize.x, texel.t - 1.0/rubyTextureSize.y));
        vec4 rgb7 = texture2D(rubyTexture, vec2(texel.s + 1.0/rubyTextureSize.x, texel.t - 1.0/rubyTextureSize.y));
        vec4 rgb8 = texture2D(rubyTexture, vec2(texel.s + 2.0/rubyTextureSize.x, texel.t - 1.0/rubyTextureSize.y));

        vec4 rgb9 = texture2D(rubyTexture, vec2(texel.s - 1.0/rubyTextureSize.x, texel.t + 0.0/rubyTextureSize.y));
        vec4 rgb10 = texture2D(rubyTexture, vec2(texel.s + 2.0/rubyTextureSize.x, texel.t + 0.0/rubyTextureSize.y));
        vec4 rgb11 = texture2D(rubyTexture, vec2(texel.s - 1.0/rubyTextureSize.x, texel.t + 1.0/rubyTextureSize.y));
        vec4 rgb12 = texture2D(rubyTexture, vec2(texel.s + 2.0/rubyTextureSize.x, texel.t + 1.0/rubyTextureSize.y));

        vec4 rgb13 = texture2D(rubyTexture, vec2(texel.s - 1.0/rubyTextureSize.x, texel.t + 2.0/rubyTextureSize.y));
        vec4 rgb14 = texture2D(rubyTexture, vec2(texel.s + 0.0/rubyTextureSize.x, texel.t + 2.0/rubyTextureSize.y));
        vec4 rgb15 = texture2D(rubyTexture, vec2(texel.s + 1.0/rubyTextureSize.x, texel.t + 2.0/rubyTextureSize.y));
        vec4 rgb16 = texture2D(rubyTexture, vec2(texel.s + 2.0/rubyTextureSize.x, texel.t + 2.0/rubyTextureSize.y));

        mat4 dist;
        dist[0][0] = DIST(dx1, dy1);
        dist[0][1] = DIST((1.0 - dx1), dy1);
        dist[0][2] = DIST(dx1, (1.0 - dy1));
        dist[0][3] = DIST((1.0 - dx1), (1.0 - dy1));
        
        dist[1][0] = DIST((1.0 + dx1), (1.0 + dy1));
        dist[1][1] = DIST((0.0 + dx1), (1.0 + dy1));
        dist[1][2] = DIST((1.0 - dx1), (1.0 + dy1));
        dist[1][3] = DIST((2.0 - dx1), (1.0 + dy1));

        dist[2][0] = DIST((1.0 + dx1), dy1);
        dist[2][1] = DIST((2.0 - dx1), dy1);
        dist[2][2] = DIST((1.0 + dx1), (1.0 - dy1));
        dist[2][3] = DIST((2.0 - dx1), (1.0 - dy1));

        dist[3][0] = DIST((1.0 + dx1), (2.0 - dy1));
        dist[3][1] = DIST((0.0 + dx1), (2.0 - dy1));
        dist[3][2] = DIST((1.0 - dx1), (2.0 - dy1));
        dist[3][3] = DIST((2.0 - dx1), (2.0 - dy1));

        vec4 tex1 = (rgb1*dist[0][0] + rgb2*dist[0][1] + rgb3*dist[0][2] + rgb4*dist[0][3]);
        vec4 tex2 = (rgb5*dist[1][0] + rgb6*dist[1][1] + rgb7*dist[1][2] + rgb8*dist[1][3]);
        vec4 tex3 = (rgb9*dist[2][0] + rgb10*dist[2][1] + rgb11*dist[2][2] + rgb12*dist[2][3]);
        vec4 tex4 = (rgb13*dist[3][0] + rgb14*dist[3][1] + rgb15*dist[3][2] + rgb16*dist[3][3]);

        vec4 tex = (tex1 + tex2 + tex3 + tex4 + ((rgb9+rgb11)/2.0)*0.3) / 2.0;
        gl_FragColor = vec4(tex.rgb, 1.0);
    }
	
	// +-------------------+
	// | 05 | 06 | 07 | 08 |
	// +-------------------+
	// | 09 | 01 | 02 | 10 |
	// +-------------------+
	// | 11 | 03 | 04 | 12 |
	// +-------------------+
	// | 13 | 14 | 15 | 16 |	
	// +-------------------+    
	
	]]></fragment>
</shader>