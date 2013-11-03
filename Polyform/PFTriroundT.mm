//
//  PFTriroundT.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 3;
static float segmentCenters[6] = {
    0.0f, 0.0f,
    RRAD*2.0f, 0.0f,
    RRAD, RSTACK,
};

@implementation PFTriroundT

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsTriroundT;
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
             [[PFDiround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[1])
              angle:brick.body->GetAngle() + M_PI*2.0f/3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:1],
                        [brick.segments objectAtIndex:2],
                        nil]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFDiround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[0])
              angle:brick.body->GetAngle() + M_PI/3.0f
              group:brick.group
              segments:[NSArray arrayWithObjects:
                        [brick.segments objectAtIndex:0],
                        [brick.segments objectAtIndex:2],
                        nil]]];
            break;
        case 2:
            [gameScene brickHasSpawned:
             [[PFDiround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[0])
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
