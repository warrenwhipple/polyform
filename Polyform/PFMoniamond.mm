//
//  PFMoniamond.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"

static int segmentCount = 1;
static float segmentCenters[2] = {
    TBASE*0.5f, TRAD,
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {3};
static float shapeA[] = {
    0.0f, 0.0f,          // 0,0
    TBASE, 0.0f,         // 1,0
    TBASE*0.5f, THEIGHT, // 0,1
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFMoniamond

- (id)initWithWorld:(b2World *)world
           position:(b2Vec2)position
              angle:(float)angle
              group:(int)group
           segments:(NSArray *)segments
{
    if ((self = [super init]))
    {
        _species = bsMoniamond;
        _segmentCount = segmentCount;
        _segmentCenters = (b2Vec2*)segmentCenters;
        _physicsShapeCount = physicsShapeCount;
        _physicsShapeVertCounts = physicsShapeVertCounts;
        _physicsShapeVerts = physicsShapeVerts;
    }
    return self;
}

@end
