//
//  PFScene.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFCamera.h"
#import "PFVertHandler.h"
#import "PFAudioHandler.h"

@protocol PFScene <NSObject>

@property (readonly, nonatomic) PFCamera *camera;
@property (readwrite, nonatomic) PFSceneState state;
@property (readonly, nonatomic) PFSceneType nextSceneType;
@property (readonly, nonatomic) PFRuleSet nextRuleSet;

- (void)update;
- (void)touchesBegan:(NSSet*)touches;
- (void)writeToVertHandler:(PFVertHandler*)vertHandler;

@end
