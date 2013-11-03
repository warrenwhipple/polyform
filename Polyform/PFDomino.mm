//
//  PFDomino.mm
//  Polyform
//
//  Created by Warren Whipple on 12/21/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 2;
static float segmentCenters[] = {
    0.0f, -0.5f,
    0.0f,  0.5f
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {4};
static float shapeA[] = {
    -0.5f, -1.0f,
     0.5f, -1.0f,
     0.5f,  1.0f,
    -0.5f,  1.0f
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFDomino

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsDomino;
        _segmentCount = segmentCount;
        _segmentCenters = (b2Vec2*)segmentCenters;
        _physicsShapeCount = physicsShapeCount;
        _physicsShapeVertCounts = physicsShapeVertCounts;
        _physicsShapeVerts = physicsShapeVerts;
    }
    return self;
}

/*
- (void)spawnNewBricksInGameScene:(PFGameScene*)gameScene
         withSegmentToBeDestroyed:(PFSegment*)segment
{
    PFBrick *brick = segment.parentBrick;
    switch ([_segments indexOfObject:segment])
    {
        case 0:
            [gameScene brickHasSpawned:
             [[PFMonomino alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[1])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:1]]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFMonomino alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[0])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:0]]]];
            break;
    }
}
*/

@end
