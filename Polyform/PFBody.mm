//
//  PFBody.mm
//  Polyform
//
//  Created by Warren Whipple on 12/24/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBody.h"

@implementation PFBody

@synthesize body = _body;

static b2World *_sharedWorld;

+ (void)setSharedWorld:(b2World*)world
{
    _sharedWorld = world;
}

+ (b2World*)sharedWorld;
{
    return _sharedWorld;
}

@end
