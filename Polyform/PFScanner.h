//
//  PFScanner.h
//  Polyform
//
//  Created by Warren Whipple on 12/21/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFBrick.h"
#import "PFVertHandler.h"
#import "PFCamera.h"

@interface PFScanner : NSObject

- (void)scanBrick:(PFBrick*)brick;

- (NSSet*)returnSegmentsToDestroy;

//- (void)writeToVertHandler:(PFVertHandler*)vertHandler
//                        withCamera:(PFCamera*)camera;

@end
