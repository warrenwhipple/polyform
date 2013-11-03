//
//  PFBoundary.m
//  Polyform
//
//  Created by Warren Whipple on 1/23/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFBoundary.h"

@implementation PFBoundary
{
    float _aspectRatio;
}

@synthesize left = _left, right = _right, bottom = _bottom, top = _top;

- (id)initWithScreenSize:(CGSize)screenSize
{
    if ((self = [super init]))
    {
        if (screenSize.width < screenSize.height)
            _aspectRatio = screenSize.width/screenSize.height;
        else _aspectRatio = screenSize.height/screenSize.width;
        _bottom = BOUNDARY_CONSTANT_BOTTOM;
        _top = BOUNDARY_INITIAL_TOP;
        _right = (_top - _bottom) * _aspectRatio / 2.0f;
        _left = -_right;
    }
    return self;
}

- (void)boundBrick:(PFBrick *)brick
{
    b2Vec2 center = brick.body->GetWorldCenter();
    if (center.y < -BRICK_DESTRUCTION_DEPTH)
        brick.shouldBeDestroyed = YES;
    else
    {
        switch (brick.state)
        {
            case PFBrickStateLoose:
            case PFBrickStateHover:
            case PFBrickStateSelected:
            {
                if (center.y < -BRICK_LET_LOOSE_DEPTH) brick.shouldBeLetLoose = YES;
            } break;
            case PFBrickStateDrag:
            case PFBrickStateRotate:
            case PFBrickStateDragRotate: break;
        }
        
        if (center.y > _top)
        {
            brick.body->ApplyLinearImpulse(b2Vec2(0.0f, (_top-center.y)*BOUNDARY_SPRING_CONSTANT),
                                           brick.body->GetWorldCenter());
            b2Vec2 velocity = brick.body->GetLinearVelocity();
            velocity.y *= BOUNDARY_DAMPING;
            brick.body->SetLinearVelocity(velocity);
        }
        if (center.x > _right)
        {
            brick.body->ApplyLinearImpulse(b2Vec2((_right-center.x)*BOUNDARY_SPRING_CONSTANT, 0.0f),
                                           brick.body->GetWorldCenter());
            b2Vec2 velocity = brick.body->GetLinearVelocity();
            velocity.x *= BOUNDARY_DAMPING;
            brick.body->SetLinearVelocity(velocity);
        }
        else if (center.x < _left)
        {
            brick.body->ApplyLinearImpulse(b2Vec2((_left-center.x)*BOUNDARY_SPRING_CONSTANT, 0.0f),
                                           brick.body->GetWorldCenter());
            b2Vec2 velocity = brick.body->GetLinearVelocity();
            velocity.x *= BOUNDARY_DAMPING;
            brick.body->SetLinearVelocity(velocity);
        }
    }
}

- (void)writeToVertHandler:(PFVertHandler *)vertHandler
{
    
}

@end
