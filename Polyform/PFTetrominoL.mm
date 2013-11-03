//
//  PFTetrominoL.mm
//  Polyform
//
//  Created by Warren Whipple on 12/21/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 4;
static float segmentCenters[8] = {
    -0.5f, -1.0f,
     0.5f, -1.0f,
    -0.5f,  0.0f,
    -0.5f,  1.0f
};

static int physicsShapeCount = 2;
static int physicsShapeVertCounts[] = {4,4};
static float shapeA[] = {
    0.0f, -0.5f,
    -1.0f, -1.5f,
    1.0f, -1.5f,
    1.0f, -0.5f
};
static float shapeB[] = {
    0.0f, -0.5f,
    0.0f,  1.5f,
    -1.0f,  1.5f,
    -1.0f, -1.5f
};
static float *physicsShapeVerts[] = {shapeA,shapeB};

@implementation PFTetrominoL

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsTetrominoL;
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
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(0.5f, -1.0f))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:1]]]];
            [gameScene brickHasSpawned:
             [[PFDomino alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(-0.5f, 0.5f))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:3],
                        nil]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFTriominoI alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(-0.5f, 0.0f))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:0],
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:3],
                        nil]]];
            break;
        case 2:
            [gameScene brickHasSpawned:
             [[PFDomino alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(0.0f, -1.0f))
              angle:brick.body->GetAngle() - M_PI_2
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:0],
                        [brick.segments objectAtIndex:1],
                        nil]]];
            [gameScene brickHasSpawned:
             [[PFMonomino alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(-0.5f, 1.0f))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:3]]]];
            break;
        case 3:
            [gameScene brickHasSpawned:
             [[PFTriominoL alloc]
              initWithPosition:brick.body->GetWorldPoint(b2Vec2(0.0f, -0.5f))
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:0],
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:2],
                        nil]]];
            break;
    }
}
*/

@end
