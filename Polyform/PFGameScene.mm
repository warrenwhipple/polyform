//
//  PFGameScene.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "PFGameScene.h"
#import "PFContactListener.h"

#import "PFBoundary.h"
#import "PFBase.h"
#import "PFSegment.h"
#import "PFBrick.h"
#import "PFHint.h"
#import "PFScanner.h"

#import "PFGameOverView.h"

#import "PFLabel.h"

#define DESELECT_MAX_DISTSQ (5.0f) // pixels
#define DESELECT_MAX_TIME (0.2f) // seconds
#define PAUSE_BUTTON_RADIUS (32.0f) //vpixels

@implementation PFGameScene
{
    PFRuleSet _ruleSet;
    b2World *_world;
    b2ContactListener *_contactListener;
    
    PFBoundary *_boundary;
    PFBase *_base;
    NSMutableSet *_bricks, *_bricksToDestroy, *_hints, *_hintsToDestroy;
    
    PFBrick *_selectedBrick;
    
    //PFScanner *_scanner;
    float _topHoverBrickHeight;
    float _topLooseBrickHeight;
    float _topStableBrickHeight;
    
    int _stableBrickCount;
    int _dropCount;
    
    UITouch *_tapToDeselectTouch;
    NSTimeInterval *_tapToDeselectTimestamp;
    CGPoint *_tapToDeselectPoint;
    
    PFGameOverView *_gameOverView;
    
    PFBrick *_gameOverBrick;
    
    int _spawnLoopCountdown;
    
    float _sceneBrightness;
    float _gameLineBrightness;
}
 
@synthesize camera = _camera;
@synthesize state = _state;
@synthesize nextSceneType = _nextSceneType;
@synthesize nextRuleSet = _nextRuleSet;

- (id)initWithRuleSet:(PFRuleSet)ruleSet
{
    if ((self = [super init]))
    {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        _camera = [[PFCamera alloc] initWithGLKMinumumLeft:-5.0f
                                                     right:5.0f
                                                    bottom:-1.0f
                                                       top:30.0f];
        
        _ruleSet = ruleSet;
        _world = new b2World(b2Vec2(0, -GRAVITY));
        [PFBody setSharedWorld:_world];
        _world->SetAllowSleeping(ALLOW_SLEEPING);
        _world->SetContinuousPhysics(CONTINUOUS_PHYSICS);
        
        _contactListener = new PFContactListener((__bridge void*)self);
        _world->SetContactListener(_contactListener);
        
        _boundary = [[PFBoundary alloc] initWithScreenSize:_camera.screenSize];
        
        _base = [PFBase base:_ruleSet.baseType];
        
        _bricks = [NSMutableSet setWithCapacity:MAX_BRICK_COUNT];
        _bricksToDestroy = [NSMutableSet setWithCapacity:MAX_BRICK_COUNT/4];
        
        _hints = [NSMutableSet setWithCapacity:MAX_BRICK_COUNT/4];
        _hintsToDestroy = [NSMutableSet setWithCapacity:MAX_BRICK_COUNT/4];
        
        //if (_ruleSet.scannerIsAvtive) _scanner = [[PFScanner alloc] init];
        
        _gameOverView = [[PFGameOverView alloc] initWithFrame:(CGRect){{0.0f, 0.0f}, [_camera screenSize]}];
        
        _spawnLoopCountdown = 0;
        _dropCount = DROP_START_COUNT;
        
        _gameLineBrightness = 1.0f;
    }
    return self;
}

- (void)dealloc
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [PFBody setSharedWorld:nil];
    if (_world)
    {
        delete _world;
        _world = NULL;
    }
    if (_contactListener)
    {
        delete _contactListener;
        _contactListener = NULL;
    }
}

- (void)changeToState:(PFSceneState)newState
{
    switch (newState)
    {
        case PFSceneStateEntering:
        {
            
        } break;
        case PFSceneStateRunning:
        {
            
        } break;
        case PFSceneStateExiting:
        {
            
        } break;
        case PFSceneStatePausing:
        {
            
        } break;
        case PFSceneStatePaused:
        {
            
        } break;
        case PFSceneStateResuming:
        {
            
        } break;
        case PFSceneStateGameOver:
        {
            if ([_gameOverView superview] == nil) [[_camera glkView] addSubview:_gameOverView];
        } break;
        case PFSceneStateExitingFromPause:
        {
            
        } break;
        case PFSceneStateExitComplete:
        {
            [_gameOverView removeFromSuperview];
        } break;
    }
    _state = newState;
}

#pragma mark - Update methods

- (void)update
{
    [_camera update];
    switch (_state)
    {
        case PFSceneStateEntering:
        {
            if (_sceneBrightness < 1.0f)
            {
                _sceneBrightness += SCENE_TRANSITION_BRIGHTNESS_STEP;
                _sceneBrightness = MIN(_sceneBrightness, 1.0f);
            }
            else
                [self changeToState:PFSceneStateRunning];
            [self updateWorld];
        } break;
        case PFSceneStateRunning:
        {
            [self updateWorld];
        } break;
        case PFSceneStatePausing:
        {
            [self updateWorld];
        } break;
        case PFSceneStatePaused:
        {
        } break;
        case PFSceneStateResuming:
        {
            [self updateWorld];
        } break;
        case PFSceneStateGameOver:
        {
            [_gameOverView update];
            _gameLineBrightness = 1.0f - _gameOverView.alpha;
            if (_gameOverView.menuButton.wasPressed)
            {
                _nextSceneType = PFSceneTypeMenu;
                [self changeToState:PFSceneStateExiting];
            }
            else if (_gameOverView.restartButton.wasPressed)
            {
                _nextSceneType = PFSceneTypeGame;
                _nextRuleSet = _ruleSet;
                [self changeToState:PFSceneStateExiting];
            }
        } break;
        case PFSceneStateExitingFromPause:
        {
        } break;
        case PFSceneStateExiting:
        {
            if (_sceneBrightness > 0.0f)
            {
                _sceneBrightness -= SCENE_TRANSITION_BRIGHTNESS_STEP;
                _sceneBrightness = MAX(_sceneBrightness, 0.0f);
            }
            else
                [self changeToState:PFSceneStateExitComplete];
            _gameOverView.alpha = _sceneBrightness;
        } break;
        case PFSceneStateExitComplete:
        {
        } break;
    }
}

- (void)updateWorld
{
    _world->Step(TIMESTEP, VELOCITY_ITERTATIONS, POSITION_ITERATIONS);
    
    _topLooseBrickHeight = 0.0f;
    _topHoverBrickHeight = 0.0f;
    _topStableBrickHeight = 0.0f;
    _stableBrickCount = 0;
    int spawningBrickCount = 0;
    int hoverBrickCount = 0;
    
    for (PFHint *hint in _hints)
    {
        [hint update];
        if (!hint.timer)
        {
            [self spawnBrickWithHint:hint];
            [_hintsToDestroy addObject:hint];
        }
    }
    [_hints minusSet:_hintsToDestroy];
    [_hintsToDestroy removeAllObjects];
    
    for (PFBrick *brick in _bricks)
    {
        [brick updateWithCamera:_camera];
        [_boundary boundBrick:brick];
        if (brick.shouldBeDestroyed)
        {
            if (_dropCount > 0) {
                [_bricksToDestroy addObject:brick];
                _dropCount--;
            }
            else
            {
                _gameOverBrick = brick;
                [self changeToState:PFSceneStateGameOver];
            }
        }
        else
        {
            if (brick.isSpawning) spawningBrickCount++;
            if (brick.shouldBeLetLoose)
            {
                [self letLooseBrick:brick];
                brick.shouldBeLetLoose = NO;
            }
            //[brick updateSegments];
            b2Vec2 center = brick.body->GetWorldCenter();
            switch (brick.state)
            {
                case PFBrickStateHover:
                case PFBrickStateSelected:
                case PFBrickStateDrag:
                case PFBrickStateRotate:
                case PFBrickStateDragRotate:
                {
                    _topHoverBrickHeight = MAX(_topHoverBrickHeight, center.y);
                    hoverBrickCount++;
                } break;
                case PFBrickStateLoose:
                {
                    _topLooseBrickHeight = MAX(_topLooseBrickHeight, center.y);
                    if (brick.stabilityTimer > STABILITY_TIMER)
                    {
                        _topStableBrickHeight = MAX(_topStableBrickHeight, center.y);
                        _stableBrickCount++;
                    }
                    //if (_scanner) [_scanner scanBrick:brick];
                } break;
            }
        }
    }
    
    for (PFBrick *brick in _bricksToDestroy) [self destroyBrick:brick];
    [_bricksToDestroy removeAllObjects];
    
    if (_selectedBrick && _selectedBrick.state == PFBrickStateLoose)
        _selectedBrick = nil;
    
    /*
    if (_scanner)
        for (PFSegment *segment in [_scanner returnSegmentsToDestroy])
            [self destroySegment:segment];
    */
    
    //if (hoverBrickCount == 0) [self spawnRandomBrick];
    if (!_spawnLoopCountdown)
    {
        [self spawnRandomHint];
        _spawnLoopCountdown = SPAWN_LOOP_LENGTH;
    }
    else _spawnLoopCountdown--;
    
    [_camera setGLKMinimumLeft:_boundary.left
                         right:_boundary.right
                        bottom:_boundary.bottom
                           top:_boundary.top];
}

#pragma mark - Brick handling methods

- (void)spawnRandomHint
{
    float x =
        arc4random_0to1() * (_boundary.right - _boundary.left - SPAWN_END_RADIUS * 2.0f)
        + _boundary.left + SPAWN_END_RADIUS;
    float y =
        arc4random_0to1() * (_boundary.top - _topStableBrickHeight - SPAWN_END_RADIUS * 3.0f)
        + _topStableBrickHeight + SPAWN_END_RADIUS * 2.0f;
    PFHint *hint = [[PFHint alloc] initWithPosition:b2Vec2(x,y) timer:HINT_TIMER_LENGTH];
    [_hints addObject:hint];
}

- (void)spawnBrickWithHint:(PFHint*)hint
{
    PFBrick *brick = [PFBrick brickWithGenus:_ruleSet.brickGenus];
    [brick spawnWithPosition:hint.position state:PFBrickStateHover];
    brick.body->SetLinearVelocity(hint.velocity);
    [_bricks addObject:brick];
}

- (void)spawnRandomBrick
{
    float x =
        arc4random_0to1() * (_boundary.right - _boundary.left - SPAWN_END_RADIUS * 2.0f)
        + _boundary.left + SPAWN_END_RADIUS;
    float y =
        arc4random_0to1() * (_boundary.top - _topStableBrickHeight - SPAWN_END_RADIUS * 3.0f)
        + _topStableBrickHeight + SPAWN_END_RADIUS * 2.0f;
    PFBrick *brick = [PFBrick brickWithGenus:_ruleSet.brickGenus];
    [brick spawnWithPosition:b2Vec2(x, y) state:PFBrickStateHover];
    [_bricks addObject:brick];
}

- (void)letLooseBrick:(PFBrick*)brick
{
    [brick changeState:PFBrickStateLoose];
    if (brick == _selectedBrick) _selectedBrick = nil;
}

- (void)destroyBrick:(PFBrick*)brick
{
    if (brick == _selectedBrick) _selectedBrick = nil;
    [_bricks removeObject:brick];
    _world->DestroyBody(brick.body);
}

/*
- (void)destroySegment:(PFSegment*)segment
{
    PFBrick *brick = segment.parentBrick;
    [brick spawnNewBricksInGameScene:self
            withSegmentToBeDestroyed:segment];
    [self destroyBrick:brick];
}
*/

- (void)beginContact:(b2Contact *)contact
{
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Fixture *fixtureB = contact->GetFixtureB();
    PFBody *bodyA = (__bridge PFBody*)fixtureA->GetBody()->GetUserData();
    PFBody *bodyB = (__bridge PFBody*)fixtureB->GetBody()->GetUserData();
    if (bodyA && bodyB)
    {
        if ([bodyA isKindOfClass:[PFBrick class]])
        {
            if (((PFBrick*)bodyA).isSpawning) return;
            else if ([bodyB isKindOfClass:[PFBrick class]])
            {
                if (((PFBrick*)bodyB).isSpawning) return;
                else
                {
                    switch (((PFBrick*)bodyA).state)
                    {
                        case PFBrickStateLoose:
                        case PFBrickStateHover:
                        case PFBrickStateSelected:
                        {
                            [self letLooseBrick:(PFBrick*)bodyA];
                        } break;
                        case PFBrickStateDrag:
                        case PFBrickStateRotate:
                        case PFBrickStateDragRotate: break;
                    }
                    switch (((PFBrick*)bodyB).state)
                    {
                        case PFBrickStateLoose:
                        case PFBrickStateHover:
                        case PFBrickStateSelected:
                        {
                            [self letLooseBrick:(PFBrick*)bodyB];
                        } break;
                        case PFBrickStateDrag:
                        case PFBrickStateRotate:
                        case PFBrickStateDragRotate: break;
                    }
                    return;
                }
            }
            else if ([bodyB isKindOfClass:[PFBase class]])
            {
                switch (((PFBrick*)bodyA).state)
                {
                    case PFBrickStateLoose:
                    case PFBrickStateHover:
                    case PFBrickStateSelected:
                    {
                        [self letLooseBrick:(PFBrick*)bodyA];
                    } break;
                    case PFBrickStateDrag:
                    case PFBrickStateRotate:
                    case PFBrickStateDragRotate: break;
                }
                return;
            }
        }
        else if ([bodyA isKindOfClass:[PFBase class]])
        {
            if ([bodyB isKindOfClass:[PFBrick class]])
            {
                if (((PFBrick*)bodyB).isSpawning) return;
                else
                {
                    switch (((PFBrick*)bodyB).state)
                    {
                        case PFBrickStateLoose:
                        case PFBrickStateHover:
                        case PFBrickStateSelected:
                        {
                            [self letLooseBrick:(PFBrick*)bodyB];
                        } break;
                        case PFBrickStateDrag:
                        case PFBrickStateRotate:
                        case PFBrickStateDragRotate: break;
                    }
                    return;
                }
            }
        }

    }
}

#pragma mark - Touch callback

- (void)touchesBegan:(NSSet *)touches
{
    switch (_state)
    {
        case PFSceneStateEntering:
        case PFSceneStateRunning:
        case PFSceneStateResuming:
        {            
            // Check all touches
            for (UITouch* touch in touches)
            {
                CGPoint touchPoint = [touch locationInView:touch.view];
                
                // Check for active touches on selected brick
                if (_selectedBrick && _selectedBrick.touchA)
                {
                    if (!_selectedBrick.touchB)
                        [_selectedBrick touchSecondBegan:[touches anyObject]
                                          withTouchPoint:[_camera b2Vec2FromScreenPoint:touchPoint]];
                    return; // stop processing all touches
                }
                
                b2Vec2 touchVec = [_camera b2Vec2FromScreenPoint:touchPoint];
                
                // Check and flag if touch is over selected brick ring
                // (flag is usind in case there is a touch near a loose brick)
                BOOL touchIsOverSelectedBrickRing = NO;
                if (_selectedBrick)
                    touchIsOverSelectedBrickRing = b2DistanceSquared(_selectedBrick.body->GetWorldCenter(),touchVec)<RING_RADIUS*RING_RADIUS;
                
                // Find closest brick within bubble radius
                PFBrick *closestBrick = nil;
                float closesBrickDistSq = BUBBLE_RADIUS*BUBBLE_RADIUS;
                for (PFBrick *brick in _bricks)
                {
                    float distSq = b2DistanceSquared(brick.body->GetWorldCenter(), touchVec);
                    if (distSq < closesBrickDistSq)
                    {
                        // if a potential loose brick touch competes with hover bubble or ring touches
                        // check that potential loose brick touch is actually over a segment
                        if (brick.state==PFBrickStateLoose)
                        {
                            if ((closestBrick && closestBrick.state!=PFBrickStateLoose)
                                || touchIsOverSelectedBrickRing)
                            {
                                if ([brick touchVecIsOverSegments:touchVec])
                                {
                                    closesBrickDistSq = distSq;
                                    closestBrick = brick;
                                    break; // when touch is over segments, just stop searching for a closest brick
                                }
                            }
                            else
                            {
                                // don't check segments if there is no competing brick
                                closesBrickDistSq = distSq;
                                closestBrick = brick;
                            }
                        }
                        else
                        {
                            closesBrickDistSq = distSq;
                            closestBrick = brick;
                        }
                    }
                }
                
                // Process touch for closest brick within bubble radius
                if (closestBrick)
                {
                    if (_selectedBrick && _selectedBrick != closestBrick)
                        [_selectedBrick changeState:PFBrickStateHover];
                    _selectedBrick = closestBrick;
                    [_selectedBrick touchDragBegan:touch
                                    withTouchPoint:[_camera b2Vec2FromScreenPoint:touchPoint]];
                    continue; // skip to next touch
                }
                
                // Process touch not within bubble radius of any brick
                if (_selectedBrick)
                {
                    if (touchIsOverSelectedBrickRing)
                    {
                        [_selectedBrick touchRotateBegan:touch
                                          withTouchPoint:[_camera b2Vec2FromScreenPoint:touchPoint]];
                        continue; // skip to next touch
                    }
                    // As last resort touch drags selected brick
                    [_selectedBrick touchDragBegan:touch
                                    withTouchPoint:[_camera b2Vec2FromScreenPoint:touchPoint]];
                }
            }
        } break;
        case PFSceneStatePausing:
        case PFSceneStatePaused:
        {
            
        } break;
        case PFSceneStateGameOver:
        {
            
        } break;
        case PFSceneStateExiting:
        case PFSceneStateExitingFromPause:
        case PFSceneStateExitComplete: break;
    }
}

#pragma mark - Vert handling methods

- (void)writeToVertHandler:(PFVertHandler*)vertHandler
{
    [vertHandler changeSceneBrightness:_sceneBrightness];
    [vertHandler changeLineBrightness:_gameLineBrightness];
    switch (_state)
    {
        case PFSceneStateEntering:
        case PFSceneStateRunning:
        case PFSceneStateExiting:
        {
            [self writeGameToVertHandler:vertHandler];
        } break;
        case PFSceneStatePausing:
        case PFSceneStateResuming:
        {
            [self writeGameToVertHandler:vertHandler];
        } break;
        case PFSceneStatePaused:
        case PFSceneStateExitingFromPause:
        {
            
        } break;
        case PFSceneStateGameOver:
        {
            [self writeGameToVertHandler:vertHandler];
        } break;
        case PFSceneStateExitComplete: break;
    }
}

- (void)writeGameToVertHandler:(PFVertHandler*)vertHandler
{
    [vertHandler changeColor:(GLKVector4){{1.0f,1.0f,1.0f,_sceneBrightness}}];
    if (_base) [vertHandler addBase:_base];
    
    [vertHandler addGameBricks:_bricks withSelectedBrick:_selectedBrick];
    
    [vertHandler addHints:_hints];
    
    [vertHandler changeColor:(GLKVector4){{1.0f,1.0f,1.0f,0.5f}}];
    GLKVector2 dropStartCoord = (GLKVector2){{-8.0f, -1.0f}};
    for (int i=1; i<=_dropCount; i++)
    {
        [vertHandler addCircleWithPosition:dropStartCoord radius:0.25f];
        dropStartCoord.y += 1.5f;
    }
    
    
    [vertHandler changeColor:(GLKVector4){{1.0f,1.0f,1.0f,1.0f}}];
    [vertHandler addNumber:_stableBrickCount withCenter:(GLKVector2){{0.0f,-1.125f}} height:1.0f];
}

@end
