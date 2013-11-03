//
//  PFInstrument.h
//  Polyform
//
//  Created by Warren Whipple on 1/18/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "ObjectAL.h"

@interface PFInstrument : NSObject

- (id)initWithSoundFile:(NSString*)soundFile
        loopFrameLength:(int)loopFrameLength;

- (void)willEnterStageWithChannel:(ALChannelSource*)channel;

- (ALChannelSource*)willExitStageReturnChannel;

- (void)updateWithLoopFrameCount:(int)loopFrameCount
                          volume:(float)volume;

@end
