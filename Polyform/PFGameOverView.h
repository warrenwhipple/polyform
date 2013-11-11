//
//  PFGameOverView.h
//  Polyform
//
//  Created by Warren Whipple on 9/14/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFButton.h"

@interface PFGameOverView : UIView

@property (readonly, nonatomic) PFButton *menuButton, *restartButton;

- (void)update;

@end
