//
//  PFLabel.m
//  Polyform
//
//  Created by Warren Whipple on 9/10/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFLabel.h"

static UIView *_glkView;
static float _pixelToPointRatio = 1.0f;

@implementation PFLabel
{
    PFCamera *_camera;
}

@synthesize
glkCenter = _glkCenter,
glkHeight = _glkHeight;

+ (void)bindGLKView:(UIView *)glkView
{
    _glkView = glkView;
    _pixelToPointRatio = [@"M" sizeWithFont:[UIFont fontWithName:TEXT_22_FONT size:TEXT_22_POINT]].height / TEXT_22_POINT;
}

- (id) initWithCamera:(PFCamera *)camera
            glkCenter:(GLKVector2)glkCenter
            glkHeight:(float)glkHeight
                 text:(NSString *)text

{
    if ((self = [super init]))
    {
        _camera = camera;
        _glkCenter = glkCenter;
        _glkHeight = glkHeight;
        self.text = text;
        self.font = [UIFont fontWithName:TEXT_22_FONT size:TEXT_22_POINT];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        [self update];
    }
    return self;
}

- (void)appear
{
    [_glkView addSubview:self];
}

- (void)disappear
{
    [self removeFromSuperview];
}

- (void)update
{
    self.font = [UIFont fontWithName:TEXT_22_FONT
                                size: _glkHeight * _camera.ptmRatio / _pixelToPointRatio];
    [self sizeToFit];
    self.center = [_camera screenPointFromGLKVector2:_glkCenter];
}

@end
