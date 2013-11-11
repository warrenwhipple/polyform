//
//  PFStackCountLabel.m
//  Polyform
//
//  Created by Warren Whipple on 11/3/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFStackCountLabel.h"

@implementation PFStackCountLabel
{
    PFCamera *_camera;
    int _stackCount;
}

- (id)initWithCamera:(PFCamera *)camera
{
    if ((self = [super initWithFrame:CGRectZero]))
    {
        _camera = camera;
        self.text = @"0";
        self.font = [UIFont fontWithName:TEXT_16_FONT size:TEXT_16_POINT];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        [self sizeToFit];
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width*5.0f,
                                self.frame.size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.center = CGPointMake(camera.screenSize.width*0.5f,
                                  camera.screenSize.height - self.frame.size.height*0.75);
        self.userInteractionEnabled = NO;
        [camera.glkView addSubview:self];
    }
    return self;
}

- (void)updateWithStackCount:(int)stackCount
{
    if (stackCount != _stackCount)
    {
        _stackCount = stackCount;
        self.text = [NSString stringWithFormat:@"%i", _stackCount];
    }
}

@end
