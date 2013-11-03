//
//  PFMonomino.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"

static int segmentCount = 1;
static float segmentCenters[] = {
    0.0f, 0.0f,
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {4};
static float shapeA[] = {
    -0.5f, -0.5f,
     0.5f, -0.5f,
     0.5f,  0.5f,
    -0.5f,  0.5f
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFMonomino

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsMonomino;
        _segmentCount = segmentCount;
        _segmentCenters = (b2Vec2*)segmentCenters;
        _physicsShapeCount = physicsShapeCount;
        _physicsShapeVertCounts = physicsShapeVertCounts;
        _physicsShapeVerts = physicsShapeVerts;
    }
    return self;
}

@end
