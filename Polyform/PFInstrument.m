//
//  PFInstrument.m
//  Polyform
//
//  Created by Warren Whipple on 1/18/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFInstrument.h"

@implementation PFInstrument
{
    NSString *_soundFile;
    int _loopFrameLength;
    ALChannelSource *_channel;
    ALBuffer *_bufferA, *_bufferB;
}

- (id)initWithSoundFile:(NSString*)soundFile
        loopFrameLength:(int)loopFrameLength
{
    if ((self = [super init]))
    {
        _soundFile = soundFile;
        _loopFrameLength = loopFrameLength;
    }
    return self;
}

- (void)willEnterStageWithChannel:(ALChannelSource*)channel
{
    _channel = channel;
    _bufferA = [[OpenALManager sharedInstance] bufferFromFile:_soundFile];
}

- (ALChannelSource*)willExitStageReturnChannel
{
    _bufferA = nil;
    _bufferB = nil;
    ALChannelSource *channelToReturn = _channel;
    _channel = nil;
    return channelToReturn;
}

- (void)updateWithLoopFrameCount:(int)loopFrameCount
                          volume:(float)volume
{
    if (loopFrameCount % _loopFrameLength  == 0) [_channel play:_bufferA];
}

@end
