//
//  PFHint.mm
//  Polyform
//
//  Created by Warren Whipple on 7/13/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFHint.h"

@implementation PFHint
{
    int _timerStart;
}

@synthesize
position = _position,
velocity = _velocity,
timer = _timer,
timerFraction = _timerFraction;

- (id)initWithPosition:(b2Vec2)position timer:(int)timer
{
    if ((self = [super init]))
    {
        _position = position;
        _velocity = b2Vec2_zero;
        _timerStart =  MAX(0, timer);
        _timer = _timerStart;
    }
    return self;
}

- (void)update
{
    if (_timer) _timer--;
    _timerFraction = (float)_timer / (float)_timerStart;
    
    _position += _velocity;
    
    /*
     
     if (_hintTimer)
     {
     if (_hintTimer == HINT_TIMER_LENGTH)
     {
     _bubbleIsAsleep = NO;
     _bubbleVelocity = HINT_KICK * 0.25f;
     }
     else if (_hintTimer == HINT_TIMER_LENGTH / 4 * 3)
     {
     _bubbleIsAsleep = NO;
     _bubbleVelocity = HINT_KICK * 0.5f;
     }
     else if (_hintTimer == HINT_TIMER_LENGTH / 2)
     {
     _bubbleIsAsleep = NO;
     _bubbleVelocity = HINT_KICK * 0.75f;
     }
     else if (_hintTimer == HINT_TIMER_LENGTH / 4)
     {
     _bubbleIsAsleep = NO;
     _bubbleVelocity = HINT_KICK;
     }
     _hintTimer--;
     }
     
     if (!_bubbleIsAsleep)
     {
     if (_bubbleRadius<0.0f)
     {
     _bubbleIsAsleep = YES;
     _bubbleRadius = 0.0f;
     }
     else
     {
     _bubbleVelocity += (0.0f - _bubbleRadius) * HINT_SPRING_CONSTANT;
     _bubbleRadius += _bubbleVelocity;
     }
     }
     
     */
}

@end
