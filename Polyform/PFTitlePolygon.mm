//
//  PFTitlePolygon.mm
//  Polyform
//
//  Created by Warren Whipple on 1/9/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFTitlePolygon.h"

@implementation PFTitlePolygon

@synthesize species = _species;

- (id)initWithWorld:(b2World*)world position:(b2Vec2)position angle:(float)angle
{
    if ((self = [super init]))
    {
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position = position;
        bodyDef.angle = angle;
        _body = world->CreateBody(&bodyDef);
        b2FixtureDef fixtureDef;
        fixtureDef.density = DEFAULT_DENSITY;
        fixtureDef.friction = DEFAULT_FRICTION;
        fixtureDef.restitution = DEFAULT_RESTITUTION;
        b2PolygonShape shape;
        shape.Set(_physicsVerts, _physicsVertCount);
        fixtureDef.shape = &shape;
        _body->CreateFixture(&fixtureDef);
    }
    return self;
}

@end
