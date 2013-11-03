//
//  PFHint.h
//  Polyform
//
//  Created by Warren Whipple on 7/13/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "Box2D.h"

@interface PFHint : NSObject

@property (readwrite, nonatomic) b2Vec2 position, velocity;
@property (readonly, nonatomic) int timer;
@property (readonly, nonatomic) float timerFraction;

- (id)initWithPosition:(b2Vec2)position timer:(int)timer;
- (void)update;
@end
