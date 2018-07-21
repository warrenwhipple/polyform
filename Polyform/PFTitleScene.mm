//
//  PFTitleScene.m
//  Polyform
//
//  Created by Warren Whipple on 1/8/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFTitleScene.h"

// processing divisor = 2500.0*sqrt(3.0) for polyformbreakgrid.svg;
static int largeRightPointingTriangleCount = 65;
static float largeRightPointingTriangles[] = {-19.5f,-4.3301272f,-19.5f,-3.1754265f,-18.5f,-2.5980763f,-18.0f,-1.7320508f,-18.0f,-0.57735026f,-17.0f,-0.0f,-16.0f,0.57735026f,-15.0f,-0.0f,-15.0f,-1.1547005f,-15.0f,-2.309401f,-16.0f,-2.8867514f,-17.0f,-2.309401f,-13.0f,-1.7320508f,-13.0f,-0.57735026f,-12.0f,-0.0f,-11.0f,0.57735026f,-10.0f,-0.0f,-10.0f,-1.1547005f,-10.0f,-2.309401f,-11.0f,-2.8867514f,-12.0f,-2.309401f,-8.0f,-1.7320508f,-8.0f,-0.57735026f,-8.0f,0.57735026f,-8.0f,1.7320508f,-8.0f,2.8867514f,-6.0f,-0.57735026f,-6.0f,-1.7320508f,-5.0f,-2.309401f,-4.0f,-2.8867514f,-3.0f,-2.309401f,-3.0f,-1.1547005f,-4.5f,-3.7527769f,-4.5f,-4.9074774f,-5.5f,-5.4848275f,0.5f,-2.020726f,0.0f,-0.0f,2.0f,-0.0f,0.5f,0.8660254f,0.5f,2.020726f,1.5f,2.5980763f,4.0f,-0.57735026f,5.0f,-0.0f,6.0f,0.57735026f,7.0f,-0.0f,7.0f,-1.1547005f,7.0f,-2.309401f,6.0f,-2.8867514f,5.0f,-2.309401f,4.0f,-1.7320508f,9.0f,-1.7320508f,9.0f,-0.57735026f,10.0f,-0.0f,11.0f,0.57735026f,12.0f,-0.0f,14.0f,-1.7320508f,14.0f,-0.57735026f,15.0f,-0.0f,16.0f,0.57735026f,17.0f,-1.1547005f,17.0f,-0.0f,18.0f,-0.0f,19.0f,0.57735026f,20.0f,-0.0f,20.0f,-1.1547005f};
static int largeLeftPointingTriangleCount = 60;
static float largeLeftPointingTriangles[] = {-20.5f,-3.7527769f,-20.5f,-2.5980763f,-19.0f,-2.309401f,-19.0f,-1.1547005f,-19.0f,-0.0f,-18.0f,0.57735026f,-17.0f,-0.0f,-16.0f,-0.57735026f,-16.0f,-1.7320508f,-17.0f,-2.309401f,-18.0f,-2.8867514f,-14.0f,-2.309401f,-14.0f,-1.1547005f,-14.0f,-0.0f,-13.0f,0.57735026f,-12.0f,-0.0f,-11.0f,-0.57735026f,-11.0f,-1.7320508f,-12.0f,-2.309401f,-13.0f,-2.8867514f,-9.0f,-1.1547005f,-9.0f,-0.0f,-9.0f,1.1547005f,-9.0f,2.309401f,-7.0f,-1.1547005f,-7.0f,-2.309401f,-6.0f,-2.8867514f,-5.0f,-2.309401f,-4.0f,-1.7320508f,-4.0f,-0.57735026f,-5.5f,-4.3301272f,-6.5f,-4.9074774f,-0.5f,-2.5980763f,-2.0f,-0.0f,0.0f,-0.0f,-0.5f,1.4433757f,-0.5f,2.5980763f,0.5f,3.1754265f,3.0f,-0.0f,4.0f,0.57735026f,5.0f,-0.0f,6.0f,-0.57735026f,6.0f,-1.7320508f,5.0f,-2.309401f,4.0f,-2.8867514f,3.0f,-2.309401f,3.0f,-1.1547005f,8.0f,-1.1547005f,8.0f,-0.0f,9.0f,0.57735026f,10.0f,-0.0f,13.0f,-1.1547005f,13.0f,-0.0f,14.0f,0.57735026f,15.0f,-0.0f,16.0f,-0.57735026f,17.0f,0.57735026f,18.0f,-0.0f,19.0f,-0.57735026f,19.0f,-1.7320508f};
static int smallRightPointingTriangleCount = 6;
static float smallRightPointingTriangles[] = {0.5f,-3.1754265f,0.0f,-2.8867514f,0.5f,-1.4433757f,0.5f,0.28867513f,1.0f,0.57735026f,17.0f,-1.7320508f};
static int smallLeftPointingTriangleCount = 11;
static float smallLeftPointingTriangles[] = {-19.5f,-2.020726f,-5.0f,-3.4641016f,-0.5f,-3.1754265f,0.0f,-1.7320508f,-0.5f,-1.4433757f,-1.0f,0.57735026f,-0.5f,0.28867513f,0.0f,0.57735026f,16.0f,-1.7320508f,16.5f,-1.4433757f,16.5f,0.28867513f};

@implementation PFTitleScene
{
    int _launchImageAnimationDelay;
    b2World *_world;
    NSMutableArray *_staticPolygons;
    NSMutableSet *_dynamicPolygons;
    b2Vec2 *_largeRightPointingTriangles,*_largeLeftPointingTriangles, *_smallRightPointingTriangles, *_smallLeftPointingTriangles;
    float _brightness;
}

@synthesize
camera = _camera,
state = _state,
nextSceneType = _nextSceneType,
nextRuleSet = _nextRuleSet;

- (id)init
{
    if ((self = [super init]))
    {
        _launchImageAnimationDelay = LAUNCH_ANIMATION_DELAY;
        
        _largeRightPointingTriangles = (b2Vec2*)largeRightPointingTriangles;
        _largeLeftPointingTriangles = (b2Vec2*)largeLeftPointingTriangles;
        _smallRightPointingTriangles = (b2Vec2*)smallRightPointingTriangles;
        _smallLeftPointingTriangles = (b2Vec2*)smallLeftPointingTriangles;
        
        _state = PFSceneStateRunning;
        _world = new b2World(b2Vec2(0, -GRAVITY));
        _world->SetAllowSleeping(YES);
        _world->SetContinuousPhysics(FALSE);
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        b2Body *body = _world->CreateBody(&bodyDef);
        b2FixtureDef fixtureDef;
        b2PolygonShape shape;
        shape.SetAsBox(8.0f, 8.0f, b2Vec2(0.0f,-16.0f), 0.0f);
        fixtureDef.shape = &shape;
        fixtureDef.friction = DEFAULT_FRICTION;
        fixtureDef.restitution = DEFAULT_RESTITUTION;
        body->CreateFixture(&fixtureDef);
        
        int polygonCount = largeRightPointingTriangleCount+largeLeftPointingTriangleCount+smallRightPointingTriangleCount+smallLeftPointingTriangleCount;
        _staticPolygons = [NSMutableArray arrayWithCapacity:polygonCount];
        _dynamicPolygons = [NSMutableSet setWithCapacity:polygonCount];
        for (int p = 0; p < largeRightPointingTriangleCount; p++)
            [_staticPolygons addObject:[[PFTitleTriangleLarge alloc] initWithWorld:_world
                                                                          position:_largeRightPointingTriangles[p]
                                                                             angle:M_PI]];
        for (int p = 0; p < largeLeftPointingTriangleCount; p++)
            [_staticPolygons addObject:[[PFTitleTriangleLarge alloc] initWithWorld:_world
                                                                          position:_largeLeftPointingTriangles[p]
                                                                             angle:0.0f]];
        for (int p = 0; p < smallRightPointingTriangleCount; p++)
            [_staticPolygons addObject:[[PFTitleTriangleSmall alloc] initWithWorld:_world
                                                                          position:_smallRightPointingTriangles[p]
                                                                             angle:M_PI]];
        for (int p = 0; p < smallLeftPointingTriangleCount; p++)
            [_staticPolygons addObject:[[PFTitleTriangleSmall alloc] initWithWorld:_world
                                                                          position:_smallLeftPointingTriangles[p]
                                                                             angle:0.0f]];
        
        CGRect cameraRect;
        cameraRect.origin = {0.0f,0.0f};
        cameraRect.size = {48.0f, 11.0f};
        _camera = [[PFCamera alloc]  initWithGLKMinumumRect:cameraRect];
        
        _brightness = 1.0f;
    }
    return self;
}

#pragma mark - Update

- (void)update
{
    [_camera update];
    switch (_state)
    {
        case PFSceneStateEntering:
        {
            if (_launchImageAnimationDelay) _launchImageAnimationDelay--;
            else _state = PFSceneStateRunning;
        } break;
        case PFSceneStateExiting:
        {
            if (_brightness > 0)
            {
                _brightness -= SCENE_TRANSITION_BRIGHTNESS_STEP;
                _brightness = MAX(_brightness, 0.0f);
            }
            else _state = PFSceneStateExitComplete;
            [self updateWorld];
        } break;
        default:
        {
            [self updateWorld];
        } break;
    }
}

- (void)updateWorld
{
    _world->Step(TIMESTEP, 1, 1);
    
    if (_staticPolygons)
    {
        PFTitlePolygon *polygon = [_staticPolygons objectAtIndex:arc4random_uniform(_staticPolygons.count)];
        polygon.body->SetType(b2_dynamicBody);
        polygon.body->SetAwake(TRUE);
        [_staticPolygons removeObject:polygon];
        [_dynamicPolygons addObject:polygon];
        if (_staticPolygons.count == 0) _staticPolygons = nil;
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches
{
    _nextSceneType = PFSceneTypeMenu;
    _state = PFSceneStateExiting;
}

#pragma mark - Draw

- (void)writeToVertHandler:(PFVertHandler *)vertHandler

{
    [vertHandler changeSceneBrightness:_brightness];
    vertHandler.drawBrickOutlines = YES;
    for (PFTitlePolygon *p in _staticPolygons) [vertHandler addTitlePolygon:p];
    for (PFTitlePolygon *p in _dynamicPolygons) [vertHandler addTitlePolygon:p];
    vertHandler.drawBrickOutlines = NO;
    for (PFTitlePolygon *p in _staticPolygons) [vertHandler addTitlePolygon:p];
    for (PFTitlePolygon *p in _dynamicPolygons) [vertHandler addTitlePolygon:p];
}

@end
