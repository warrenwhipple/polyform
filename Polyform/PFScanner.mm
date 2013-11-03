//
//  PFScanner.m
//  Polyform
//
//  Created by Warren Whipple on 12/21/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFScanner.h"
#import "PFSegment.h"

@implementation PFScanner
{
    NSMutableSet *_segmentsToScan;
    NSMutableSet *_segmentsToScanAgain;
    NSMutableSet *_segmentsWithLitFuse;
    NSMutableSet *_segmentsToDestroy;
    NSMutableSet *_segmentsWithScanLines;
    NSMutableSet *_segmentsToRemove;
}

- (id)init
{
    if ((self = [super init]))
    {
        _segmentsToScan = [NSMutableSet setWithCapacity:MAX_SEGMENT_COUNT];
        _segmentsToScanAgain = [NSMutableSet setWithCapacity:MAX_SEGMENT_COUNT/4];
        _segmentsWithLitFuse = [NSMutableSet setWithCapacity:MAX_SEGMENT_COUNT/4];
        _segmentsToDestroy = [NSMutableSet setWithCapacity:MAX_SEGMENT_COUNT/4];
        _segmentsWithScanLines = [NSMutableSet setWithCapacity:MAX_SEGMENT_COUNT/2];
        _segmentsToRemove = [NSMutableSet setWithCapacity:MAX_SEGMENT_COUNT/4];
    }
    return self;
}

- (void)scanBrick:(PFBrick *)brick
{
    {
        if (brick.body->GetLinearVelocity().LengthSquared() < STABILITY_VEL_SQ &&
            brick.body->GetAngularVelocity() < STABILITY_ANGVEL)
            brick.stabilityTimer++;
        else brick.stabilityTimer = 0;
        if (brick.stabilityTimer >= STABILITY_TIMER)
            [_segmentsToScan addObjectsFromArray:brick.segments];
        else for (PFSegment *segment in brick.segments) segment.overlapTimer = 0;
    }
}

- (NSSet*)returnSegmentsToDestroy
{
    [_segmentsToDestroy removeAllObjects];
    
    // Scan the first time to catch any segment near others.
    for (PFSegment *segment in _segmentsToScan)
    {
        segment.overlapCount = 1;
        float upperBound = segment.height + SCAN_HALF_RANGE;
        float lowerBound = segment.height - SCAN_HALF_RANGE;
        for (PFSegment *other in _segmentsToScan)
        {
            if (segment != other)
            {
                if (other.height<upperBound && other.height>lowerBound)
                    segment.overlapCount++;
                if (segment.overlapCount == SCAN_OVERLAP_COUNT)
                {
                    [_segmentsToScanAgain addObject:segment];
                    break;
                }
            }
        }
        if (segment.overlapCount < SCAN_OVERLAP_COUNT) segment.overlapTimer = 0;
        if (segment.overlapCount >= SCAN_OVERLAP_COUNT - 2) [_segmentsWithScanLines addObject:segment];
    }
    [_segmentsToScan removeAllObjects];
    
    // Adjust scan line intensity.
    for (PFSegment *segment in _segmentsWithScanLines)
    {
        switch (segment.overlapCount)
        {
            case SCAN_OVERLAP_COUNT - 2:
                if (segment.scanLineIntensity < 0.2f) segment.scanLineIntensity += 0.1f;
                else if (segment.scanLineIntensity > 0.2f) segment.scanLineIntensity -= 0.1f;
                break;
            case SCAN_OVERLAP_COUNT - 1:
                if (segment.scanLineIntensity < 0.4f) segment.scanLineIntensity += 0.1f;
                else if (segment.scanLineIntensity > 0.4f) segment.scanLineIntensity -= 0.1f;
                break;
            case SCAN_OVERLAP_COUNT:
                if (segment.scanLineIntensity < 0.6f) segment.scanLineIntensity += 0.1f;
                else if (segment.scanLineIntensity > 0.6f) segment.scanLineIntensity -= 0.1f;
                break;
            default:
                segment.scanLineIntensity -= 0.1f;
                break;
        }
        if (segment.scanLineIntensity <= 0.0f) [_segmentsToRemove addObject:segment];
    }
    [_segmentsWithScanLines minusSet:_segmentsToRemove];
    [_segmentsToRemove removeAllObjects];
    
    // Scan a second time to catch only segments in groups. 
    for (PFSegment *segment in _segmentsToScanAgain)
    {
        segment.overlapCount = 1;
        float upperBound = segment.height + SCAN_HALF_RANGE;
        float lowerBound = segment.height - SCAN_HALF_RANGE;
        for (PFSegment *other in _segmentsToScanAgain)
        {
            if (segment != other)
            {
                if (other.height<upperBound && other.height>lowerBound) segment.overlapCount++;
                if (segment.overlapCount == SCAN_OVERLAP_COUNT)
                {
                    segment.overlapTimer++;
                    if (segment.overlapTimer >= SCAN_OVERLAP_TIMER)
                    {
                        [_segmentsWithLitFuse addObject:segment];
                    }
                    break;
                }
            }
        }
        if (segment.overlapCount < SCAN_OVERLAP_COUNT) segment.overlapTimer = 0;
    }
    [_segmentsToScanAgain removeAllObjects];
    
    for (PFSegment *segment in _segmentsWithLitFuse)
    {
        segment.fuse++;
        if (segment.fuse >= SCAN_DESTRUCTION_FUSE)
        {
            segment.overlapCount = 0;
            [_segmentsToDestroy addObject:segment];
        }
    }
    [_segmentsWithLitFuse minusSet:_segmentsToDestroy];
    return _segmentsToDestroy;
}

/*
- (void)writeToVertHandler:(PFVertHandler *)vertHandler
                withCamera:(PFCamera *)camera
{
    GLKVector4 edgeColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.0f);
    for (PFSegment *segment in _segmentsWithScanLines)
    {
        GLKVector4 centerColor = GLKVector4Make(1.0f, 0.0f, 0.0f, segment.scanLineIntensity*0.1f);
        float h = segment.height;
        float l = camera.glkLeft;
        float r = camera.glkRight;
        float b = 0.5f;
        [vertHandler changeColor:edgeColor];
        
        [vertHandler addVert:(GLKVector2){{l,h-b}}];
        [vertHandler addVert:(GLKVector2){{l,h-b}}];
        [vertHandler addVert:(GLKVector2){{r,h-b}}];
        [vertHandler changeColor:centerColor];
        [vertHandler addVert:(GLKVector2){{l,h}}];
        [vertHandler addVert:(GLKVector2){{r,h}}];
        [vertHandler changeColor:edgeColor];
        [vertHandler addVert:(GLKVector2){{l,h+b}}];
        [vertHandler addVert:(GLKVector2){{r,h+b}}];
        [vertHandler addVert:(GLKVector2){{r,h+b}}];
         
    }
}
 */

@end
