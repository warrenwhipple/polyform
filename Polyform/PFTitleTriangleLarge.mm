//
//  PFTitleTriangleLarge.m
//  Polyform
//
//  Created by Warren Whipple on 1/9/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFTitlePolygon.h"

static int physicsVertCount = 3;
static float physicsVerts[] = {0.0f,0.0f,1.0f,-0.57735026f,1.0f,0.57735026f};
static int inlineVertCount = 8;
static float inlineVerts[] = {-0.030000102f,0.017320508f,-0.030000102f,0.017320508f,1.0f,0.6119913f,-0.030000102f,-0.017320508f,1.03f,0.5946708f,1.0f,-0.6119913f,1.03f,-0.5946708f,1.03f,-0.5946708f};
static int outlineVertCount = 8;
static float outlineVerts[] = {-0.25f,0.14433756f,-0.25f,0.14433756f,1.0f,0.8660254f,-0.25f,-0.14433756f,1.25f,0.72168785f,1.0f,-0.8660254f,1.25f,-0.72168785f,1.25f,-0.72168785f};

@implementation PFTitleTriangleLarge

- (id)initWithWorld:(b2World*)world position:(b2Vec2)position angle:(float)angle
{
    _species = PFTitlePolygonSpeciesTriangleLarge;
    _physicsVertCount = physicsVertCount;
    _inlineVertCount = inlineVertCount;
    _outlineVertCount = outlineVertCount;
    _physicsVerts = (b2Vec2*)physicsVerts;
    _inlineVerts = (b2Vec2*)inlineVerts;
    _outlineVerts = (b2Vec2*)outlineVerts;
    return [super initWithWorld:world position:position angle:angle];
}

@end
