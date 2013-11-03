//
//  PFDiamond.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 2;
static float segmentCenters[4] = {
    TBASE*0.5f, TRAD,
    TBASE, TRAD*2.0f
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {4};
static float shapeA[] = {
    0.0f, 0.0f,          // 0,0
    TBASE, 0.0f,         // 1,0
    TBASE*1.5f, THEIGHT, // 1,1
    TBASE*0.5f, THEIGHT, // 0,1
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFDiamond

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsDiamond;
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
             [[PFMoniamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[1])
              angle:brick.body->GetAngle() + M_PI / 3.0f
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:1]]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFMoniamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[0])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:0]]]];
            break;
    }
}
*/

@end
