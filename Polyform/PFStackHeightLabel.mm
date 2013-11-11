//
//  PFStackHeightLabel.m
//  Polyform
//
//  Created by Warren Whipple on 11/3/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFStackHeightLabel.h"

@implementation PFStackHeightLabel
{
    PFCamera *_camera;
    float _stackHeight;
}

- (id)initWithCamera:(PFCamera *)camera
{
    if ((self = [super initWithFrame:CGRectZero]))
    {
        _camera = camera;
        self.text = @"0.0";
        self.font = [UIFont fontWithName:TEXT_16_FONT size:TEXT_16_POINT];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        [self sizeToFit];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.center = CGPointMake(camera.screenSize.width*0.5f,
                                  self.frame.size.height*0.75);
        self.userInteractionEnabled = NO;
        [camera.glkView addSubview:self];
    }
    return self;
}

- (void)updateWithStackHeight:(float)stackHeight
{
    if (stackHeight != _stackHeight)
    {
        _stackHeight = stackHeight;
        self.text = [NSString stringWithFormat:@"%.01f", _stackHeight];
    }
}


@end
