//
//  PFTank.h
//  Polyform
//
//  Created by Warren Whipple on 12/27/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBase.h"
#import "PFBrick.h"
#import "PFVertHandler.h"

@interface PFTank : NSObject
{
    b2World *_world;
    PFBase *_base;
    PFRuleSet _ruleSet;
    NSMutableSet *_bricks, *_bricksToDestroy;
    float _hue;
    int _spawnCountdown;
    
    float _topSpawn;
    float _leftDestruction;
    float _rightDestruction;
    float _bottomDestruction;
}

@property (readonly, nonatomic) PFRuleSet ruleSet;
@property (readwrite, nonatomic) float hue;
@property (readonly, nonatomic) NSMutableSet *bricks;

- (id)initWithRuleSet:(PFRuleSet)ruleSet;

- (void)update;

@end
