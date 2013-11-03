//
//  PFTitlePolygon.h
//  Polyform
//
//  Created by Warren Whipple on 1/9/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFBody.h"

@interface PFTitlePolygon : PFBody
{
    int _physicsVertCount, _inlineVertCount, _outlineVertCount;
    b2Vec2 *_physicsVerts, *_inlineVerts, *_outlineVerts;
    PFTitlePolygonSpecies _species;
}

@property (readonly, nonatomic) PFTitlePolygonSpecies species;

- (id)initWithWorld:(b2World*)world position:(b2Vec2)position angle:(float)angle;

@end

@interface PFTitleTriangleLarge : PFTitlePolygon @end
@interface PFTitleTriangleSmall : PFTitlePolygon @end