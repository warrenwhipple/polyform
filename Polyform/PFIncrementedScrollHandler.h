//
//  PFIncrementedScrollHandler.h
//  Polyform
//
//  Created by Warren Whipple on 1/2/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

@interface PFIncrementedScrollHandler : NSObject

@property (readonly, nonatomic) float position;
@property (readonly, nonatomic) UITouch *touch;

- (id)initTrackXAxisWithItemCount:(int)itemCount
                      itemSpacing:(float)itemSpacing
                        startItem:(int)startItem;

- (id)initTrackYAxisWithItemCount:(int)itemCount
                      itemSpacing:(float)itemSpacing
                        startItem:(int)startItem;

- (void)updateWithPTMRatio:(float)ptmRatio;
- (void)touchBegan:(UITouch*)touch;
- (int)closestItem;
- (float)distanceFromItem:(int)item;
- (float)positionRelativeToItem:(int)item;
- (void)scrollToItem:(int)item;

@end
