//
//  PFVertLibrary.h
//  Polyform
//
//  Created by Warren Whipple on 11/11/13.
//  Copyright (c) 2013 Warren Whipple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFVertLibrary : NSObject

@property (nonatomic, readonly) GLKVector2** verts;
@property (nonatomic, readonly) int* vertCounts;
@property (nonatomic, readonly) GLushort** indicies;
@property (nonatomic, readonly) int* indexCounts;
@property (nonatomic, readonly) int modelCount;

- (id)initWithJsonFile:(NSString*)jsonFile;

@end
