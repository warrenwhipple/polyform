//
//  PFSegment.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

@class PFBrick;

@interface PFSegment : NSObject

@property (readwrite, nonatomic, weak) PFBrick *parentBrick;
@property (readwrite, nonatomic) float height;
@property (readwrite, nonatomic) float scanLineIntensity;
@property (readwrite, nonatomic) int overlapCount;
@property (readwrite, nonatomic) int overlapTimer;
@property (readwrite, nonatomic) int fuse;

@end
