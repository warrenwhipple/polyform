//
//  PFPauseView.m
//  Polyform
//
//  Created by Warren Whipple on 11/3/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFPauseView.h"

@implementation PFPauseView
{
    UILabel *_gameOverLabel, *_backLabel, *_restartLabel, *_playLabel;
    BOOL _isResuming;
}

@synthesize
menuButton = _menuButton,
restartButton = _restartButton,
playButton = _playButton;

- (id)initWithFrame:(CGRect)frame
{
    float width;
    if (frame.size.width < frame.size.height) width = frame.size.width;
    else width = frame.size.height;
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, width)]))
    {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0f;
        _isResuming = NO;
        
        _gameOverLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gameOverLabel.text = @"pause";
        _gameOverLabel.font = [UIFont fontWithName:TEXT_22_FONT size:TEXT_22_POINT];
        _gameOverLabel.textAlignment = NSTextAlignmentCenter;
        _gameOverLabel.textColor = [UIColor whiteColor];
        _gameOverLabel.backgroundColor = [UIColor clearColor];
        [_gameOverLabel sizeToFit];
        _gameOverLabel.center = CGPointMake(width*0.5f, width*0.5f - _gameOverLabel.bounds.size.height);
        [self addSubview:_gameOverLabel];
        
        _playButton = [[PFButton alloc] initWithOffImageName:@"playoff64.png" onImageName:@"playon64.png"];
        _playButton.center = CGPointMake(width*0.5f, width*0.5f + _gameOverLabel.bounds.size.height);
        [self addSubview:_playButton];
        
        _playLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _playLabel.text = @"play";
        _playLabel.font = [UIFont fontWithName:TEXT_16_FONT size:TEXT_16_POINT];
        _playLabel.textAlignment = NSTextAlignmentCenter;
        _playLabel.textColor = [UIColor whiteColor];
        _playLabel.backgroundColor = [UIColor clearColor];
        [_playLabel sizeToFit];
        _playLabel.center = CGPointMake(_playButton.center.x, _playButton.center.y + _playButton.bounds.size.height);
        [self addSubview:_playLabel];
        
        _menuButton = [[PFButton alloc] initWithOffImageName:@"backoff64.png" onImageName:@"backon64.png"];
        _menuButton.center = CGPointMake(width*1.0f/6.0f, width*0.5f + _gameOverLabel.bounds.size.height);
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
        _restartButton.center = CGPointMake(width*5.0f/6.0f, width*0.5f + _gameOverLabel.bounds.size.height);
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

- (void)reset
{
    [_menuButton reset];
    [_restartButton reset];
    [_playButton reset];
    _isResuming = NO;
}

- (void)resume
{
    _isResuming = YES;
}

- (void)update
{
    if (_isResuming)
    {
        if (self.alpha > 0.0f)
        {
            self.alpha -= 0.05f;
            self.alpha = MAX(self.alpha, 0.0f);
        }
    }
    else
    {
        if (self.alpha < 1.0f)
        {
            self.alpha += 0.05f;
            self.alpha = MIN(self.alpha, 1.0f);
        }
    }
    [_menuButton update];
    [_restartButton update];
    [_playButton update];
}

@end
