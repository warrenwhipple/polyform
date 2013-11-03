//
//  PFDiround.mm
//  Polyform
//
//  Created by Warren Whipple on 12/26/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

static int segmentCount = 2;
static float segmentCenters[4] = {
    0.0f, 0.0f,
    RRAD*2.0f, 0.0f,
};

@implementation PFDiround

- (id)init
{
    if ((self = [super init]))
    {
        _species = bsDiround;
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
             [[PFMonoround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[1])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:1]]]];
            break;
        case 1:
            [gameScene brickHasSpawned:
             [[PFMonoround alloc]
              initWithPosition:brick.body->GetWorldPoint(_segmentCenters[0])
              angle:brick.body->GetAngle()
              group:brick.group
              segments:[NSArray arrayWithObject:[brick.segments objectAtIndex:0]]]];
            break;
    }
}
*/
@end