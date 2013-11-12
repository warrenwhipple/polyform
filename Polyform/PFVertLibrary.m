//
//  PFVertLibrary.m
//  Polyform
//
//  Created by Warren Whipple on 11/11/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import "PFVertLibrary.h"

@implementation PFVertLibrary

@synthesize
verts = _verts,
vertCounts = _vertCounts,
indicies = _indices,
indexCounts = _indexCounts,
modelCount = _modelCount;

- (id)initWithJsonFile:(NSString*)file
{
    if ((self = [super init]))
    {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"json"]] options:0 error:nil];

        _modelCount = jsonArray.count;
        _verts = (GLKVector2**)malloc(sizeof(GLKVector2*)*_modelCount);
        _indices = (GLushort**)malloc(sizeof(GLushort*)*_modelCount);
        _vertCounts = (int*)malloc(sizeof(int)*_modelCount);
        _indexCounts = (int*)malloc(sizeof(int)*_modelCount);
        
        for (int m=0; m<_modelCount; m++)
        {
            NSObject *jsonObject = [jsonArray objectAtIndex:m];
            if ([jsonObject isKindOfClass:[NSArray class]])
            {
                NSArray *modelArray = (NSArray*)jsonObject;
                NSArray *vertArray = [modelArray objectAtIndex:0];
                NSArray *indexArray = [modelArray objectAtIndex:1];
                
                _vertCounts[m] = vertArray.count/2;
                _verts[m] = (GLKVector2*)malloc(sizeof(GLKVector2)*vertArray.count/2);
                for (int v=0; v<vertArray.count; v++)
                    if (v%2==0) _verts[m][v/2].x = ((NSNumber*)[vertArray objectAtIndex:v]).floatValue;
                    else        _verts[m][v/2].y = ((NSNumber*)[vertArray objectAtIndex:v]).floatValue;
                
                _indexCounts[m] = indexArray.count;
                _indices[m] = (GLushort*)malloc(sizeof(GLushort)*indexArray.count);
                for (int i=0; i<indexArray.count; i++)
                    _indices[m][i] = ((NSNumber*)[indexArray objectAtIndex:i]).unsignedShortValue;
            }
            else
            {
                _vertCounts[m] = 0;
                _verts[m] = NULL;
                _indexCounts[m] = 0;
                _indices[m] = NULL;
            }
        }
    }
    return self;
}

- (void)dealloc
{
    for (int m=0; m<_modelCount; m++)
    {
        // no need to check if NULL, since free() does no action if NULL
        free(_verts[m]);
        free(_indices[m]);
    }
    free(_verts);
    free(_indices);
    free(_vertCounts);
    free(_indexCounts);
}

@end
