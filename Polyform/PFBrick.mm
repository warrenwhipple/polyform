//
//  PFBrick.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFGameScene.h"

@implementation PFBrick
{
    b2Fixture *_spawnFixture;
    float _bubbleTargetRadius, _ringTargetRadius;
    float _bubbleVelocity, _ringVelocity, _spawnVelocity;
    int _bubbleTargetGlow, _ringTargetGlow;
}

@synthesize
state = _state,
isSpawning = _isSpawning,
spawnRadius = _spawnRadius,
group = _group,
stabilityTimer = _stabilityTimer,
shouldBeLetLoose = _shouldBeLetLoose,
shouldBeDestroyed = _shouldBeDestroyed,

//segments = _segments,

touchA = _touchA,
touchB = _touchB,
bubbleIsAsleep = _bubbleIsAsleep,
ringIsAsleep = _ringIsAsleep,
bubbleRadius = _bubbleRadius,
ringRadius = _ringRadius,
bubbleGlow = _bubbleGlow,
ringGlow = _ringGlow;

#pragma mark - Public convenience + spawn methods

+ (id)brick:(PFBrickSpecies)species
{
    PFBrick *brick;
    switch (species)
    {
        case bsMonomino: brick =     [[PFMonomino alloc] init]; break;
        case bsDomino: brick =       [[PFDomino alloc] init]; break;
        case bsTriominoI: brick =    [[PFTriominoI alloc] init]; break;
        case bsTriominoL: brick =    [[PFTriominoL alloc] init]; break;
        case bsTetrominoI: brick =   [[PFTetrominoI alloc] init]; break;
        case bsTetrominoJ: brick =   [[PFTetrominoJ alloc] init]; break;
        case bsTetrominoL: brick =   [[PFTetrominoL alloc] init]; break;
        case bsTetrominoO: brick =   [[PFTetrominoO alloc] init]; break;
        case bsTetrominoS: brick =   [[PFTetrominoS alloc] init]; break;
        case bsTetrominoT: brick =   [[PFTetrominoT alloc] init]; break;
        case bsTetrominoZ: brick =   [[PFTetrominoZ alloc] init]; break;
        case bsMoniamond: brick =    [[PFMoniamond alloc] init]; break;
        case bsDiamond: brick =      [[PFDiamond alloc] init]; break;
        case bsTriamond: brick =     [[PFTriamond alloc] init]; break;
        case bsTetriamondC: brick =  [[PFTetriamondC alloc] init]; break;
        case bsTetriamondI: brick =  [[PFTetriamondI alloc] init]; break;
        case bsTetriamondIr: brick = [[PFTetriamondIr alloc] init]; break;
        case bsTetriamondT: brick =  [[PFTetriamondT alloc] init]; break;
        case bsMonoround: brick =    [[PFMonoround alloc] init]; break;
        case bsDiround: brick =      [[PFDiround alloc] init]; break;
        case bsTriroundI: brick =    [[PFTriroundI alloc] init]; break;
        case bsTriroundL: brick =    [[PFTriroundL alloc] init]; break;
        case bsTriroundT: brick =    [[PFTriroundT alloc] init]; break;
        case bsTetraroundB: brick =  [[PFTetraroundB alloc] init]; break;
        case bsTetraroundC: brick =  [[PFTetraroundC alloc] init]; break;
        case bsTetraroundD: brick =  [[PFTetraroundD alloc] init]; break;
        case bsTetraroundI: brick =  [[PFTetraroundI alloc] init]; break;
        case bsTetraroundJ: brick =  [[PFTetraroundJ alloc] init]; break;
        case bsTetraroundL: brick =  [[PFTetraroundL alloc] init]; break;
        case bsTetraroundO: brick =  [[PFTetraroundO alloc] init]; break;
        case bsTetraroundS: brick =  [[PFTetraroundS alloc] init]; break;
        case bsTetraroundT: brick =  [[PFTetraroundT alloc] init]; break;
        case bsTetraroundZ: brick =  [[PFTetraroundZ alloc] init]; break;
    }
    return brick;
}

+ (id)brickWithGenus:(PFBrickGenus)genus
{
    return [self brick:randomSpeciesFromGenus(genus)];
}

- (void)spawnWithPosition:(b2Vec2)position state:(PFBrickState)state
{
    [self spawnWithPosition:position
                      angle:randomAngle()
                      group:0
                   segments:nil
                      state:state];
}

/*
- (void)spawnWithPosition:(b2Vec2)position
                    angle:(float)angle
                    group:(int)group
                 segments:(NSArray *)segments
{
    [self spawnWithPosition:position
                      angle:angle
                      group:group
                   segments:segments
                      state:PFBrickStateLoose
                      timer:0];
}
*/

- (GLKVector2)centerPhysicsVerts
{
    b2Vec2 centroid = b2Vec2_zero;
    for (int s=0; s<_segmentCount; s++)
        centroid += _segmentCenters[s];
    centroid.x /= _segmentCount;
    centroid.y /= _segmentCount;
    for (int s=0; s<_segmentCount; s++)
        _segmentCenters[s] -= centroid;
    for (int s=0; s<_physicsShapeCount; s++)
        for (int v=0; v<_physicsShapeVertCounts[s]*2; v+=2)
        {
            _physicsShapeVerts[s][v] -= centroid.x;
            _physicsShapeVerts[s][v+1] -= centroid.y;
        }
    return (GLKVector2){{centroid.x, centroid.y}};
}

/* // I stopped updating the scanner destruction code a while ago
- (void)spawnNewBricksInGameScene:(PFGameScene*)gameScene
         withSegmentToBeDestroyed:(PFSegment*)segment
{
    NSAssert(NO, @"spawnNewBricksInGameScene:withSegmentToBeDestroyed: should not be called on PFBrick class that is not sublclassed.");
}
*/

#pragma mark - Private spawn methods

- (void)spawnWithPosition:(b2Vec2)position
                    angle:(float)angle
                    group:(int)group
                 segments:(NSArray *)passedSegments
                    state:(PFBrickState)state
{
    _group = group;
    _state = state;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = position;
    bodyDef.angle = angle;
    bodyDef.userData = (__bridge void*)self;
    _body = [PFBody sharedWorld]->CreateBody(&bodyDef);
    [self changeState:_state];
    if (state == PFBrickStateLoose)
    {
        _isSpawning = NO;
        [self completeSpawning];
    }
    else
    {
        _isSpawning = YES;
        _spawnRadius = SPAWN_START_RADIUS;
        b2FixtureDef fixtureDef;
        fixtureDef.density = DEFAULT_DENSITY * 0.01f;
        fixtureDef.friction = 0.0f;
        fixtureDef.restitution = DEFAULT_RESTITUTION;
        b2CircleShape shape;
        shape.m_p = b2Vec2_zero;
        shape.m_radius = SPAWN_START_RADIUS;
        fixtureDef.shape = &shape;
        _spawnFixture = _body->CreateFixture(&fixtureDef);
    }
    
    /*
    if (passedSegments) _segments = passedSegments;
    else
    {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:_segmentCount];
        for (int s = 0; s < _segmentCount; s++) [tempArray addObject:[[PFSegment alloc] init]];
        _segments = [NSArray arrayWithArray:tempArray];
    }
    for (PFSegment *segment in _segments) segment.parentBrick = self;
    */
}

- (void)completeSpawning
{
    if(_spawnFixture)
    {
        _body->DestroyFixture(_spawnFixture);
        _spawnFixture = nil;
    }
    b2FixtureDef fixtureDef;
    fixtureDef.density = DEFAULT_DENSITY;
    fixtureDef.friction = DEFAULT_FRICTION;
    fixtureDef.restitution = DEFAULT_RESTITUTION;
    if (_species < bsMonoround)
    {
        // Add polygon shape
        b2PolygonShape shape;
        for (int s = 0; s < _physicsShapeCount; s++)
        {
            shape.Set((b2Vec2*)_physicsShapeVerts[s], _physicsShapeVertCounts[s]);
            fixtureDef.shape = &shape;
            _body->CreateFixture(&fixtureDef);
        }
    }
    else
    {
        // Add circle shapes
        b2CircleShape shape;
        for (int s = 0; s < _segmentCount; s++)
        {
            shape.m_p = _segmentCenters[s];
            shape.m_radius = RRAD;
            fixtureDef.shape = &shape;
            _body->CreateFixture(&fixtureDef);
        }
    }
    _isSpawning = NO;
}

#pragma mark - Update methods

/*
- (void)updateSegments
{
    for (int s=0; s<_segmentCount; s++)
    {
        ((PFSegment*)[_segments objectAtIndex:s]).height = _body->GetWorldPoint(_segmentCenters[s]).y;
    }
}
*/

- (void)updateWithCamera:(PFCamera*)camera
{
#pragma mark update touches
    switch (_state)
    {
        case PFBrickStateLoose:
        case PFBrickStateHover:
        case PFBrickStateSelected: break;
        case PFBrickStateDrag:
        {
            switch (_touchA.phase)
            {
                case UITouchPhaseBegan:
                case UITouchPhaseMoved:
                case UITouchPhaseStationary:
                {
                    // one touch dragging
                    b2Vec2 touchPoint = [camera b2Vec2FromScreenPoint:[_touchA locationInView:_touchA.view]];
                    b2Vec2 deltaTouchPoint = touchPoint - _lastTouchAPoint;
                    _body->SetLinearVelocity(b2Vec2(deltaTouchPoint.x/TIMESTEP, deltaTouchPoint.y/TIMESTEP));
                    _lastTouchAPoint = touchPoint;
                } break;
                case UITouchPhaseEnded:
                case UITouchPhaseCancelled:
                {
                    // one touch drag dropped
                    if ([self isInSolidContactWithAnything]) [self changeState:PFBrickStateLoose];
                    else [self changeState:PFBrickStateSelected];
                    _touchA = nil;
                } break;
            }
        } break;
        case PFBrickStateRotate:
        {
            switch (_touchA.phase)
            {
                case UITouchPhaseBegan:
                case UITouchPhaseMoved:
                case UITouchPhaseStationary:
                {
                    // one touch rotation
                    b2Vec2 touchPoint = [camera b2Vec2FromScreenPoint:[_touchA locationInView:_touchA.view]];
                    b2Vec2 brickPoint = _body->GetWorldCenter();
                    float touchAngle = atan2f(touchPoint.y-brickPoint.y, touchPoint.x-brickPoint.x);
                    float deltaTouchAngle = touchAngle - _lastTouchAngle;
                    while (deltaTouchAngle > M_PI) deltaTouchAngle -= 2.0f * M_PI;
                    while (deltaTouchAngle < -M_PI) deltaTouchAngle += 2.0f * M_PI;
                    _body->SetAngularVelocity(deltaTouchAngle / TIMESTEP);
                    _lastTouchAngle = touchAngle;
                } break;
                case UITouchPhaseEnded:
                case UITouchPhaseCancelled:
                {
                    // one touch rotation dropped
                    if ([self isInSolidContactWithAnything]) [self changeState:PFBrickStateLoose];
                    else [self changeState:PFBrickStateSelected];
                    _touchA = nil;
                } break;
            }
        } break;
        case PFBrickStateDragRotate:
        {
            switch (_touchA.phase)
            {
                case UITouchPhaseBegan:
                case UITouchPhaseMoved:
                case UITouchPhaseStationary:
                {
                    switch (_touchB.phase)
                    {
                        case UITouchPhaseBegan:
                        case UITouchPhaseMoved:
                        case UITouchPhaseStationary:
                        {
                            // touchA and touchB active
                            b2Vec2 touchAPoint = [camera b2Vec2FromScreenPoint:[_touchA locationInView:_touchA.view]];
                            b2Vec2 touchBPoint = [camera b2Vec2FromScreenPoint:[_touchB locationInView:_touchB.view]];
                            b2Vec2 touchMidpoint = touchAPoint + touchBPoint;
                            touchMidpoint *= 0.5f;
                            b2Vec2 deltaMidpoint = touchMidpoint - _lastTouchMidpoint;
                            _body->SetLinearVelocity(b2Vec2(deltaMidpoint.x/TIMESTEP, deltaMidpoint.y/TIMESTEP));
                            float touchAngle = atan2f(touchAPoint.y-touchBPoint.y, touchAPoint.x-touchBPoint.x);
                            float deltaTouchAngle = touchAngle - _lastTouchAngle;
                            while (deltaTouchAngle > M_PI) deltaTouchAngle -= 2.0f * M_PI;
                            while (deltaTouchAngle < -M_PI) deltaTouchAngle += 2.0f * M_PI;
                            _body->SetAngularVelocity(deltaTouchAngle / TIMESTEP);
                            _lastTouchAPoint = touchAPoint;
                            _lastTouchBPoint = touchBPoint;
                            _lastTouchMidpoint = touchMidpoint;
                            _lastTouchAngle = touchAngle;
                        } break;
                        case UITouchPhaseEnded:
                        case UITouchPhaseCancelled:
                        {
                            // touchB dropped
                            [self changeState:PFBrickStateDrag];
                            _touchB = nil;
                        } break;
                    }
                } break;
                case UITouchPhaseEnded:
                case UITouchPhaseCancelled:
                {
                    switch (_touchB.phase)
                    {
                        case UITouchPhaseBegan:
                        case UITouchPhaseMoved:
                        case UITouchPhaseStationary:
                        {
                            // touchA dropped
                            [self changeState:PFBrickStateDrag];
                            _lastTouchAPoint = _lastTouchBPoint;
                            _touchA = _touchB;
                            _touchB = nil;
                        } break;
                        case UITouchPhaseEnded:
                        case UITouchPhaseCancelled:
                        {
                            // both touchA and touchB dropped
                            if ([self isInSolidContactWithAnything]) [self changeState:PFBrickStateLoose];
                            else [self changeState:PFBrickStateSelected];
                            _touchA = nil;
                            _touchB = nil;
                        } break;
                    }
                } break;
            }
        } break;
    }
    
#pragma mark update spawning bricks
    if (_isSpawning)
    {
        if (_spawnVelocity < 0.0f && _spawnRadius < SPAWN_END_RADIUS)
            [self completeSpawning];
        else
        {
            _spawnVelocity += (SPAWN_END_RADIUS - _spawnRadius) * BUBBLE_SPRING_CONSTANT;
            _spawnVelocity *= BUBBLE_SPRING_DAMPING;
            _spawnRadius += _spawnVelocity;
            _spawnFixture->GetShape()->m_radius = _spawnRadius;
        }
    }
    
#pragma mark update stability timer
    if (_state == PFBrickStateLoose)
    {
        if (_body->GetLinearVelocity().LengthSquared() < STABILITY_VEL_SQ &&
            ABS(_body->GetAngularVelocity()) < STABILITY_ANG_VEL)
        {
            _stabilityTimer++;
        }
        else _stabilityTimer = 0;
    }

#pragma mark update bubble/ring radii
    if (!_bubbleIsAsleep)
    {
        if (_bubbleTargetRadius<=0.0f && _bubbleRadius<=0.0f)
        {
            _bubbleIsAsleep = YES;
            _bubbleRadius = _bubbleTargetRadius;
        }
        else
        {
            _bubbleVelocity += (_bubbleTargetRadius - _bubbleRadius) * BUBBLE_SPRING_CONSTANT;
            _bubbleVelocity *= BUBBLE_SPRING_DAMPING;
            _bubbleRadius += _bubbleVelocity;
        }
    }
    if (!_ringIsAsleep)
    {
        if (_ringTargetRadius<=_bubbleTargetRadius && _ringRadius<=_bubbleRadius)
        {
            _ringIsAsleep = YES;
            _ringRadius = _ringTargetRadius;
        }
        else
        {
            _ringVelocity += (_ringTargetRadius - _ringRadius) * BUBBLE_SPRING_CONSTANT;
            _ringVelocity *= BUBBLE_SPRING_DAMPING;
            _ringRadius += _ringVelocity;
        }
    }
    else
    {
        _ringRadius = _bubbleRadius;
        _ringVelocity = _bubbleVelocity;
    }
    
#pragma mark update bubble/ring glows
    if (_bubbleGlow != _bubbleTargetGlow)
    {
        if (_bubbleGlow < _bubbleTargetGlow)
            _bubbleGlow++;
        else _bubbleGlow--;
    }
    if (_ringGlow != _ringTargetGlow)
    {
        if (_ringGlow < _ringTargetGlow)
            _ringGlow++;
        else _ringGlow--;
    }
}

- (void)changeState:(PFBrickState)state
{
    _bubbleIsAsleep = NO;
    _ringIsAsleep = NO;
    switch (state)
    {
        case PFBrickStateLoose:
        {
            _bubbleTargetRadius = 0.0f;
            _ringTargetRadius = 0.0f;
            _bubbleTargetGlow = 0;
            _ringTargetGlow = 0;
            _body->SetGravityScale(1.0f);
            _body->SetLinearDamping(0.0f);
            _body->SetAngularDamping(0.0f);
        } break;
        case PFBrickStateHover:
        {
            _stabilityTimer = 0;
            _bubbleTargetRadius = BUBBLE_RADIUS;
            _ringTargetRadius = BUBBLE_RADIUS;
            _bubbleTargetGlow = 0;
            _ringTargetGlow = 0;
            _body->SetGravityScale(HOVER_GRAVITY_SCALE);
            _body->SetLinearDamping(HOVER_LINEAR_DAMPING);
            _body->SetAngularDamping(HOVER_ANGULAR_DAMPING);
        } break;
        case PFBrickStateSelected:
        {
            _stabilityTimer = 0;
            _bubbleTargetRadius = BUBBLE_RADIUS;
            _ringTargetRadius = RING_RADIUS;
            _bubbleTargetGlow = 0;
            _ringTargetGlow = 0;
            _body->SetGravityScale(HOVER_GRAVITY_SCALE);
            _body->SetLinearDamping(HOVER_LINEAR_DAMPING);
            _body->SetAngularDamping(HOVER_ANGULAR_DAMPING);
        } break;
        case PFBrickStateDrag:
        {
            _stabilityTimer = 0;
            _bubbleTargetRadius = BUBBLE_RADIUS;
            _ringTargetRadius = RING_RADIUS;
            _bubbleTargetGlow = BUBBLE_GLOW_MAX;
            _ringTargetGlow = 0;
            _body->SetGravityScale(0.0f);
            _body->SetLinearDamping(0.0f);
            _body->SetAngularDamping(DRAG_ANGULAR_DAMPING);
        } break;
        case PFBrickStateRotate:
        {
            _stabilityTimer = 0;
            _bubbleTargetRadius = BUBBLE_RADIUS;
            _ringTargetRadius = RING_RADIUS;
            _bubbleTargetGlow = 0;
            _ringTargetGlow = BUBBLE_GLOW_MAX;
            _body->SetGravityScale(0.0f);
            _body->SetLinearDamping(ROTATE_LINEAR_DAMPING);
            _body->SetAngularDamping(0.0f);
        } break;
        case PFBrickStateDragRotate:
        {
            _stabilityTimer = 0;
            _bubbleTargetRadius = BUBBLE_RADIUS;
            _ringTargetRadius = RING_RADIUS;
            _bubbleTargetGlow = BUBBLE_GLOW_MAX;
            _ringTargetGlow = BUBBLE_GLOW_MAX;
            _body->SetGravityScale(0.0f);
            _body->SetLinearDamping(0.0f);
            _body->SetAngularDamping(0.0f);
        } break;
    }
    _state = state;
}

- (BOOL)isInSolidContactWithAnything
{
    for (b2ContactEdge *ce = _body->GetContactList(); ce; ce = ce->next)
    {
        b2Contact *c = ce->contact;
        if (c->IsTouching()
            && !c->GetFixtureA()->IsSensor()
            && !c->GetFixtureB()->IsSensor())
            return YES;
    }
    return NO;
}

#pragma mark - Touch methods

- (BOOL)touchVecIsOverSegments:(b2Vec2)touchVec
{
    for (int s=0; s<_segmentCount; s++)
        if (b2DistanceSquared(touchVec, _body->GetWorldPoint(_segmentCenters[s]))<SEGMENT_TOUCH_RADIUS_SQ)
            return YES;
    return NO;
}

- (void)touchDragBegan:(UITouch*)touch
        withTouchPoint:(b2Vec2)touchPoint
{
    [self changeState:PFBrickStateDrag];
    _touchA = touch;
    _lastTouchAPoint = touchPoint;
    
}

- (void)touchRotateBegan:(UITouch*)touch
          withTouchPoint:(b2Vec2)touchPoint
{
    [self changeState:PFBrickStateRotate];
    _touchA = touch;
    _lastTouchAPoint = touchPoint;
    b2Vec2 brickPoint = _body->GetWorldCenter();
    _lastTouchAngle = atan2f(touchPoint.y-brickPoint.y, touchPoint.x-brickPoint.x);
}

- (void)touchSecondBegan:(UITouch*)touch
          withTouchPoint:(b2Vec2)touchPoint
{
    [self changeState:PFBrickStateDragRotate];
    _touchB = touch;
    _lastTouchBPoint = touchPoint;
    _lastTouchMidpoint = (_lastTouchAPoint + _lastTouchBPoint);
    _lastTouchMidpoint *= 0.5f;
    _lastTouchAngle = atan2f(_lastTouchAPoint.y-_lastTouchBPoint.y, _lastTouchAPoint.x-_lastTouchBPoint.x);
}

@end
