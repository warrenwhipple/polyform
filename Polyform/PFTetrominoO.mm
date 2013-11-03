//
//  PFTetrominoO.mm
//  Polyform
//
//  Created by Warren Whipple on 12/21/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 4;
static float segmentCenters[8] = {
    -0.5f, -0.5f,
     0.5f, -0.5f,
    -0.5f,  0.5f,
     0.5f,  0.5f
};

static int physicsShapeCount = 1;
static int physicsShapeVertCounts[] = {4};
static float shapeA[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    1.0f,  1.0f,
    -1.0f,  1.0f
};
static float *physicsShapeVerts[] = {shapeA};

@implementation PFTetrominoO

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsTetrominoO;
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
             [[PFTriominoL alloc]
              initWithPosition:brick.body->GetWorldCenter()
              angle:brick.body->GetAngle() + M_PI
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:3],
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:1],
                        nil]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFTriominoL alloc]
              initWithPosition:brick.body->GetWorldCenter()
              angle:brick.body->GetAngle() - M_PI_2
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:0],
                        [brick.segments objectAtIndex:3],
                        nil]]];
            break;
        case 2:
            [gameScene brickHasSpawned:
             [[PFTriominoL alloc]
              initWithPosition:brick.body->GetWorldCenter()
              angle:brick.body->GetAngle() + M_PI_2
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:3],
                        [brick.segments objectAtIndex:0],
                        nil]]];
            break;
        case 3:
            [gameScene brickHasSpawned:
             [[PFTriominoL alloc]
              initWithPosition:brick.body->GetWorldCenter()
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
