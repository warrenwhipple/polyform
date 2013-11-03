//
//  Shader.fsh
//  OpenGLTemplate
//
//  Created by Warren Whipple on 2/6/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
