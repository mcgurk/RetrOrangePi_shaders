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

    void main(void) {
        float column = gl_TexCoord[0].s * rubyTextureSize.x;
        float line = gl_TexCoord[0].t * rubyTextureSize.y;
        float dx = mod(column, 2.0);
        float dy = mod(line, 2.0);

        vec2 texel;
        texel.x = gl_TexCoord[0].s - dx/rubyTextureSize.x + 1.0/rubyTextureSize.x/2.0;
        texel.y = gl_TexCoord[0].t - dy/rubyTextureSize.y + 1.0/rubyTextureSize.y/2.0;
        vec4 rgb = texture2D(rubyTexture, gl_TexCoord[0].st);
        vec4 rgb2 = texture2D(rubyTexture, gl_TexCoord[0].st + vec2(-1.0 / rubyTextureSize.x, 0));
        vec4 rgb3 = texture2D(rubyTexture, gl_TexCoord[0].st + vec2(+1.0 / rubyTextureSize.x, 0));
        vec4 rgb4 = texture2D(rubyTexture, gl_TexCoord[0].st + vec2(-2.0 / rubyTextureSize.x, 0));

		float l = (rgb.r + rgb.g + rgb.b) / 3.0;
		l = l / 4.0;
		
		//scanlines
		float ety = abs((dy-1.0)*1.6); //last multiplier is more or less height of scanline
        float dimy = 1.0 - pow(ety*0.8, 0.4);
        dimy = dimy + 0.5 + l;
        dimy = clamp(dimy, 0.4, 1.0);
        
		//very very discreet gap between horizontal pixels
		float etx = abs((dx-0.5)*0.05);
        float dimx = 1.0 - pow(etx, 1.4);
		dimx = dimx + 0.4;
        //dimx = clamp(dimx, 0.4, 1.5);

		//float dim = dimy;
		float dim = (dimx + dimy) / 2.2;
		
        vec4 tex;
        tex = mix(rgb, mix(mix(rgb2, rgb4, 0.4), rgb3, 0.3), 0.5);
        gl_FragColor = vec4(dim, dim, dim, 1.0) * tex;
    }
    
	]]></fragment>
</shader>