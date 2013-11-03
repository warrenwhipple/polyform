//
//  PFButton.h
//  Polyform
//
//  Created by Warren Whipple on 10/16/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFButton : UIView

@property (readonly, nonatomic) BOOL wasPressed;

- (id)initWithOffImageName:(NSString*)offImage onImageName:(NSString*)onImageName;

- (void)update;

- (void)reset;

@end
