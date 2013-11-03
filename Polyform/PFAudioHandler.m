//
//  PFAudioHandler.m
//  Polyform
//
//  Created by Warren Whipple on 1/14/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFAudioHandler.h"
#import "ObjectAL.h"
#import "PFInstrument.h"

#define MAX_SOUND_SOURCES (32)

@implementation PFAudioHandler
{
    ALDevice *_device;
    ALContext *_context;
    NSMutableArray *_offStageInstruments;
    NSMutableArray *_onStageInstruments;
    NSMutableArray *_offStageChannels;
}

@synthesize loopFrameCount = _loopFrameCount;

- (id)init
{
    if ((self = [super init]))
    {
        _device = [ALDevice deviceWithDeviceSpecifier:nil];
        _context = [ALContext contextOnDevice:_device attributes:nil];
        [OpenALManager sharedInstance].currentContext = _context;
        [OALAudioSession sharedInstance].handleInterruptions = YES;
        [OALAudioSession sharedInstance].allowIpod = NO;
        [OALAudioSession sharedInstance].honorSilentSwitch = YES;
        
        NSArray *loopFiles = [NSArray arrayWithObjects:
                              @"Autumn-Synth-Base-8s.caf",
                              @"Breaks-Brick-Wall-Beat-01-4s.caf",
                              @"Classic-Funk-Synth-03-4s.caf",
                              @"Deep-Electric-Piano-01-4s.caf",
                              @"Disco-Pickbase-03-8s.caf",
                              @"Techno-Bass-02-4s.caf",
                              @"Techno-Binary-Beat-01-2s.caf",
                              @"Trance-Tunnel-Pad-8s.caf",
                              @"Trance-Tunnel-Synth-01-8s.caf",
                              @"80s-Dance-Base-Synth-02-4s.caf",
                              nil];
        int loopSecondLengths[] = {8,4,4,4,8,4,2,8,8,4};
        _offStageInstruments = [NSMutableArray arrayWithCapacity:loopFiles.count];
        for (int i = 0; i < loopFiles.count; i++)
            [_offStageInstruments addObject:[[PFInstrument alloc] initWithSoundFile:[loopFiles objectAtIndex:i]
                                                                    loopFrameLength:loopSecondLengths[i]*30]];
        _onStageInstruments = [NSMutableArray arrayWithCapacity:MAX_SOUND_SOURCES/2];
        _offStageChannels = [NSMutableArray arrayWithCapacity:MAX_SOUND_SOURCES/2];
        for (int c= 0; c < MAX_SOUND_SOURCES/2; c++)
            [_offStageChannels addObject:[ALChannelSource channelWithSources:2]];
    }
    return self;
}

- (void)transitionToNewInstrumentCount:(int)newInstrumentCount
{
    NSAssert(newInstrumentCount<=MAX_SOUND_SOURCES/2, @"Too many instruments ordered on stage: 16 max.");
    if (newInstrumentCount > _onStageInstruments.count)
    {
        int numToAdd = newInstrumentCount - _onStageInstruments.count;
        for (int i=0; i< numToAdd; i++)
        {
            NSAssert(_offStageInstruments>0, @"Ran out of off stage instruments.");
            PFInstrument *enteringInstrument =[_offStageInstruments
                                               objectAtIndex:arc4random_uniform(_offStageInstruments.count)];
            [_offStageInstruments removeObject:enteringInstrument];
            [enteringInstrument willEnterStageWithChannel:[_offStageChannels objectAtIndex:0]];
            [_offStageChannels removeObjectAtIndex:0];
            [_onStageInstruments addObject:enteringInstrument];
        }
        
    }
    else if (newInstrumentCount < _onStageInstruments.count)
    {
        
    }
}

- (void)updateWithInstrumentDistribution:(int*)instrumentDistribution
{
    for (PFInstrument *instrument in _onStageInstruments)
        [instrument updateWithLoopFrameCount:_loopFrameCount volume:1.0];
    _loopFrameCount++;
    if (_loopFrameCount >= FRAMES_PER_LOOP) _loopFrameCount = 0;
}

- (void)pauseWithBackgroundRunning
{
    
}

- (void)resumeFromBackgroundRunning
{
    
}

- (void) stopAllInstruments
{
    
}

@end
