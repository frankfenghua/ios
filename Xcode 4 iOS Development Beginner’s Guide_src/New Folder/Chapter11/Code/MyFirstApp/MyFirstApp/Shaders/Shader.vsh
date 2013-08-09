//
//  Shader.vsh
//  MyFirstApp
//
//  Created by Steven F Daniel on 16/03/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
