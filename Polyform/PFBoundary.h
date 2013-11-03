//
//  PFBoundary.h
//  Polyform
//
//  Created by Warren Whipple on 1/23/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFVertHandler.h"

@interface PFBoundary : NSObject

@property (readonly, nonatomic) float left, right, bottom, top;

- (id)initWithScreenSize:(CGSize)screenSize;

- (void)boundBrick:(PFBrick*)brick;

- (void)writeToVertHandler:(PFVertHandler*)vertHandler;

@end
