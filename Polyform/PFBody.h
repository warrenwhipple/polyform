//
//  PFBody.h
//  Polyform
//
//  Created by Warren Whipple on 12/24/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "Box2D.h"

@interface PFBody : NSObject
{
    b2Body *_body;
}

@property (readwrite, nonatomic) b2Body *body;

+ (void)setSharedWorld:(b2World*)world;
+ (b2World*)sharedWorld;

@end
