//
//  PFTriamond.m
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 3;
static float segmentCenters[6] = {
    TBASE*0.5f, TRAD,
    TBASE, TRAD*2.0f,
    TBASE*1.5f, TRAD,
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {4};
static float shapeA[] = {
    0.0f, 0.0f,          // 0,0
    TBASE*2.0f, 0.0f,    // 2,0
    TBASE*1.5f, THEIGHT, // 1,1
    TBASE*0.5f, THEIGHT, // 0,1
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFTriamond


- (id)init
{
    if ((self = [super init]))
    {
        _species = bsTriamond;
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
             [[PFDiamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[3])
              angle:brick.body->GetAngle() - M_PI / 3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:2],
                        nil]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFMoniamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[0])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:0]]]];
            [gameScene brickHasSpawned:
             [[PFMoniamond alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(TBASE,0.0f))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:2]]]];
            break;
        case 2:
            [gameScene brickHasSpawned:
             [[PFDiamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[0])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:0],
                        [brick.segments objectAtIndex:1],
                        nil]]];
            break;
    }
}
*/
@end
