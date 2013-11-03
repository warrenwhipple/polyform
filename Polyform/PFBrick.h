//
//  PFBrick.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFCamera.h"
#import "PFBody.h"
#import "PFSegment.h"
@class PFGameScene;

// Constants
#define BUBBLE_RADIUS (3.0f) // m
#define RING_RADIUS (6.0f) // m
#define BUBBLE_GLOW_MAX (8)
#define BUBBLE_SPRING_CONSTANT (0.2f) // newtons / m
#define BUBBLE_SPRING_DAMPING (0.7) // 0 - 1 lower is more damping
#define HINT_KICK (0.25f) // m / s
#define HINT_SPRING_CONSTANT (0.02f) // newtons / m
#define SEGMENT_TOUCH_RADIUS_SQ (0.5) // (sqrt(2)/2)^2

@interface PFBrick : PFBody
{
    PFBrickSpecies _species;
    PFBrickState _state;
    BOOL _isSpawning;
    float _spawnRadius;
    b2Vec2 _center;
    int _group;
    
    int _stabilityTimer;
    BOOL _isStacked, _shouldBeLetLoose, _shouldBeDestroyed;
    
    //NSArray *_segments;
    int _segmentCount;
    b2Vec2 *_segmentCenters;
    
    BOOL _bubbleIsAsleep, _ringIsAsleep;
    float _bubbleRadius, _ringRadius;
    UITouch *_touchA, *_touchB;
    float _lastTouchAngle;
    b2Vec2 _lastTouchAPoint, _lastTouchBPoint, _lastTouchMidpoint;
    int _bubbleGlow, _ringGlow;
    
    int _physicsShapeCount;
    int *_physicsShapeVertCounts;
    float **_physicsShapeVerts;
}

@property (readonly, nonatomic) PFBrickSpecies species;
@property (readonly, nonatomic) PFBrickState state;
@property (readonly, nonatomic) BOOL isSpawning;
@property (readonly, nonatomic) float spawnRadius;
@property (readonly, nonatomic) b2Vec2 center;
@property (readonly, nonatomic) int group;

@property (readwrite, nonatomic) int stabilityTimer;
@property (readwrite, nonatomic) BOOL isStacked, shouldBeLetLoose, shouldBeDestroyed;

//@property (readonly, nonatomic) NSArray *segments;

@property (readonly, nonatomic) UITouch *touchA, *touchB;
@property (readonly, nonatomic) BOOL bubbleIsAsleep, ringIsAsleep;
@property (readonly, nonatomic) float bubbleRadius, ringRadius;
@property (readonly, nonatomic) int bubbleGlow, ringGlow;

+ (id)brick:(PFBrickSpecies)species;

+ (id)brickWithGenus:(PFBrickGenus)genus;

- (void)spawnWithPosition:(b2Vec2)position state:(PFBrickState)state;

- (GLKVector2)centerPhysicsVerts;

/*
- (void)spawnWithPosition:(b2Vec2)position
                  angle:(float)angle
                  group:(int)group
               segments:(NSArray*)segments;
*/

/*
- (void)spawnNewBricksInGameScene:(PFGameScene*)gameScene
         withSegmentToBeDestroyed:(PFSegment*)segment;
*/

- (void)updateWithCamera:(PFCamera*)camera;

- (BOOL)isInSolidContactWithAnything;

- (void)changeState:(PFBrickState)state;

- (BOOL)touchVecIsOverSegments:(b2Vec2)touchVec;

- (void)touchDragBegan:(UITouch*)touch
        withTouchPoint:(b2Vec2)touchPoint;

- (void)touchRotateBegan:(UITouch*)touch
          withTouchPoint:(b2Vec2)touchPoint;

- (void)touchSecondBegan:(UITouch*)touch
          withTouchPoint:(b2Vec2)touchPoint;

@end

@interface PFMonomino : PFBrick @end
@interface PFDomino : PFBrick @end
@interface PFTriominoI : PFBrick @end
@interface PFTriominoL : PFBrick @end
@interface PFTetrominoI : PFBrick @end
@interface PFTetrominoJ : PFBrick @end
@interface PFTetrominoL : PFBrick @end
@interface PFTetrominoO : PFBrick @end
@interface PFTetrominoS : PFBrick @end
@interface PFTetrominoT : PFBrick @end
@interface PFTetrominoZ : PFBrick @end

@interface PFMoniamond : PFBrick @end
@interface PFDiamond : PFBrick @end
@interface PFTriamond : PFBrick @end
@interface PFTetriamondC : PFBrick @end
@interface PFTetriamondI : PFBrick @end
@interface PFTetriamondIr : PFBrick @end
@interface PFTetriamondT : PFBrick @end

@interface PFMonoround : PFBrick @end
@interface PFDiround : PFBrick @end
@interface PFTriroundI : PFBrick @end
@interface PFTriroundL : PFBrick @end
@interface PFTriroundT : PFBrick @end
@interface PFTetraroundB : PFBrick @end
@interface PFTetraroundC : PFBrick @end
@interface PFTetraroundD : PFBrick @end
@interface PFTetraroundI : PFBrick @end
@interface PFTetraroundJ : PFBrick @end
@interface PFTetraroundL : PFBrick @end
@interface PFTetraroundO : PFBrick @end
@interface PFTetraroundS : PFBrick @end
@interface PFTetraroundT : PFBrick @end
@interface PFTetraroundZ : PFBrick @end


