//
//  Shader.fsh
//  MyFirstApp
//
//  Created by Steven F Daniel on 16/03/11.
//  Copyright 2011 GenieSoft Studios. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
