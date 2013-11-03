//
//  PFMonoround.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"

static int segmentCount = 1;
static float segmentCenters[2] = {
    0.0f, 0.0f,
};

@implementation PFMonoround

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsMonoround;
        _segmentCount = segmentCount;
        _segmentCenters = (b2Vec2*)segmentCenters;
    }
    return self;
}

@end
