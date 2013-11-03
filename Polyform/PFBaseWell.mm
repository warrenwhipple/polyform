//
//  PFBaseWell.mm
//  Polyform
//
//  Created by Warren Whipple on 12/23/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBase.h"

static int physicsVertCount;
static GLKVector2 outlineVerts[10];
static GLKVector2 inlineVerts[10];

@implementation PFBaseWell

- (id)initWithWorld:(b2World*)world
              width:(float)w
              depth:(float)d
{
    if ((self = [super init]))
    {
        physicsVertCount = 4;
        b2Vec2 physicsVerts[4] = {
            b2Vec2(-w/2.0f,d),
            b2Vec2(-w/2.0f,0.0f),
            b2Vec2(w/2.0f,0.0f),
            b2Vec2(w/2.0f,d)
        };
        
        int outlineVertCount = 10;
        outlineVerts[0] = {-w/2.0f+OUTLINE_OFFSET,d};
        outlineVerts[1] = outlineVerts[0];
        outlineVerts[2] = {-w/2.0f+INLINE_OFFSET,d};
        outlineVerts[3] = {-w/2.0f+OUTLINE_OFFSET,+OUTLINE_OFFSET};
        outlineVerts[4] = {-w/2.0f+INLINE_OFFSET,INLINE_OFFSET};
        outlineVerts[5] = {w/2.0f-OUTLINE_OFFSET,OUTLINE_OFFSET};
        outlineVerts[6] = {w/2.0f-INLINE_OFFSET,INLINE_OFFSET};
        outlineVerts[7] = {w/2.0f-OUTLINE_OFFSET,d};
        outlineVerts[8] = {w/2.0f-INLINE_OFFSET,d};
        outlineVerts[9] = outlineVerts[8];
        int inlineVertCount = 10;
        inlineVerts[0] = {-w/2.0f+INLINE_OFFSET,d};
        inlineVerts[1] = inlineVerts[0];
        inlineVerts[2] = {-w/2.0f+WELL_FADE_WIDTH,d};
        inlineVerts[3] = {-w/2.0f+INLINE_OFFSET,+INLINE_OFFSET};
        inlineVerts[4] = {-w/2.0f+WELL_FADE_WIDTH,WELL_FADE_WIDTH};
        inlineVerts[5] = {w/2.0f-INLINE_OFFSET,INLINE_OFFSET};
        inlineVerts[6] = {w/2.0f-WELL_FADE_WIDTH,WELL_FADE_WIDTH};
        inlineVerts[7] = {w/2.0f-INLINE_OFFSET,d};
        inlineVerts[8] = {w/2.0f-WELL_FADE_WIDTH,d};
        inlineVerts[9] = inlineVerts[8];
        
        _floor = [[PFBody alloc] init];
        _walls = [[PFBody alloc] init];

        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        
        bodyDef.userData = (__bridge void*)_floor;
        _floor.body = world->CreateBody(&bodyDef);
        b2FixtureDef fixtureDef;
        b2EdgeShape floorShape;
        floorShape.Set(physicsVerts[1], physicsVerts[2]);
        fixtureDef.shape = &floorShape;
        fixtureDef.friction = DEFAULT_FRICTION;
        fixtureDef.restitution = DEFAULT_RESTITUTION;
        _floor.body->CreateFixture(&fixtureDef);
        
        bodyDef.userData = (__bridge void*)_walls;
        _walls.body = world->CreateBody(&bodyDef);
        b2EdgeShape wallLeftShape;
        wallLeftShape.Set(physicsVerts[0], physicsVerts[1]);
        fixtureDef.shape = &wallLeftShape;
        _walls.body->CreateFixture(&fixtureDef);
        
        b2EdgeShape wallRightShape;
        wallRightShape.Set(physicsVerts[2], physicsVerts[3]);
        fixtureDef.shape = &wallRightShape;
        _walls.body->CreateFixture(&fixtureDef);
        
        _outlineVertCount = outlineVertCount;
        _outlineVerts = outlineVerts;
        _inlineVertCount = inlineVertCount;
        _inlineVerts = inlineVerts;
        
    }
    return self;
}

/*
- (void)writeInlineToVertHandler:(PFVertHandler *)vertHandler
{
    GLKVector4 inlineColor = [vertHandler currentColor];
    GLKVector4 fadeColor = inlineColor;
    fadeColor.a = 0.0f;
    [vertHandler changeColor:inlineColor];
    [vertHandler addVert:inlineVerts[0]];
    [vertHandler addVert:inlineVerts[1]];
    [vertHandler changeColor:fadeColor];
    [vertHandler addVert:inlineVerts[2]];
    [vertHandler changeColor:inlineColor];
    [vertHandler addVert:inlineVerts[3]];
    [vertHandler changeColor:fadeColor];
    [vertHandler addVert:inlineVerts[4]];
    [vertHandler changeColor:inlineColor];
    [vertHandler addVert:inlineVerts[5]];
    [vertHandler changeColor:fadeColor];
    [vertHandler addVert:inlineVerts[6]];
    [vertHandler changeColor:inlineColor];
    [vertHandler addVert:inlineVerts[7]];
    [vertHandler changeColor:fadeColor];
    [vertHandler addVert:inlineVerts[8]];
    [vertHandler addVert:inlineVerts[9]];
}
*/
@end
