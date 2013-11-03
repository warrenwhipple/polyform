//
//  PFIncrementedScrollHandler.m
//  Polyform
//
//  Created by Warren Whipple on 1/2/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFIncrementedScrollHandler.h"

@implementation PFIncrementedScrollHandler
{
    BOOL _trackXAxis;
    int _itemCount, _easeCount;
    float _itemSpacing, _ptmRatio, _scrollLength, _overscrollLimit, _lastTouchPoint, _lastPosition, _easeStartPosition, _easeDelta, _weightedTouchVelocity;
}

@synthesize position = _position;
@synthesize touch = _touch;

- (id)initTrackXAxisWithItemCount:(int)itemCount itemSpacing:(float)itemSpacing startItem:(int)startItem
{
    return [self initWithItemCount:itemCount itemSpacing:itemSpacing startItem:startItem trackXAxis:YES];
}

- (id)initTrackYAxisWithItemCount:(int)itemCount itemSpacing:(float)itemSpacing startItem:(int)startItem
{
    return [self initWithItemCount:itemCount itemSpacing:itemSpacing startItem:startItem trackXAxis:NO];
}

- (id)initWithItemCount:(int)itemCount
            itemSpacing:(float)itemSpacing
              startItem:(int)startItem
             trackXAxis:(BOOL)trackXAxis
{
    if ((self = [super init]))
    {
        NSAssert(itemCount>1, @"PFIncrementedScrollHandler needs 2 or more items.");
        NSAssert(itemSpacing>0.0f, @"PFIncrementedScrollHandler needs itemSpacing > 0.");
        NSAssert(startItem>=0 && startItem<itemCount, @"PFIncrementedScrollHandler startItem is outside bounds.");
        _itemCount = itemCount;
        _itemSpacing = itemSpacing;
        _scrollLength = itemSpacing * (float)(itemCount - 1);
        _position = itemSpacing * (float)startItem;
        _trackXAxis = trackXAxis;
        _overscrollLimit = itemSpacing * 0.5f;
        _ptmRatio = 1.0f;
        _easeCount = 20;
    }
    return self;
}

- (void)updateWithPTMRatio:(float)ptmRatio
{
    // Pixel:meter ratio is used in other method calculations
    _ptmRatio = ptmRatio;
    
    
    if (_touch)
    {
        switch (_touch.phase)
        {
            case UITouchPhaseBegan:
            case UITouchPhaseMoved:
            case UITouchPhaseStationary:
            {
                // Scroll handler tracks an active touch
                float touchPoint;
                if (_trackXAxis) touchPoint = [_touch locationInView:_touch.view].x;
                else touchPoint = [_touch locationInView:_touch.view].y;
                float touchVelocity = touchPoint - _lastTouchPoint;
                // Touch slips if overscrolling
                if (_position < 0 && touchVelocity > 0)
                    touchVelocity *= (1.0 + (_position / _overscrollLimit));
                else if (_position > _scrollLength && touchVelocity < 0)
                    touchVelocity *= (1.0 - ((_position - _scrollLength) / _overscrollLimit));
                // Update weighted velocity
                _position = _lastPosition - (touchVelocity / _ptmRatio);
                _lastTouchPoint = touchPoint;
                _lastPosition = _position;
                _weightedTouchVelocity = (_weightedTouchVelocity + touchVelocity) / 2.0f;
            } break;
            case UITouchPhaseEnded:
            case UITouchPhaseCancelled:
            {
                // Scroll handler snaps to closest item based on weighted velocity (weighted velocity is used in case of small velocity change on touch release)
                if (_position < 0) [self scrollToItem:0];
                else if (_position > _scrollLength) [self scrollToItem:(_itemCount - 1)];
                else
                {
                    if (_weightedTouchVelocity < -4.0f) [self scrollToItem:ceilf(_position / _itemSpacing)];
                    else if (_weightedTouchVelocity > 4.0f) [self scrollToItem:(_position / _itemSpacing)];
                    else [self scrollToItem:roundf(_position / _itemSpacing)];
                }
                _touch = nil;
            } break;
        }
    }
    // When no touch is active update easing
    else if (_easeCount < 20)
    {
        _easeCount++;
        float tRatio = 1.0f - ((float)_easeCount) / 20.0f;
        _position = _easeDelta * (1.0f - tRatio * tRatio * tRatio) + _easeStartPosition;
    }
}

- (void)touchBegan:(UITouch*)touch
{
    if (!_touch)
    {
        _touch = touch;
        if (_trackXAxis) _lastTouchPoint = [_touch locationInView:_touch.view].x;
        else _lastTouchPoint = [_touch locationInView:_touch.view].y;
        _lastPosition = _position;
        _weightedTouchVelocity = 0.0f;
    }
}

- (int)closestItem
{
    return MAX(0, MIN(_itemCount-1, roundf(_position / _itemSpacing)));
}

- (float)distanceFromItem:(int)item
{
    return ABS(_position - (((float)item) * _itemSpacing));
}

- (float)positionRelativeToItem:(int)item
{
    return _position - (((float)item) * _itemSpacing);
}

- (void)scrollToItem:(int)item
{
    _easeStartPosition = _position;
    _easeStartPosition = _position;
    _easeDelta = item * _itemSpacing - _easeStartPosition;
    _easeCount = 0;
}

@end
