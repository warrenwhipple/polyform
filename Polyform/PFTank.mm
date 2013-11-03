//
//  PFTank.m
//  Polyform
//
//  Created by Warren Whipple on 12/27/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFTank.h"
#import "PFBrick.h"

@implementation PFTank

@synthesize ruleSet = _ruleSet;
@synthesize hue = _hue;
@synthesize bricks = _bricks;

- (id)initWithRuleSet:(PFRuleSet)ruleSet
{
    if ((self = [super init]))
    {
        _ruleSet = ruleSet;
        _world = new b2World(b2Vec2(0, -GRAVITY));
        [PFBody setSharedWorld:_world];
        _world->SetAllowSleeping(YES);
        _world->SetContinuousPhysics(FALSE);
        _base = [PFBase base:PFBaseTypeTankBase];
        _bricks = [NSMutableSet setWithCapacity: 30];
        _bricksToDestroy = [NSMutableSet setWithCapacity: 30];
        
        _leftDestruction = -TANK_SPACING / 2.0f;
        _rightDestruction = TANK_SPACING / 2.0f;
        float destructionBuffer = (TANK_SPACING - TANK_WIDTH) / 2.0f;
        _bottomDestruction = TANK_BOTTOM - destructionBuffer;
        _topSpawn = TANK_BOTTOM + TANK_HEIGHT + destructionBuffer;
    }
    return self;
}

- (void)dealloc
{
    if (_world)
    {
        if ([PFBody sharedWorld] == _world) [PFBody setSharedWorld:nil];
        delete _world;
        _world = nil;
    }
}

- (void)update
{
    if (_spawnCountdown <= 0)
    {
        if (_bricks.count < 30)
        {
            [PFBody setSharedWorld:_world];
            PFBrick *brick = [PFBrick brickWithGenus:_ruleSet.brickGenus];
            [brick spawnWithPosition:(b2Vec2){0.0f,TANK_HEIGHT} state:PFBrickStateLoose];
            [_bricks addObject:brick];
            _spawnCountdown = arc4random_uniform(30) + 30;;
        }
    }
    else _spawnCountdown--;
    
    _world->Step(TIMESTEP, 1, 1);
    
    for (PFBrick *brick in _bricks)
    {
        b2Vec2 center = brick.body->GetWorldCenter();
        if (center.y < _bottomDestruction || center.x < _leftDestruction || center.x > _rightDestruction)
        {
            _world->DestroyBody(brick.body);
            [_bricksToDestroy addObject:brick];
        }
    }
    [_bricks minusSet:_bricksToDestroy];
    [_bricksToDestroy removeAllObjects];
}

@end
