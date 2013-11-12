//
//  PFVertHandler.h
//  Polyform
//
//  Created by Warren Whipple on 12/31/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFTitlePolygon.h"

@class PFBrick;
@class PFCamera;
@class PFBase;

@interface PFVertHandler : NSObject

@property (readonly, nonatomic) int bubbleVertCount;
@property (readonly, nonatomic) PFAlignedVert *bubbleVerts;
@property (readonly, nonatomic) GLushort *indices;
@property (readonly, nonatomic) int indexCount;
@property (readonly, nonatomic) PFAlignedVert *verts;
@property (readonly, nonatomic) int vertCount;

- (void)unloadAllModels;
- (void)loadModelsForSceneType:(PFSceneType)sceneType;
- (void)loadModelsForBrickGenus:(PFBrickGenus)brickGenus;
- (void)loadModelsForSmallCirclePoints:(int)smallCirclePoints
                     largeCirclePoints:(int)largeCirclePoints;

- (void)resetDraw;
- (void)changeColor:(GLKVector4)color;
- (void)changeSceneBrightness:(float)sceneBrightness;
- (void)changeLineBrightness:(float)lineBrightness;
- (void)addTitlePolygon:(PFTitlePolygon*)polygon outline:(BOOL)outline;
- (void)addHints:(NSMutableSet*)hints;
- (void)addBrick:(PFBrick*)brick withOffset:(GLKVector2)offset;
- (void)addGameBricks:(NSMutableSet*)bricks
    withSelectedBrick:(PFBrick*)selectedBrick
           colorCount:(int)colorCount
               colors:(GLKVector4*)colors;
- (void)addBase:(PFBase*)base;
- (void)addRect:(CGRect)rect;
- (void)addCircleWithPosition:(GLKVector2)position radius:(float)radius;
- (void)addInteger:(int)number withCenter:(GLKVector2)center height:(float)height;

@end
