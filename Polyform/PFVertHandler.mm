//
//  PFVertHandler.mm
//  Polyform
//
//  Created by Warren Whipple on 12/31/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "Box2D.h"
#import "PFVertHandler.h"
#import "PFHint.h"
#import "PFBrick.h"
#import "PFBase.h"
#import "PFCamera.h"

#define MAX_VERTS USHRT_MAX
#define MAX_INDICES USHRT_MAX
#define BUBBLE_DIM (0.1f)
#define BUBBLE_GLOW (0.1f)
#define BUBBLE_MASK_WIDTH (0.1f)
#define HINT_RING_WIDTH (0.2f)
static __inline__ b2Vec2 b2(GLKVector2 v)
{
    b2Vec2 w = {v.x,v.y};
    return w;
}

static __inline__ GLKVector2 glk(b2Vec2 v)
{
    GLKVector2 w = {v.x,v.y};
    return w;
}

@implementation PFVertHandler
{
    GLKVector2 **_brickVerts, **_baseVerts, **_digitVerts;
    GLKVector2 *_brickCenters;
    int *_brickVertCounts, *_baseVertCounts, *_digitVertCounts;
    GLushort **_brickIndices, **_baseIndices, **_digitIndices;
    int *_brickIndexCounts, *_baseIndexCounts, *_digitIndexCounts;
    int _brickEnumCount, _baseEnumCount, _digitEnumCount;
    
    GLKVector2 *_smallCircleVerts, *_largeCircleVerts, *_smallCircleOutlineVerts;
    int _smallCircleVertCount, _largeCircleVertCount, _smallCircleOutlineVertCount;
    
    GLKVector4 _currentColor;
    float _sceneBrightness, _lineBrightness;
}

@synthesize
bubbleVerts = _bubbleVerts,
bubbleVertCount = _bubbleVertCount,
verts = _verts,
vertCount = _vertCount,
indices = _indices,
indexCount = _indexCount;

- (id)init
{
    if ((self = [super init]))
    {
        _brickEnumCount = bs_MAX + 1;
        _baseEnumCount = PFBaseType_MAX - 1; // 2 less because TankBase and TankWell are never drawn
        _digitEnumCount = 10;
        
        // malloc because verts used are always overwritten
        _brickVerts =  (GLKVector2**)malloc(sizeof(GLKVector2*)*_brickEnumCount);
        _baseVerts =   (GLKVector2**)malloc(sizeof(GLKVector2*)*_baseEnumCount);
        _digitVerts = (GLKVector2**)malloc(sizeof(GLKVector2*)*_digitEnumCount);
        
        _brickIndices =  (GLushort**)malloc(sizeof(GLushort*)*_brickEnumCount);
        _baseIndices =   (GLushort**)malloc(sizeof(GLushort*)*_baseEnumCount);
        _digitIndices = (GLushort**)malloc(sizeof(GLushort*)*_digitEnumCount);
        
        // calloc because counts need to be zeroed
        _brickVertCounts =  (int*)calloc(sizeof(int), _brickEnumCount);
        _baseVertCounts =   (int*)calloc(sizeof(int), _baseEnumCount);
        _digitVertCounts = (int*)calloc(sizeof(int), _digitEnumCount);
        
        _brickIndexCounts =  (int*)calloc(sizeof(int), _brickEnumCount);
        _baseIndexCounts =   (int*)calloc(sizeof(int), _baseEnumCount);
        _digitIndexCounts = (int*)calloc(sizeof(int), _digitEnumCount);
        
        _bubbleVerts = (PFAlignedVert*)malloc(sizeof(PFAlignedVert)*MAX_VERTS);
        _verts = (PFAlignedVert*)malloc(sizeof(PFAlignedVert)*MAX_VERTS);
        _indices = (GLushort*)malloc(sizeof(GLushort)*MAX_INDICES);
        
        _bubbleVertCount = 0;
        _vertCount = 0;
        _indexCount = 0;
        
        _sceneBrightness = 1.0f;
        _lineBrightness = 1.0f;
        
        // center physics models and record centers
        _brickCenters = (GLKVector2*)calloc(sizeof(GLKVector2), bs_MAX+1);
        for (int s=0; s<=bs_MAX; s++)
        {
            PFBrick *brick = [PFBrick brick:(PFBrickSpecies)s];
            _brickCenters[s] = [brick centerPhysicsVerts];
        }
    }
    return self;
}

- (void)dealloc
{
    [self unloadAllModels];
    
    free(_brickIndices);
    free(_baseIndices);
    free(_digitIndices);
    
    free(_brickVerts);
    free(_baseVerts);
    free(_digitVerts);

    free(_brickIndexCounts);
    free(_baseIndexCounts);
    free(_digitIndexCounts);
    
    free(_brickVertCounts);
    free(_baseVertCounts);
    free(_digitVertCounts);
    
    free(_bubbleVerts);
    free(_verts);
    free(_indices);
    
    free(_brickCenters);
}

#pragma mark - Model Loading Methods

- (void)unloadAllModels
{
    for (int i=0; i<_brickEnumCount; i++)
    {
        if (_brickVertCounts[i] > 0)
        {
            free(_brickVerts[i]);
            _brickVerts[i] = nil;
            _brickVertCounts[i] = 0;
        }
        if (_brickIndexCounts[i] > 0)
        {
            free(_brickIndices[i]);
            _brickIndices[i] = nil;
            _brickIndexCounts[i] = 0;
        }
    }
    for (int i=0; i<_baseEnumCount; i++)
    {
        if (_baseVertCounts[i] > 0)
        {
            free(_baseVerts[i]);
            _baseVertCounts[i] = 0;
        }
        if (_baseIndexCounts[i] > 0)
        {
            free(_baseIndices[i]);
            _baseIndexCounts[i] = 0;
        }
    }
    for (int i=0; i<_digitEnumCount; i++)
    {
        if (_digitVertCounts[i] > 0)
        {
            free(_digitVerts[i]);
            _digitVertCounts[i] = 0;
        }
        if (_digitIndexCounts[i] > 0)
        {
            free(_digitIndices[i]);
            _digitIndexCounts[i] = 0;
        }
    }
    if (_smallCircleVertCount > 0)
    {
        free(_smallCircleVerts);
        _smallCircleVertCount = 0;
    }
    if (_largeCircleVertCount > 0)
    {
        free(_largeCircleVerts);
        _largeCircleVertCount = 0;
    }
    if (_smallCircleOutlineVertCount > 0)
    {
        free(_smallCircleOutlineVerts);
        _smallCircleOutlineVertCount = 0;
    }
}

- (void)loadModelsForSceneType:(PFSceneType)sceneType
{
    NSArray *jsonArray;
    switch (sceneType)
    {
        case PFSceneTypeTitle:
        {
            jsonArray = [self jsonArrayForFile:@"titleTriangles"];
            for (int n=0; n<4; n++)
                [self loadModelIntoVerts:_brickVerts
                              vertCounts:_brickVertCounts
                                 indices:_brickIndices
                             indexCounts:_brickIndexCounts
                             withEnumNum:n
                               jsonArray:jsonArray];
        } break;
        case PFSceneTypeMenu:
        {
            jsonArray = [self jsonArrayForFile:@"menuBricks"];
            for (int n=0; n<=bs_MAX; n++)
                [self loadModelIntoVerts:_brickVerts
                              vertCounts:_brickVertCounts
                                 indices:_brickIndices
                             indexCounts:_brickIndexCounts
                             withEnumNum:n
                               jsonArray:jsonArray];
            // center models
            for (int s=0; s<=bs_MAX; s++)
                for (int v=0; v<_brickVertCounts[s]; v++)
                {
                    _brickVerts[s][v].x -= _brickCenters[s].x;
                    _brickVerts[s][v].y -= _brickCenters[s].y;
                }
        } break;
        case PFSceneTypeGame:
        {
            jsonArray = [self jsonArrayForFile:@"digits"];
            for (int n=0; n<=9; n++)
                [self loadModelIntoVerts:_digitVerts
                              vertCounts:_digitVertCounts
                                 indices:_digitIndices
                             indexCounts:_digitIndexCounts
                             withEnumNum:n
                               jsonArray:jsonArray];
        } break;
    }
}

- (void)loadModelsForBrickGenus:(PFBrickGenus)brickGenus
{
    NSArray *jsonArray;
    switch (brickGenus)
    {
        case bgMonomino:break;
            jsonArray = [self jsonArrayForFile:@"polyominos"];
            [self loadBrickModelWithBrickSpecies:bsMonomino jsonArray:jsonArray];
            break;
        case bgDomino:break;
            jsonArray = [self jsonArrayForFile:@"polyominos"];
            [self loadBrickModelWithBrickSpecies:bsDomino jsonArray:jsonArray];
            break;
        case bgTriomino:break;
            jsonArray = [self jsonArrayForFile:@"polyominos"];
            [self loadBrickModelWithBrickSpecies:bsTriominoI jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTriominoL jsonArray:jsonArray];
            break;
        case bgTetromino:
            jsonArray = [self jsonArrayForFile:@"polyominos"];
            [self loadBrickModelWithBrickSpecies:bsTetrominoI jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetrominoJ jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetrominoL jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetrominoO jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetrominoS jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetrominoT jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetrominoZ jsonArray:jsonArray];
            break;
        case bgMoniamond:
            jsonArray = [self jsonArrayForFile:@"polyiamonds"];
            [self loadBrickModelWithBrickSpecies:bsMoniamond jsonArray:jsonArray];
            break;
        case bgDiamond:
            jsonArray = [self jsonArrayForFile:@"polyiamonds"];
            [self loadBrickModelWithBrickSpecies:bsDiamond jsonArray:jsonArray];
            break;
        case bgTriamond:
            jsonArray = [self jsonArrayForFile:@"polyiamonds"];
            [self loadBrickModelWithBrickSpecies:bsTriamond jsonArray:jsonArray];
            break;
        case bgTetriamond:
            jsonArray = [self jsonArrayForFile:@"polyiamonds"];
            [self loadBrickModelWithBrickSpecies:bsTetriamondC jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetriamondI jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetriamondIr jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetriamondT jsonArray:jsonArray];
            break;
        case bgMonoround:
            jsonArray = [self jsonArrayForFile:@"polyrounds"];
            [self loadBrickModelWithBrickSpecies:bsMonoround jsonArray:jsonArray];
            break;
        case bgDiround:
            jsonArray = [self jsonArrayForFile:@"polyrounds"];
            [self loadBrickModelWithBrickSpecies:bsDiround jsonArray:jsonArray];
            break;
        case bgTriround:
            jsonArray = [self jsonArrayForFile:@"polyrounds"];
            [self loadBrickModelWithBrickSpecies:bsTriroundI jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTriroundL jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTriroundT jsonArray:jsonArray];
            break;
        case bgTetraround:
            jsonArray = [self jsonArrayForFile:@"polyrounds"];
            [self loadBrickModelWithBrickSpecies:bsTetraroundB jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundC jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundD jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundI jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundJ jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundL jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundO jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundS jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundT jsonArray:jsonArray];
            [self loadBrickModelWithBrickSpecies:bsTetraroundZ jsonArray:jsonArray];
            break;
    }
}

- (void)loadModelForBaseType:(PFBaseType)baseType
{
    [self loadModelIntoVerts:_baseVerts
                  vertCounts:_baseVertCounts
                     indices:_baseIndices
                 indexCounts:_baseIndexCounts
                 withEnumNum:baseType
                   jsonArray:[self jsonArrayForFile:@"bases"]];
}

- (void)loadModelsForSmallCirclePoints:(int)smallCirclePoints
                     largeCirclePoints:(int)largeCirclePoints
{
    if (_smallCircleVertCount > 0) free(_smallCircleVerts);
    if (_largeCircleVertCount > 0) free(_largeCircleVerts);
    if (_smallCircleOutlineVertCount > 0) free(_smallCircleOutlineVerts);
    smallCirclePoints = smallCirclePoints/2*2;
    largeCirclePoints = largeCirclePoints/2*2;
    _smallCircleVertCount = smallCirclePoints+2;
    _largeCircleVertCount = largeCirclePoints+2;
    _smallCircleOutlineVertCount = smallCirclePoints;
    _smallCircleVerts = (GLKVector2*)malloc(sizeof(GLKVector2)*_smallCircleVertCount);
    _largeCircleVerts = (GLKVector2*)malloc(sizeof(GLKVector2)*_largeCircleVertCount);
    _smallCircleOutlineVerts = (GLKVector2*)malloc(sizeof(GLKVector2)*_smallCircleOutlineVertCount);
    for (int v = 0; v <= smallCirclePoints/2; v++)
    {
        float theta = 2.0f * M_PI * ((float)v) / ((float)smallCirclePoints);
        _smallCircleVerts[2*v] = {cosf(theta),sinf(theta)};
        _smallCircleVerts[2*v+1] = {cosf(theta),-sinf(theta)};
    }
    for (int v = 0; v <= largeCirclePoints/2; v++)
    {
        float theta = 2.0f * M_PI * ((float)v) / ((float)largeCirclePoints);
        _largeCircleVerts[2*v] = {cosf(theta),sinf(theta)};
        _largeCircleVerts[2*v+1] = {cosf(theta),-sinf(theta)};
    }
    for (int v = 0; v < smallCirclePoints; v++)
    {
        float theta = 2.0f * M_PI * ((float)v) / ((float)smallCirclePoints);
        _smallCircleOutlineVerts[v] = {cosf(theta),sinf(theta)};
    }
}

#pragma mark - Model Loading Helper Methods

- (NSArray*)jsonArrayForFile:(NSString*)file
{
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"json"]];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

- (void)loadModelIntoVerts:(GLKVector2**)groupVerts
                vertCounts:(int*)groupVertCounts
                   indices:(GLushort**)groupIndices
               indexCounts:(int*)groupIndexCounts
               withEnumNum:(int)enumNum
                 jsonArray:(NSArray*)jsonArray
{
    NSArray *polygonArray = [jsonArray objectAtIndex:enumNum];
    NSArray *vertArray = [polygonArray objectAtIndex:0];
    NSArray *indexArray = [polygonArray objectAtIndex:1];
    NSAssert(vertArray.count>0 && indexArray.count>0,@"");
    
    groupVertCounts[enumNum] = vertArray.count/2;
    groupVerts[enumNum] = (GLKVector2*)malloc(sizeof(GLKVector2)*vertArray.count/2);
    for (int v=0; v<vertArray.count; v++)
        if (v%2==0) groupVerts[enumNum][v/2].x = ((NSNumber*)[vertArray objectAtIndex:v]).floatValue;
        else        groupVerts[enumNum][v/2].y = ((NSNumber*)[vertArray objectAtIndex:v]).floatValue;
    
    groupIndexCounts[enumNum] = indexArray.count;
    groupIndices[enumNum] = (GLushort*)malloc(sizeof(GLushort)*indexArray.count);
    for (int i=0; i<indexArray.count; i++)
        groupIndices[enumNum][i] = ((NSNumber*)[indexArray objectAtIndex:i]).unsignedShortValue;
}

- (void)loadBrickModelWithBrickSpecies:(PFBrickSpecies)species
                             jsonArray:(NSArray*)jsonArray
{
    NSAssert(jsonArray.count==_brickEnumCount,@"");
    [self loadModelIntoVerts:_brickVerts
                  vertCounts:_brickVertCounts
                     indices:_brickIndices
                 indexCounts:_brickIndexCounts
                 withEnumNum:species
                   jsonArray:jsonArray];
    // center models
    for (int v=0; v<_brickVertCounts[species]; v++)
    {
        _brickVerts[species][v].x -= _brickCenters[species].x;
        _brickVerts[species][v].y -= _brickCenters[species].y;
    }
}

#pragma mark - Drawing

- (void)changeColor:(GLKVector4)color
{
    _currentColor = color;
}

- (void)changeSceneBrightness:(float)sceneBrightness
{
    _sceneBrightness = sceneBrightness;
}

- (void)changeLineBrightness:(float)lineBrightness
{
    _lineBrightness = lineBrightness;
}

- (void)resetDraw
{
    _bubbleVertCount = 0;
    _vertCount = 0;
    _indexCount = 0;
    _currentColor = GLKVector4Make(0.0f,0.0f,0.0f,1.0f);
}

- (void)addTitlePolygon:(PFTitlePolygon *)polygon outline:(BOOL)outline
{
    PFTitlePolygonSpecies species = polygon.species;
    if (!outline) species = (PFTitlePolygonSpecies) (species + 2);
    
    GLKVector2 *modelVerts = _brickVerts[species];
    int modelVertCount = _brickVertCounts[species];
    NSAssert(_vertCount+modelVertCount<MAX_VERTS,@"");
    for (int v=0; v<modelVertCount; v++)
    {
        GLKVector2 p = glk(polygon.body->GetWorldPoint(b2(modelVerts[v])));
        GLKVector4 c;
        if (outline) c = RGBAfromH(MIN(1.0f,MAX(0.0f,p.x/LAUNCH_SCREEN_SPAN_FOR_COLOR + 0.5f)));
        else c = GLKVector4Make(0.0f,0.0f,0.0f,1.0f);
        _verts[_vertCount+v] = {p.x, p.y, c.r, c.g, c.b, c.a*_sceneBrightness};
    }
    
    GLushort *modelIndices = _brickIndices[species];
    int modelIndexCount = _brickIndexCounts[species];
    NSAssert(_indexCount+modelIndexCount<MAX_INDICES,@"");
    for (int i=0; i<modelIndexCount; i++)
        _indices[_indexCount+i] = modelIndices[i] + _vertCount;
    
    _vertCount += modelVertCount;
    _indexCount += modelIndexCount;
}

- (void)addBrick:(PFBrick *)brick
      withOffset:(GLKVector2)offset
{
    PFBrickSpecies species = brick.species;
    GLKVector2 *modelVerts = _brickVerts[species];
    int modelVertCount = _brickVertCounts[species];
    NSAssert(_vertCount+modelVertCount<MAX_VERTS,@"");
    for (int v=0; v<modelVertCount; v++)
    {
        GLKVector2 p = glk(brick.body->GetWorldPoint(b2Vec2(modelVerts[v].x, modelVerts[v].y)));
        _verts[_vertCount+v] =
        {
            p.x + offset.x,
            p.y + offset.y,
            _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a * _sceneBrightness * _lineBrightness
        };
    }
    
    GLushort *modelIndices = _brickIndices[species];
    int modelIndexCount = _brickIndexCounts[species];
    NSAssert(_indexCount+modelIndexCount<MAX_INDICES,@"");
    for (int i=0; i<modelIndexCount; i++)
        _indices[_indexCount+i] = modelIndices[i] + _vertCount;
    
    _vertCount += modelVertCount;
    _indexCount += modelIndexCount;
}

- (void)addBrick:(PFBrick *)brick
      withOffset:(GLKVector2)offset
           scale:(float)scale
{
    PFBrickSpecies species = brick.species;
    GLKVector2 *modelVerts = _brickVerts[species];
    int modelVertCount = _brickVertCounts[species];
    NSAssert(_vertCount+modelVertCount<MAX_VERTS,@"");
    GLKVector2 scaleOffset = glk((1.0f-scale)*(brick.body->GetWorldCenter() - brick.body->GetPosition()));
    for (int v=0; v<modelVertCount; v++)
    {
        GLKVector2 p = glk(brick.body->GetWorldPoint(b2Vec2(scale*modelVerts[v].x,
                                                            scale*modelVerts[v].y)));
        _verts[_vertCount+v] =
        {
            p.x + offset.x + scaleOffset.x,
            p.y + offset.y + scaleOffset.y,
            _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a * _sceneBrightness * _lineBrightness
        };
    }
    
    GLushort *modelIndices = _brickIndices[species];
    int modelIndexCount = _brickIndexCounts[species];
    NSAssert(_indexCount+modelIndexCount<MAX_INDICES,@"");
    for (int i=0; i<modelIndexCount; i++)
        _indices[_indexCount+i] = modelIndices[i] + _vertCount;
    
    _vertCount += modelVertCount;
    _indexCount += modelIndexCount;
}

- (void)addHints:(NSMutableSet *)hints
{
    for (PFHint *hint in hints)
    {
        float glow = hint.timerFraction * hint.timerFraction * 0.8f;
        [self changeColor:(GLKVector4){{1.0f, 1.0f, 1.0f, glow * _sceneBrightness * _lineBrightness}}];
        float outerRadius = (1.0f - hint.timerFraction) * BUBBLE_RADIUS * 2.0f;
        float innerRadius = outerRadius - BUBBLE_MASK_WIDTH;
        if (innerRadius > 0.0f)
            [self addRingWithPosition:glk(hint.position) innerRadius:innerRadius outerRadius:outerRadius];
        else
            [self addCircleWithPosition:glk(hint.position) radius:outerRadius];
    }
}

- (void)addGameBricks:(NSMutableSet *)bricks
    withSelectedBrick:(PFBrick *)selectedBrick
{
    float touchRingAlpha = _sceneBrightness * _lineBrightness;
    
    // Draw touch rings
    for (PFBrick *brick in bricks)
    {
        switch (brick.state)
        {
            case PFBrickStateLoose:
            case PFBrickStateHover:
            case PFBrickStateSelected:
            case PFBrickStateDrag:
            case PFBrickStateRotate:
            case PFBrickStateDragRotate:
            {
                if (!brick.ringIsAsleep)
                {
                    float glow = BUBBLE_DIM + BUBBLE_GLOW * ((float)brick.ringGlow / (float)BUBBLE_GLOW_MAX);
                    [self changeColor:(GLKVector4){{glow, glow, glow, touchRingAlpha}}];
                    [self addCircleWithPosition:glk(brick.body->GetWorldCenter())
                                               radius:brick.ringRadius];
                }
            } break;
        }
    }
        
    // Draw touch bubble masks
    [self changeColor:(GLKVector4){{0.0f, 0.0f, 0.0f, touchRingAlpha}}];
    for (PFBrick *brick in bricks)
    {
        switch (brick.state)
        {
            case PFBrickStateLoose:
            case PFBrickStateHover:
            case PFBrickStateSelected:
            case PFBrickStateDrag:
            case PFBrickStateRotate:
            case PFBrickStateDragRotate:
            {
                if (!brick.bubbleIsAsleep)
                    [self addCircleWithPosition:glk(brick.body->GetWorldCenter())
                                               radius:brick.bubbleRadius + BUBBLE_MASK_WIDTH * 0.5f];

            } break;
        }
    }
    
    // Draw touch bubbles
    for (PFBrick *brick in bricks)
    {
        switch (brick.state)
        {
            case PFBrickStateSelected: break; // save selected bubble to draw on top
            case PFBrickStateLoose:
            case PFBrickStateHover:
            case PFBrickStateDrag:
            case PFBrickStateRotate:
            case PFBrickStateDragRotate:
            {
                if (!brick.bubbleIsAsleep)
                {
                    float glow = BUBBLE_DIM + BUBBLE_GLOW * ((float)brick.bubbleGlow / (float)BUBBLE_GLOW_MAX);
                    [self changeColor:(GLKVector4){{glow, glow, glow, touchRingAlpha}}];
                    [self addCircleWithPosition:glk(brick.body->GetWorldCenter())
                                               radius:brick.bubbleRadius - BUBBLE_MASK_WIDTH * 0.5f];
                }
            } break;
        }
    }
    
    // Draw selcted brick bubble
    if (selectedBrick)
    {
        float glow = BUBBLE_DIM + BUBBLE_GLOW * ((float)selectedBrick.bubbleGlow / (float)BUBBLE_GLOW_MAX);
        [self changeColor:(GLKVector4){{glow, glow, glow, touchRingAlpha}}];
        [self addCircleWithPosition:glk(selectedBrick.body->GetWorldCenter())
                             radius:selectedBrick.bubbleRadius - BUBBLE_MASK_WIDTH * 0.5f];
    }
    
    // Draw bricks
    [self changeColor:(GLKVector4){{1.0f,1.0f,1.0f,_lineBrightness*_sceneBrightness}}];
    for (PFBrick *brick in bricks)
    {
        if (brick.isSpawning)
        {
            [self addBrick:brick
                withOffset:(GLKVector2){{0.0f,0.0f}}
                     scale:brick.spawnRadius/SPAWN_END_RADIUS];
        }
        else
        {
            [self addBrick:brick
                withOffset:(GLKVector2){{0.0f,0.0f}}];
        }
    }
}

- (void)addBase:(PFBase *)base
{
    PFBaseType type = base.type;
    
    GLKVector2 *modelVerts = _baseVerts[type];
    int modelVertCount = _baseVertCounts[type];
    NSAssert(_vertCount+modelVertCount<MAX_VERTS,@"");
    for (int v=0; v<modelVertCount; v++)
        _verts[_vertCount+v] =
    {
        modelVerts[v].x,
        modelVerts[v].y,
        _currentColor.r,
        _currentColor.g,
        _currentColor.b,
        _currentColor.a * _sceneBrightness * _lineBrightness
    };
    
    GLushort *modelIndices = _baseIndices[type];
    int modelIndexCount = _baseIndexCounts[type];
    NSAssert(_indexCount+modelIndexCount<MAX_INDICES,@"");
    for (int i=0; i<modelIndexCount; i++)
        _indices[_indexCount+i] = modelIndices[i] + _vertCount;
    
    _vertCount += modelVertCount;
    _indexCount += modelIndexCount;
}

- (void)addRect:(CGRect)rect
{
    float halfWidth = rect.size.width*0.5f;
    float halfHeight = rect.size.height*0.5f;
    GLKVector4 c = _currentColor;
    _indices[_indexCount++] = _vertCount;
    _indices[_indexCount++] = _vertCount+1;
    _indices[_indexCount++] = _vertCount+2;
    _indices[_indexCount++] = _vertCount+2;
    _indices[_indexCount++] = _vertCount;
    _indices[_indexCount++] = _vertCount+3;
    _verts[_vertCount++] = {rect.origin.x-halfWidth, rect.origin.y-halfHeight, c.r, c.g, c.b, c.a};
    _verts[_vertCount++] = {rect.origin.x+halfWidth, rect.origin.y-halfHeight, c.r, c.g, c.b, c.a};
    _verts[_vertCount++] = {rect.origin.x+halfWidth, rect.origin.y+halfHeight, c.r, c.g, c.b, c.a};
    _verts[_vertCount++] = {rect.origin.x-halfWidth, rect.origin.y+halfHeight, c.r, c.g, c.b, c.a};
}

- (void)addCircleWithPosition:(GLKVector2)position
                       radius:(float)radius
{
    if (radius < BUBBLE_RADIUS * 1.5f)
        for (int v=0; v<_smallCircleVertCount; v++)
            _bubbleVerts[_bubbleVertCount++] = {
                position.x + radius*_smallCircleVerts[v].x,
                position.y + radius*_smallCircleVerts[v].y,
                _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
            };
    else
        for (int v=0; v<_largeCircleVertCount; v++)
            _bubbleVerts[_bubbleVertCount++] = {
                position.x + radius*_largeCircleVerts[v].x,
                position.y + radius*_largeCircleVerts[v].y,
                _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
            };
}

- (void)addRingWithPosition:(GLKVector2)position
                innerRadius:(float)innerRadius
                outerRadius:(float)outerRadius
{
    _bubbleVerts[_bubbleVertCount++] = {
        position.x + innerRadius*_smallCircleOutlineVerts[0].x,
        position.y + innerRadius*_smallCircleOutlineVerts[0].y,
        _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
    };
    for (int v=0; v<_smallCircleOutlineVertCount; v++)
    {
        _bubbleVerts[_bubbleVertCount++] = {
            position.x + innerRadius*_smallCircleOutlineVerts[v].x,
            position.y + innerRadius*_smallCircleOutlineVerts[v].y,
            _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
        };
        _bubbleVerts[_bubbleVertCount++] = {
            position.x + outerRadius*_smallCircleOutlineVerts[v].x,
            position.y + outerRadius*_smallCircleOutlineVerts[v].y,
            _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
        };
    }
    _bubbleVerts[_bubbleVertCount++] = {
        position.x + innerRadius*_smallCircleOutlineVerts[0].x,
        position.y + innerRadius*_smallCircleOutlineVerts[0].y,
        _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
    };
    _bubbleVerts[_bubbleVertCount++] = {
        position.x + outerRadius*_smallCircleOutlineVerts[0].x,
        position.y + outerRadius*_smallCircleOutlineVerts[0].y,
        _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
    };
    _bubbleVerts[_bubbleVertCount++] = {
        position.x + outerRadius*_smallCircleOutlineVerts[0].x,
        position.y + outerRadius*_smallCircleOutlineVerts[0].y,
        _currentColor.r, _currentColor.g, _currentColor.b, _currentColor.a
    };
}

- (void)addDigit:(int)digit withCenter:(GLKVector2)center height:(float)height
{
    NSAssert(digit>=0 && digit <=9,@"");
    GLKVector2 *modelVerts = _digitVerts[digit];
    int modelVertCount = _digitVertCounts[digit];
    NSAssert(_vertCount+modelVertCount<MAX_VERTS,@"");
    for (int v=0; v<modelVertCount; v++)
        _verts[_vertCount+v] =
    {
        modelVerts[v].x*height+center.x,
        modelVerts[v].y*height+center.y,
        _currentColor.r,
        _currentColor.g,
        _currentColor.b,
        _currentColor.a * _sceneBrightness
    };
    
    GLushort *modelIndices = _digitIndices[digit];
    int modelIndexCount = _digitIndexCounts[digit];
    NSAssert(_indexCount+modelIndexCount<MAX_INDICES,@"");
    for (int i=0; i<modelIndexCount; i++)
        _indices[_indexCount+i] = modelIndices[i] + _vertCount;
    
    _vertCount += modelVertCount;
    _indexCount += modelIndexCount;
}

- (void)addInteger:(int)number withCenter:(GLKVector2)center height:(float)height
{
    NSAssert(number>=0 && number <=999,@"");
    int digit1 = number / 100;
    number -= 100 * digit1;
    int digit2 = number / 10;
    number -= 10 * digit2;
    int digit3 = number;
    if (digit1)
    {
        [self addDigit:digit1
            withCenter:(GLKVector2){{center.x-height, center.y}}
                height:height];
        [self addDigit:digit2
            withCenter:center
                height:height];
        [self addDigit:digit3
            withCenter:(GLKVector2){{center.x+height, center.y}}
                height:height];
    }
    else if (digit2)
    {
        [self addDigit:digit2
            withCenter:(GLKVector2){{center.x-height*0.5f, center.y}}
                height:height];
        [self addDigit:digit3
            withCenter:(GLKVector2){{center.x+height*0.5f, center.y}}
                height:height];
    }
    else
    {
        [self addDigit:digit3
            withCenter:center
                height:height];        
    }
}

@end
