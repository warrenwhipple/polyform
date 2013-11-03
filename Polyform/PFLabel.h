//
//  PFLabel.h
//  Polyform
//
//  Created by Warren Whipple on 9/10/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCamera.h"

@interface PFLabel : UILabel

@property (readwrite, nonatomic) GLKVector2 glkCenter;
@property (readwrite, nonatomic) float glkHeight;

+ (void)bindGLKView:(UIView*)glkView;

- (id)initWithCamera:(PFCamera*)camera
           glkCenter:(GLKVector2)glkCenter
           glkHeight:(float)glkHeight
                text:(NSString*)text;

- (void)appear;
- (void)disappear;
- (void)update;

@end
