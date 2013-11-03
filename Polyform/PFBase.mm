//
//  PFBase.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBase.h"

@implementation PFBase

@synthesize type = _type;
@synthesize floor = _floor;
@synthesize walls = _walls;
@synthesize displayVerticies = _displayVerticies;
@synthesize displayVertexCount = _displayVertexCount;

+ (id)base:(PFBaseType)type
{
    PFBase *base;
    switch (type)
    {
        case PFBaseTypeRectangle10:
        {
            base = [[PFBaseRectangle alloc] init];
            base.type = type;
            [base spawnWithWidth:10 depth:2];
        } break;
        case PFBaseTypeTrapezoid10:
        {
            base = [[PFBaseRectangle alloc] init];
            base.type = type;
            [base spawnWithWidth:10 depth:2];
        } break;
        case PFBaseTypeBubble9:
        {
            base = [[PFBaseBubble alloc] init];
            base.type = type;
            [base spawnWithWidth:9 depth:1];
        } break;
        case PFBaseTypeTankBase:
        {
            base = [[PFBaseRectangle alloc] init];
            base.type = type;
            [base spawnWithWidth:TANK_WIDTH*0.5f depth:TANK_WIDTH*0.5f];
        } break;
        case PFBaseTypeTankWell:
        {
            base = [[PFBaseRectangle alloc] init];
            base.type = type;
            [base spawnWithWidth:TANK_WIDTH*0.5f depth:TANK_WIDTH*0.5f];
        } break;
    }
    return  base;
}

- (void)spawnWithWidth:(int)width depth:(int)depth
{
    [NSException raise:@"PFBase error" format:@"You should not call method spawnWithWidth:depth: on abstract class PFBase."];
}

@end
