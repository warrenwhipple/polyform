//
//  PFTitleTriangleSmall.m
//  Polyform
//
//  Created by Warren Whipple on 1/9/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFTitlePolygon.h"

static int physicsVertCount = 3;
static float physicsVerts[] = {0.0f,0.0f,0.5f,-0.28867513f,0.5f,0.28867513f};
static int inlineVertCount = 8;
static float inlineVerts[] = {-0.03f,-0.017320508f,-0.03f,-0.017320508f,-0.03f,0.017320508f,0.5f,-0.32331616f,0.5f,0.32331616f,0.53f,-0.30599564f,0.53f,0.30599564f,0.53f,0.30599564f};
static int outlineVertCount = 8;
static float outlineVerts[] = {-0.25f,-0.14433756f,-0.25f,-0.14433756f,-0.25f,0.14433756f,0.5f,-0.57735026f,0.5f,0.57735026f,0.75f,-0.4330127f,0.75f,0.4330127f,0.75f,0.4330127f};

@implementation PFTitleTriangleSmall

- (id)initWithWorld:(b2World*)world position:(b2Vec2)position angle:(float)angle
{
    _species = PFTitlePolygonSpeciesTriangleSmall;
    _physicsVertCount = physicsVertCount;
    _inlineVertCount = inlineVertCount;
    _outlineVertCount = outlineVertCount;
    _physicsVerts = (b2Vec2*)physicsVerts;
    _inlineVerts = (b2Vec2*)inlineVerts;
    _outlineVerts = (b2Vec2*)outlineVerts;
    return [super initWithWorld:world position:position angle:angle];
}

@end
