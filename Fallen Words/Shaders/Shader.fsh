//
//  Shader.fsh
//  Fallen Words
//
//  Created by Nick on 16/06/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
