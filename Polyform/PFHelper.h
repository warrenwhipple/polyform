//
//  PFColorHelper.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

static inline float randomAngle()
{
    return 2.0f * M_PI * ((float)arc4random()) / ((float)(0x100000000));
}

static inline float arc4random_0to1()
{
    return ((float)arc4random()) / ((float)(0x100000000));
}

static GLKVector4 RGBAfromHSVA(float h, float s, float v, float a)
{
    float r, g, b;
    
    int i = floorf(h * 6);
    float f = h * 6 - i;
    float p = v * (1 - s);
    float q = v * (1 - f * s);
    float t = v * (1 - (1 - f) * s);
    
    switch(i % 6)
    {
        case 0: r = v, g = t, b = p; break;
        case 1: r = q, g = v, b = p; break;
        case 2: r = p, g = v, b = t; break;
        case 3: r = p, g = q, b = v; break;
        case 4: r = t, g = p, b = v; break;
        case 5: r = v, g = p, b = q; break;
    }
    
    return GLKVector4Make(r, g, b, a);
}

static GLKVector4 RGBAfromH(float h)
{
    float r, g, b;
    
    int i = floorf(h * 6);
    float f = h * 6 - i;
    
    switch(i % 6)
    {
        case 0: r = 1,   g = f,   b = 0;   break;
        case 1: r = 1-f, g = 1,   b = 0;   break;
        case 2: r = 0,   g = 1,   b = f;   break;
        case 3: r = 0,   g = 1-f, b = 1;   break;
        case 4: r = f,   g = 0,   b = 1;   break;
        case 5: r = 1,   g = 0,   b = 1-f; break;
    }
    
    return GLKVector4Make(r, g, b, 1);
}