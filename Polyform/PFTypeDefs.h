//
//  PFBrickTypes.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef union
{
    struct {float x, y, r, g, b, a, space1, space2;};
    struct {float f[8];};
}PFAlignedVert;

typedef enum
{
    PFSceneTypeTitle,
    PFSceneTypeMenu,
    PFSceneTypeGame,
    PFSceneType_MAX = PFSceneTypeGame
}PFSceneType;

typedef enum
{
    PFSceneStateEntering,
    PFSceneStateRunning,
    PFSceneStatePausing,
    PFSceneStatePaused,
    PFSceneStateResuming,
    PFSceneStateGameOver,
    PFSceneStateExiting,
    PFSceneStateExitingFromPause,
    PFSceneStateExitComplete
}PFSceneState;

typedef enum
{
    PFTitlePolygonSpeciesTriangleLarge,
    PFTitlePolygonSpeciesTriangleSmall
}PFTitlePolygonSpecies;

typedef enum
{
    PFBaseTypeRectangle10,
    PFBaseTypeTrapezoid10,
    PFBaseTypeBubble9,
    PFBaseTypeTankBase,
    PFBaseTypeTankWell,
    PFBaseType_MAX = PFBaseTypeTankWell
} PFBaseType;

typedef enum
{
    PFBrickStateLoose,
    PFBrickStateHover,
    PFBrickStateSelected,
    PFBrickStateDrag,
    PFBrickStateRotate,
    PFBrickStateDragRotate
} PFBrickState;

/*
 switch (brick.state)
 {
 case PFBrickStateHinting:
 case PFBrickStateSpawning:
 case PFBrickStateLoose:
 case PFBrickStateHover:
 case PFBrickStateSelected:
 case PFBrickStateDrag:
 case PFBrickStateRotate:
 case PFBrickStateDragRotate: break;
 }
*/

typedef enum
{
    bsMonomino,
    bsDomino,
    bsTriominoI,
    bsTriominoL,
    bsTetrominoI,
    bsTetrominoJ,
    bsTetrominoL,
    bsTetrominoO,
    bsTetrominoS,
    bsTetrominoT,
    bsTetrominoZ,
    bsMoniamond,
    bsDiamond,
    bsTriamond,
    bsTetriamondC,
    bsTetriamondI,
    bsTetriamondIr,
    bsTetriamondT,
    bsMonoround,
    bsDiround,
    bsTriroundI,
    bsTriroundL,
    bsTriroundT,
    bsTetraroundB,
    bsTetraroundC,
    bsTetraroundD,
    bsTetraroundI,
    bsTetraroundJ,
    bsTetraroundL,
    bsTetraroundO,
    bsTetraroundS,
    bsTetraroundT,
    bsTetraroundZ,
    bs_MAX = bsTetraroundZ
} PFBrickSpecies;

typedef enum
{
    bgMonomino,
    bgDomino,
    bgTriomino,
    bgTetromino,
    bgMoniamond,
    bgDiamond,
    bgTriamond,
    bgTetriamond,
    bgMonoround,
    bgDiround,
    bgTriround,
    bgTetraround,
    bg_MAX = bgTetraround
} PFBrickGenus;

typedef enum
{
    bfPolyiamond,
    bfPolyomino,
    bfPolyround,
    bf_MAX = bfPolyround
} PFBrickFamily;

static PFBrickSpecies randomSpeciesFromGenus(PFBrickGenus genus)
{
    switch (genus)
    {
        case bgMonomino: return bsMonomino;
        case bgDomino: return bsDomino;
        case bgTriomino: return (PFBrickSpecies)(bsTriominoI + arc4random_uniform(2));
        case bgTetromino: return (PFBrickSpecies)(bsTetrominoI + arc4random_uniform(7));
        case bgMoniamond: return bsMoniamond;
        case bgDiamond: return bsDiamond;
        case bgTriamond: return bsTriamond;
        case bgTetriamond: return (PFBrickSpecies)(bsTetriamondC + arc4random_uniform(4));
        case bgMonoround: return bsMonoround;
        case bgDiround: return bsDiround;
        case bgTriround: return (PFBrickSpecies)(bsTriroundI + arc4random_uniform(3));
        case bgTetraround: return (PFBrickSpecies)(bsTetraroundB + arc4random_uniform(10));
    }
}

typedef struct
{
    PFBrickGenus brickGenus;
    PFBaseType baseType;
    BOOL scannerIsAvtive;
} PFRuleSet;

static __inline__ PFRuleSet PFRuleSetMake(PFBrickGenus brickGenus, PFBaseType baseType, BOOL scannerIsAvtive)
{
    PFRuleSet r = {brickGenus, baseType, scannerIsAvtive};
    return r;
}

typedef enum
{
    PFIconTypeOne,
    PFIconTypeDrag,
    PFIconTypeRotate,
    PFIconTypePauseButton,
    PFIconTypePlayButton,
    PFIconTypeRestartButton,
    PFIconTypeMenuButton,
    PFIconType_MAX = PFIconTypeMenuButton
} PFIconType;