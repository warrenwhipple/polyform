//
//  PFBaseTrapezoid.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBase.h"

@implementation PFBaseTrapezoid

- (void)spawnWithWidth:(int)w
                 depth:(int)d
{
    int physicsVertCount = 4;
    b2Vec2 physicsVerts[4] = {
        b2Vec2(-w/2.0f,0.0f),
        b2Vec2(-(w+d*TBASE)/2.0f,-d*THEIGHT),
        b2Vec2((w+d*TBASE)/2.0f,-d*THEIGHT),
        b2Vec2(w/2.0f,0.0f)
    };

    _floor = [[PFBody alloc] init];

    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.userData = (__bridge void*)self;
    _floor.body = [PFBody sharedWorld]->CreateBody(&bodyDef);
    b2FixtureDef fixtureDef;
    b2PolygonShape shape;
    shape.Set(physicsVerts, physicsVertCount);
    fixtureDef.shape = &shape;
    fixtureDef.friction = DEFAULT_FRICTION;
    fixtureDef.restitution = DEFAULT_RESTITUTION;
    _floor.body->CreateFixture(&fixtureDef);
}

@end
