//
//  PFCamera.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "Box2D.h"

@interface PFCamera : NSObject

@property (readonly, nonatomic) CGSize screenSize;
@property (readonly, nonatomic) UIView *glkView;
@property (readonly, nonatomic) float glkLeft;
@property (readonly, nonatomic) float glkRight;
@property (readonly, nonatomic) float glkBottom;
@property (readonly, nonatomic) float glkTop;
@property (readonly, nonatomic) CGRect glkRect;
@property (readonly, nonatomic) float ptmRatio;
@property (readonly, nonatomic) GLKMatrix4 projection;

+ (void)linkView:(UIView*)view;

- (id)initWithGLKMinumumRect:(CGRect)rect;

- (id)initWithGLKMinumumLeft:(float)left
                       right:(float)right
                      bottom:(float)bottom
                         top:(float)top;

- (void)update;

- (void)setGLKMinimumLeft:(float)left
                    right:(float)right
                   bottom:(float)bottom
                      top:(float)top;

- (float)screenXFromGLKX:(float)glkX;
- (float)screenYFromGLKY:(float)glkY;
- (float)glkXFromScreenX:(float)screenX;
- (float)glkYFromScreenY:(float)screenY;

- (CGPoint)screenPointFromGLKVector2:(GLKVector2)vec;
- (CGPoint)screenPointFromB2Vec2:(b2Vec2)vec;
- (GLKVector2)glkVector2FromScreenPoint:(CGPoint)point;
- (b2Vec2)b2Vec2FromScreenPoint:(CGPoint)point;

- (void)touchBegan:(UITouch*)touch;

- (void)touchEnded:(UITouch*)touch;

@end
