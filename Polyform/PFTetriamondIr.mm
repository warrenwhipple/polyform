//
//  PFTetriamondIr.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 4;
static float segmentCenters[8] = {
    TBASE*0.5f, TRAD,
    TBASE, TRAD*2.0f,
    TBASE, TRAD*4.0f,
    TBASE*1.5f, TRAD*5.0f,
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {4};
static float shapeA[] = {
    0.0f, 0.0f,               // 0,0
    TBASE, 0.0f,              // 1,0
    TBASE*2.0f, THEIGHT*2.0f, // 1,1
    TBASE, THEIGHT*2.0f,      // 0,1
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFTetriamondIr

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsTetriamondIr;
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
             [[PFTriamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[1])
              angle:brick.body->GetAngle() + M_PI/3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:3],
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
             [[PFDiamond alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(TBASE*0.5f,THEIGHT))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:3],
                        nil]]];
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
            [gameScene brickHasSpawned:
             [[PFMoniamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[3])
              angle:brick.body->GetAngle() - M_PI/3.0f
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:3]]]];
            break;
        case 3:
            [gameScene brickHasSpawned:
             [[PFTriamond alloc]
              initWithPosition:brick.body->GetWorldPoint(((b2Vec2*)shapeA)[3])
              angle:brick.body->GetAngle() - M_PI*2.0f/3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:0],
                        nil]]];
            break;
    }
}
*/

@end
