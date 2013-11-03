//
//  PFBase.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBody.h"
#import "PFVertHandler.h"

@interface PFBase : NSObject
{
    PFBaseType _type;
    PFBody *_floor;
    PFBody *_walls;
}

@property (readwrite, nonatomic) PFBaseType type;
@property (readonly, nonatomic) PFBody *floor, *walls;
@property (readonly, nonatomic) GLKVector2 *displayVerticies;
@property (readonly, nonatomic) int displayVertexCount;

+ (id)base:(PFBaseType)type;

- (void)spawnWithWidth:(int)width depth:(int)depth;

@end

@interface PFBaseRectangle : PFBase @end
@interface PFBaseTrapezoid : PFBase @end
@interface PFBaseBubble : PFBase @end
