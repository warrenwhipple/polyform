//
//  PFGameOverView.m
//  Polyform
//
//  Created by Warren Whipple on 9/14/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFGameOverView.h"
#import "PFButton.h"

@implementation PFGameOverView
{
    UILabel *_gameOverLabel, *_backLabel, *_restartLabel;
}

@synthesize
menuButton = _menuButton,
restartButton = _restartButton;

- (id)initWithFrame:(CGRect)frame
{
    float width;
    if (frame.size.width < frame.size.height) width = frame.size.width;
    else width = frame.size.height;
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, width)]))
    {
        self.center = CGPointMake(frame.size.width*0.5f, frame.size.height*0.5f);
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0f;
        
        _gameOverLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gameOverLabel.text = @"game over";
        _gameOverLabel.font = [UIFont fontWithName:TEXT_22_FONT size:TEXT_22_POINT];
        _gameOverLabel.textAlignment = NSTextAlignmentCenter;
        _gameOverLabel.textColor = [UIColor whiteColor];
        _gameOverLabel.backgroundColor = [UIColor clearColor];
        [_gameOverLabel sizeToFit];
        _gameOverLabel.center = CGPointMake(width*0.5f, width*0.5f - _gameOverLabel.bounds.size.height);
        [self addSubview:_gameOverLabel];
        
        _menuButton = [[PFButton alloc] initWithOffImageName:@"backoff64.png" onImageName:@"backon64.png"];
        _menuButton.center = CGPointMake(width*0.25f, width*0.5f + _gameOverLabel.bounds.size.height);
        [self addSubview:_menuButton];
        
        _backLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _backLabel.text = @"menu";
        _backLabel.font = [UIFont fontWithName:TEXT_16_FONT size:TEXT_16_POINT];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.textColor = [UIColor whiteColor];
        _backLabel.backgroundColor = [UIColor clearColor];
        [_backLabel sizeToFit];
        _backLabel.center = CGPointMake(_menuButton.center.x, _menuButton.center.y + _menuButton.bounds.size.height);
        [self addSubview:_backLabel];
        
        _restartButton = [[PFButton alloc] initWithOffImageName:@"restartoff64.png" onImageName:@"restarton64.png"];
        _restartButton.center = CGPointMake(width*0.75f, width*0.5f + _gameOverLabel.bounds.size.height);
        [self addSubview:_restartButton];

        _restartLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _restartLabel.text = @"restart";
        _restartLabel.font = [UIFont fontWithName:TEXT_16_FONT size:TEXT_16_POINT];
        _restartLabel.textAlignment = NSTextAlignmentCenter;
        _restartLabel.textColor = [UIColor whiteColor];
        _restartLabel.backgroundColor = [UIColor clearColor];
        [_restartLabel sizeToFit];
        _restartLabel.center = CGPointMake(_restartButton.center.x, _restartButton.center.y + _restartButton.bounds.size.height);
        [self addSubview:_restartLabel];
    }
    return self;
}

- (void)update
{
    if (self.alpha < 1.0f) self.alpha += 0.01f;
    [_menuButton update];
    [_restartButton update];
}

@end
