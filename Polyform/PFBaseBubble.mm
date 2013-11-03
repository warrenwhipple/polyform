//
//  PFBaseBubble.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBase.h"

@implementation PFBaseBubble

- (void)spawnWithWidth:(int)w
                 depth:(int)d
{
    _floor = [[PFBody alloc] init];
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.userData = (__bridge void*)self;
    _floor.body = [PFBody sharedWorld]->CreateBody(&bodyDef);
    b2FixtureDef fixtureDef;
    fixtureDef.friction = DEFAULT_FRICTION;
    fixtureDef.restitution = DEFAULT_RESTITUTION;
    
    b2CircleShape shape;
    for (int i=0; i<d; i++)
        for (int j=0; j<w; j++)
        {
            shape.m_p = b2Vec2(-(float)(w-1)*RRAD + (float)j*2.0f*RRAD,
                               -(float)i*2.0f*RRAD - 0.5f*RSTACK);
            shape.m_radius = RRAD;
            fixtureDef.shape = &shape;
            _floor.body->CreateFixture(&fixtureDef);
        }
}

@end
