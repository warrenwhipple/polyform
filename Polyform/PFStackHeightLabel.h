//
//  PFStackHeightLabel.h
//  Polyform
//
//  Created by Warren Whipple on 11/3/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCamera.h"

@interface PFStackHeightLabel : UILabel

- (id)initWithCamera:(PFCamera*)camera;

- (void)updateWithStackHeight:(float)stackHeight;

@end
