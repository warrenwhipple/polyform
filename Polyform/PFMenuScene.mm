//
//  PFMenuScene.mm
//  Polyform
//
//  Created by Warren Whipple on 12/27/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFMenuScene.h"
#import "PFCamera.h"
#import "PFIncrementedScrollHandler.h"
#import "PFTank.h"

@interface PFMenuScene ()

- (PFTank *)tankFromScreenPoint:(CGPoint)screenPoint;

@end

@implementation PFMenuScene
{
    NSArray *_tanks;
    int _tankLowResVertCount;
    GLKVector2 *_tankLowResVerts;
    PFIncrementedScrollHandler *_scrollHandler;
    UITouch *_tankSelectTouch;
    CGPoint _touchPoint;
    PFTank *_sidePressedTank;
    PFTank *_centerPressedTank;
    CGPoint _touchStartPoint;
    float _brightness;
}

@synthesize camera = _camera;
@synthesize state = _state;
@synthesize nextSceneType = _nextSceneType;
@synthesize nextRuleSet = _nextRuleSet;

- (id)init
{
    if ((self = [super init]))
    {
        _tanks = [NSArray arrayWithObjects:
                  [[PFTank alloc] initWithRuleSet:PFRuleSetMake(bgTetromino, PFBaseTypeRectangle10, NO)],
                  [[PFTank alloc] initWithRuleSet:PFRuleSetMake(bgTetriamond, PFBaseTypeTrapezoid10, NO)],
                  [[PFTank alloc] initWithRuleSet:PFRuleSetMake(bgTetraround, PFBaseTypeBubble9, NO)],
                  nil];
        
        float randHue = arc4random_0to1();
        for (int t = 0; t < _tanks.count; t++)
        {
            PFTank *tank = [_tanks objectAtIndex:t];
            tank.hue = (float)t / (float)_tanks.count + randHue;
        }
        
        _scrollHandler = [[PFIncrementedScrollHandler alloc] initTrackXAxisWithItemCount:_tanks.count
                                                                             itemSpacing:TANK_SPACING
                                                                               startItem:0];
        
        _camera = [[PFCamera alloc] initWithGLKMinumumLeft:-TANK_WIDTH
                                                     right:TANK_WIDTH
                                                    bottom:TANK_BOTTOM - 5.0f
                                                       top:TANK_BOTTOM + TANK_HEIGHT + 5.0f];
    }
    return self;
}

- (void)update
{
    [_camera update];
    switch (_state)
    {
        case PFSceneStateEntering:
        {
            [self updateTanks];
            [self updateTankSelectTouch];
            if (_brightness < 1.0f)
            {
                _brightness += SCENE_TRANSITION_BRIGHTNESS_STEP;
                _brightness = MIN(_brightness, 1.0f);
            }
            else
                _state = PFSceneStateRunning;
        } break;
        case PFSceneStateRunning:
        case PFSceneStatePausing:
        case PFSceneStatePaused:
        case PFSceneStateResuming:
        case PFSceneStateGameOver:
        {
            [self updateTanks];
            [self updateTankSelectTouch];
        } break;
        case PFSceneStateExiting:
        case PFSceneStateExitingFromPause:
        {
            [self updateTanks];
            if (_brightness > 0.0f)
            {
                _brightness -= SCENE_TRANSITION_BRIGHTNESS_STEP;
                _brightness = MAX(_brightness, 0.0f);
            }
            else
                _state = PFSceneStateExitComplete;
        } break;
        case PFSceneStateExitComplete: break;
    }
}

- (void) updateTanks
{
    [_scrollHandler updateWithPTMRatio:_camera.ptmRatio];
    for (PFTank *tank in _tanks)
    {
        [tank update];
        tank.hue += 0.001f;
        if (tank.hue > 1.0f) tank.hue -= 1.0f;
    }
}

- (void) updateTankSelectTouch
{
    if (_tankSelectTouch)
    {
        switch (_tankSelectTouch.phase)
        {
            case UITouchPhaseBegan:
            case UITouchPhaseMoved:
            case UITouchPhaseStationary:
            {
                // Cancel selectTouch if it moves too far.
                _touchPoint = [_tankSelectTouch locationInView:_tankSelectTouch.view];
                if ((_touchPoint.x-_touchStartPoint.x)*(_touchPoint.x-_touchStartPoint.x)+
                    (_touchPoint.y-_touchStartPoint.y)*(_touchPoint.y-_touchStartPoint.y) > 100.0f)
                    _tankSelectTouch = nil;
                break;
            }
            case UITouchPhaseEnded:
            {
                if (_centerPressedTank && _centerPressedTank == [self tankFromScreenPoint:_touchPoint])
                {
                    _nextSceneType = PFSceneTypeGame;
                    _nextRuleSet = _centerPressedTank.ruleSet;
                    _state = PFSceneStateExiting;
                }
                else if (_sidePressedTank && _sidePressedTank == [self tankFromScreenPoint:_touchPoint])
                {
                    [_scrollHandler scrollToItem:[_tanks indexOfObject:_sidePressedTank]];
                }
                _tankSelectTouch = nil;
                _centerPressedTank = nil;
                _sidePressedTank = nil;
                break;
            }
            case UITouchPhaseCancelled:
            {
                _tankSelectTouch = nil;
            }
        }
    }
}

#pragma mark - Touch methods

- (void)touchesBegan:(NSSet *)touches
{
    float tankTopScreen = [_camera screenYFromGLKY:(TANK_BOTTOM + TANK_HEIGHT)];
    float tankBottomScreen = [_camera screenYFromGLKY:(TANK_BOTTOM)];
    for (UITouch *touch in touches)
    {
        if (!_scrollHandler.touch && !_tankSelectTouch)
        {
            CGPoint touchPoint = [touch locationInView:touch.view];
            if (touchPoint.y < tankBottomScreen && touchPoint.y > tankTopScreen)
            {
                [_scrollHandler touchBegan:touch];
                _touchStartPoint = touchPoint;
                PFTank *pressedTank = [self tankFromScreenPoint:touchPoint];
                if (pressedTank)
                {
                    _tankSelectTouch = touch;
                    if ([_scrollHandler distanceFromItem:[_tanks indexOfObject:pressedTank]] < TANK_WIDTH/4.0f)
                        _centerPressedTank = pressedTank;
                    else _sidePressedTank = pressedTank;
                }
            }
            else
            {
                // add other button selects
            }
        }
    }
}

- (PFTank*)tankFromScreenPoint:(CGPoint)screenPoint
{
    GLKVector2 glPoint = [_camera glkVector2FromScreenPoint:screenPoint];
    if (glPoint.y < TANK_BOTTOM+TANK_HEIGHT && glPoint.y > TANK_BOTTOM)
    {
        float tankTouchFloat = (glPoint.x + _scrollHandler.position) / TANK_SPACING;
        int tankTouchInt = roundf(tankTouchFloat);
        if (tankTouchInt >= 0 && tankTouchInt <= _tanks.count - 1 &&
            ABS(tankTouchInt - tankTouchFloat) < TANK_WIDTH / TANK_SPACING / 2.0f)
        {
            return [_tanks objectAtIndex:tankTouchInt];
        }
    }
    return nil;
}

- (void)writeToVertHandler:(PFVertHandler *)vertHandler
{
    // draw tanks
    for (int t = 0; t < _tanks.count; t++)
    {
        PFTank *tank = [_tanks objectAtIndex:t];
        [vertHandler changeSceneBrightness:_brightness];
        [vertHandler changeColor:RGBAfromHSVA(tank.hue, 1.0f, 0.8f, _brightness)];
        [vertHandler addRect:(CGRect){{t*TANK_SPACING-_scrollHandler.position, -TANK_BOTTOM}, {TANK_WIDTH, TANK_HEIGHT}}];
    }
    
    // draw tank contents
    [vertHandler changeColor:(GLKVector4){{0.0f,0.0f,0.0f,1.0f}}];
    for (int t = 0; t < _tanks.count; t++)
    {
        PFTank *tank = [_tanks objectAtIndex:t];
        for (PFBrick *brick in tank.bricks)
            [vertHandler addBrick:brick
                       withOffset:(GLKVector2){{t*TANK_SPACING-_scrollHandler.position, 0}}];
    }
}

@end
