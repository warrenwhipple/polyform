//
//  PFTetraroundT.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 4;
static float segmentCenters[8] = {
    0.0f, 0.0f,
    RRAD*2.0f, 0.0f,
    RRAD*3.0f, RSTACK,
    RRAD*3.0f, -RSTACK,
};

@implementation PFTetraroundT

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsTetraroundT;
        _segmentCount = segmentCount;
        _segmentCenters = (b2Vec2*)segmentCenters;
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
             [[PFTriroundL alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[2])
              angle:brick.body->GetAngle() - M_PI*2.0f/3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:2],
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:3],
                        nil]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFMonoround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[0])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:0]]]];
            [gameScene brickHasSpawned:
             [[PFMonoround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[2])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:2]]]];
            [gameScene brickHasSpawned:
             [[PFMonoround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[3])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:3]]]];
            break;
        case 2:
            [gameScene brickHasSpawned:
             [[PFTriroundL alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[3])
              angle:brick.body->GetAngle() + M_PI*2.0f/3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:3],
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:0],
                        nil]]];
            break;
        case 3:
            [gameScene brickHasSpawned:
             [[PFTriroundL alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[0])
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