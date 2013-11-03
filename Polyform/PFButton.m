//
//  PFButton.m
//  Polyform
//
//  Created by Warren Whipple on 10/16/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFButton.h"

@implementation PFButton
{
    UIImageView *_offImage, *_onImage;
    NSMutableSet *_touches;
    float _brightness;
}

@synthesize wasPressed = _wasPressed;

- (id)initWithOffImageName:(NSString *)offImageName onImageName:(NSString *)onImageName
{
    if ((self = [super init]))
    {
        self.userInteractionEnabled = YES;
        _offImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:offImageName]];
        _offImage.alpha = 1.0f;
        [self addSubview:_offImage];
        _onImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:onImageName]];
        _onImage.alpha = 0.0f;
        [self addSubview:_onImage];
        self.frame = _offImage.frame;
        _touches = [NSMutableSet set];
    }
    return self;
}

- (void)update
{
    if (_touches.count>0 || _wasPressed)
    {
        if (_brightness < 1.0f) _brightness += 0.2f;
        if (_brightness > 1.0f) _brightness = 1.0f;
    }
    else
    {
        if (_brightness > 0.0f) _brightness -= 0.05f;
        if (_brightness < 0.0f) _brightness = 0.0f;
    }
    
    _offImage.alpha = 1.0f - _brightness;
    _onImage.alpha = _brightness;
}

- (void)reset
{
    _brightness = 0.0f;
    _offImage.alpha = 1.0f;
    _onImage.alpha = 0.0f;
    _wasPressed = NO;
    [_touches removeAllObjects];
}

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    float buttonRadius = self.frame.size.width*0.5f;
    touchPoint.x -= buttonRadius;
    touchPoint.y -= buttonRadius;
    if (touchPoint.x*touchPoint.x + touchPoint.y*touchPoint.y <= buttonRadius * buttonRadius)
        return YES;
    else
        return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
        if ([self containsTouch:touch])
            [_touches addObject:touch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
        if ([_touches containsObject:touch])
            if (![self containsTouch:touch])
                [_touches removeObject:touch];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
        if ([_touches containsObject:touch] && [self containsTouch:touch])
            _wasPressed = YES;
    [_touches minusSet:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touches minusSet:touches];
}

@end
