//
//  PFPauseView.h
//  Polyform
//
//  Created by Warren Whipple on 11/3/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFButton.h"

@interface PFPauseView : UIView

@property (readonly, nonatomic) PFButton *menuButton, *restartButton, *playButton;

- (void)reset;
- (void)resume;
- (void)update;

@end
