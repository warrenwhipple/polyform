//
//  Shader.fsh
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
