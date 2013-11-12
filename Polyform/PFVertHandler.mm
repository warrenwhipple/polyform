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
#import "PFVertLibrary.h"

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
    PFVertLibrary *_brickVertLibrary, *_baseVertLibrary, *_digitVertLibrary;
    
    GLKVector2 *_brickCenters;
    
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
    
    free(_bubbleVerts);
    free(_verts);
    free(_indices);
    
    free(_brickCenters);
}

#pragma mark - Model Loading Methods

- (void)unloadAllModels
{
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
    switch (sceneType)
    {
        case PFSceneTypeTitle:
        {
            _brickVertLibrary = [[PFVertLibrary alloc] initWithJsonFile:@"titleTriangles"];
        } break;
        case PFSceneTypeMenu:
        {
            _brickVertLibrary = [[PFVertLibrary alloc] initWithJsonFile:@"menuBricks"];
            [_brickVertLibrary centerModelsWithCenters:_brickCenters];
        } break;
        case PFSceneTypeGame:
        {
            _baseVertLibrary = [[PFVertLibrary alloc] initWithJsonFile:@"bases"];
        } break;
    }
}

- (void)loadModelsForBrickGenus:(PFBrickGenus)brickGenus
{
    switch (brickGenus)
    {
        case bgMonomino:
        case bgDomino:
        case bgTriomino:
        case bgTetromino:
        {
            _brickVertLibrary = [[PFVertLibrary alloc] initWithJsonFile:@"polyominos"];
        } break;
        case bgMoniamond:
        case bgDiamond:
        case bgTriamond:
        case bgTetriamond:
        {
            _brickVertLibrary = [[PFVertLibrary alloc] initWithJsonFile:@"polyiamonds"];
        } break;
        case bgMonoround:
        case bgDiround:
        case bgTriround:
        case bgTetraround:
        {
            _brickVertLibrary = [[PFVertLibrary alloc] initWithJsonFile:@"polyrounds"];
        } break;
    }
    [_brickVertLibrary centerModelsWithCenters:_brickCenters];
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
    
    GLKVector2 *modelVerts = _brickVertLibrary.verts[species];
    int modelVertCount = _brickVertLibrary.vertCounts[species];
    NSAssert(_vertCount+modelVertCount<MAX_VERTS,@"");
    for (int v=0; v<modelVertCount; v++)
    {
        GLKVector2 p = glk(polygon.body->GetWorldPoint(b2(modelVerts[v])));
        GLKVector4 c;
        if (outline) c = RGBAfromH(MIN(1.0f,MAX(0.0f,p.x/LAUNCH_SCREEN_SPAN_FOR_COLOR + 0.5f)));
        else c = GLKVector4Make(0.0f,0.0f,0.0f,1.0f);
        _verts[_vertCount+v] = {p.x, p.y, c.r, c.g, c.b, c.a*_sceneBrightness};
    }
    
    GLushort *modelIndices = _brickVertLibrary.indices[species];
    int modelIndexCount = _brickVertLibrary.indexCounts[species];
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
    GLKVector2 *modelVerts = _brickVertLibrary.verts[species];
    int modelVertCount = _brickVertLibrary.vertCounts[species];
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
    
    GLushort *modelIndices = _brickVertLibrary.indices[species];
    int modelIndexCount = _brickVertLibrary.indexCounts[species];
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
    GLKVector2 *modelVerts = _brickVertLibrary.verts[species];
    int modelVertCount = _brickVertLibrary.vertCounts[species];
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
    
    GLushort *modelIndices = _brickVertLibrary.indices[species];
    int modelIndexCount = _brickVertLibrary.indexCounts[species];
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
           colorCount:(int)colorCount
               colors:(GLKVector4 *)colors
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
    // [self changeColor:(GLKVector4){{1.0f,1.0f,1.0f,_lineBrightness*_sceneBrightness}}];
    for (PFBrick *brick in bricks)
    {
        [self changeColor:colors[brick.group]];
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
    
    GLKVector2 *modelVerts = _baseVertLibrary.verts[type];
    int modelVertCount = _baseVertLibrary.vertCounts[type];
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
    
    GLushort *modelIndices = _baseVertLibrary.indices[type];
    int modelIndexCount = _baseVertLibrary.indexCounts[type];
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
    GLKVector2 *modelVerts = _digitVertLibrary.verts[digit];
    int modelVertCount = _digitVertLibrary.vertCounts[digit];
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
    
    GLushort *modelIndices = _digitVertLibrary.indices[digit];
    int modelIndexCount = _digitVertLibrary.indexCounts[digit];
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
