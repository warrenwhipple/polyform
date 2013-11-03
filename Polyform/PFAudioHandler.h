//
//  PFAudioHandler.h
//  Polyform
//
//  Created by Warren Whipple on 1/14/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

@interface PFAudioHandler : NSObject

@property (readonly, nonatomic) int loopFrameCount;

- (void)transitionToNewInstrumentCount:(int)instrumentCount;

- (void)updateWithInstrumentDistribution:(int*)instrumentDistribution;

- (void)pauseWithBackgroundRunning;

- (void)resumeFromBackgroundRunning;

- (void)stopAllInstruments;

@end
