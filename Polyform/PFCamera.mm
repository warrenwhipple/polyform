//
//  PFCamera.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFCamera.h"

static __weak UIView *sharedView;

@implementation PFCamera
{
    b2Vec2 _translate;
    float _scale;
    CGRect _glkMinimumRect, _glkRect;
    UITouch *_touchA;
    UITouch *_touchB;
    CGPoint _lastMidPoint;
    float _lastDistance;
}
@synthesize
screenSize = _screenSize,
glkLeft = _glkLeft,
glkRight = _glkRight,
glkBottom = _glkBottom,
glkTop = _glkTop,
ptmRatio = _ptmRatio,
projection = _projection;

+ (void)linkView:(UIView *)view
{
    sharedView = view;
}

- (id)initWithGLKMinumumRect:(CGRect)rect
{
    if ((self = [super init]))
    {
        _screenSize = sharedView.bounds.size;
        _translate = b2Vec2(0.0f, 0.0f);
        _scale = 1.0f;
        _glkMinimumRect = rect;
        [self update];
    }
    return self;
}

- (id)initWithGLKMinumumLeft:(float)left
                       right:(float)right
                      bottom:(float)bottom
                         top:(float)top;
{
    if ((self = [super init]))
    {
        _screenSize = sharedView.bounds.size;
        _translate = b2Vec2(0.0f, 0.0f);
        _scale = 1.0f;
        _glkMinimumRect = CGRectMake((left+right)/2.0f,
                                     (bottom+top)/2.0f,
                                     right-left,
                                     top-bottom);
        [self update];
    }
    return self;
}

- (UIView*)glkView
{
    return sharedView;
}

- (void)update
{
    NSAssert(sharedView, @"PFCamera error: Shared view pointer lost.");
    _screenSize = sharedView.bounds.size;
    
    if (_touchA && _touchB)
    {
        CGPoint pA = [_touchA locationInView:_touchA.view];
        CGPoint pB = [_touchB locationInView:_touchB.view];
        CGPoint currentMidPoint = {(pA.x+pB.x)/2.0f,(pA.y+pB.y)/2.0f};
        float currentDistance = sqrtf(((pA.x-pB.x)*(pA.x-pB.x))+((pA.y-pB.y)*(pA.y-pB.y)));
        currentDistance = MAX(currentDistance, 100.0f);
        _translate = {
            _translate.x - (currentMidPoint.x - _lastMidPoint.x) / _ptmRatio,
            _translate.y + (currentMidPoint.y - _lastMidPoint.y) / _ptmRatio};
        _scale *= currentDistance / _lastDistance;
        _lastMidPoint = currentMidPoint;
        _lastDistance = currentDistance;
    }
    
    _glkRect = _glkMinimumRect;
    float glkRatio = _glkRect.size.width/_glkRect.size.height;
    float screenRatio = _screenSize.width/_screenSize.height;
    if (glkRatio > screenRatio) _glkRect.size.height *= glkRatio/screenRatio;
    else if (glkRatio < screenRatio) _glkRect.size.width *= screenRatio/glkRatio;
    
    _glkRect.origin.x += _translate.x;
    _glkRect.origin.y += _translate.y;
    _glkRect.size.width /= _scale;
    _glkRect.size.height /= _scale;
     
    _ptmRatio = _screenSize.height / _glkRect.size.height;
    
    _glkLeft = _glkRect.origin.x - (_glkRect.size.width / 2.0f);
    _glkRight = _glkRect.origin.x + (_glkRect.size.width / 2.0f);
    _glkBottom = _glkRect.origin.y - (_glkRect.size.height / 2.0f);
    _glkTop = _glkRect.origin.y + (_glkRect.size.height / 2.0f);
    _projection = GLKMatrix4MakeOrtho(_glkLeft, _glkRight, _glkBottom, _glkTop, -1.0f, 1.0f);
}

- (void)setGLKMinimumLeft:(float)left
                    right:(float)right
                   bottom:(float)bottom
                      top:(float)top
{
    _glkMinimumRect = CGRectMake((left+right)/2.0f,
                                 (bottom+top)/2.0f,
                                 right-left,
                                 top-bottom);
}


- (float)screenXFromGLKX:(float)glkX
{
    return (glkX-_glkLeft)*_screenSize.width/(_glkRight-_glkLeft);
}

- (float)screenYFromGLKY:(float)glkY
{
    return (glkY-_glkBottom)*_screenSize.height/(_glkBottom-_glkTop)+_screenSize.height;
}

- (float)glkXFromScreenX:(float)screenX
{
    return (screenX*(_glkRight-_glkLeft)/_screenSize.width)+_glkLeft;
}

- (float)glkYFromScreenY:(float)screenY
{
    return (_screenSize.height-screenY)*(_glkTop-_glkBottom)/_screenSize.height+_glkBottom;
}

- (CGPoint)screenPointFromGLKVector2:(GLKVector2)vec
{
    return CGPointMake((vec.x-_glkLeft)*_screenSize.width/(_glkRight-_glkLeft),
                       (vec.y-_glkBottom)*_screenSize.height/(_glkBottom-_glkTop)+_screenSize.height);
}

- (CGPoint)screenPointFromB2Vec2:(b2Vec2)vec
{
    return CGPointMake((vec.x-_glkLeft)*_screenSize.width/(_glkRight-_glkLeft),
                       (vec.y-_glkBottom)*_screenSize.height/(_glkBottom-_glkTop)+_screenSize.height);
}

- (GLKVector2)glkVector2FromScreenPoint:(CGPoint)point
{
    return GLKVector2Make((point.x*(_glkRight-_glkLeft)/_screenSize.width)+_glkLeft,
                          (_screenSize.height-point.y)*(_glkTop-_glkBottom)/_screenSize.height+_glkBottom);
}

- (b2Vec2)b2Vec2FromScreenPoint:(CGPoint)point
{
    return b2Vec2((point.x*(_glkRight-_glkLeft)/_screenSize.width)+_glkLeft,
                  (_screenSize.height-point.y)*(_glkTop-_glkBottom)/_screenSize.height+_glkBottom);
}

- (void)touchBegan:(UITouch *)touch
{
    if (!_touchA)
    {
        _touchA = touch;
    }
    else if (!_touchB)
    {
        _touchB = touch;
        CGPoint pA = [_touchA locationInView:_touchA.view];
        CGPoint pB = [_touchB locationInView:_touchB.view];
        _lastMidPoint = {(pA.x+pB.x)/2.0f,(pA.y+pB.y)/2.0f};
        _lastDistance = sqrtf(((pA.x-pB.x)*(pA.x-pB.x))+((pA.y-pB.y)*(pA.y-pB.y)));
        _lastDistance = MAX(_lastDistance, 100.0f);
    }
}

- (void)touchEnded:(UITouch *)touch
{
    if (touch == _touchA)
    {
        _touchA = nil;
        if (_touchB)
        {
            _touchA = _touchB;
            _touchB = nil;
        }
    }
    else if (touch == _touchB) _touchB = nil;
}

@end
