//
//  PFGameScene.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFScene.h"
#import "PFBrick.h"

@interface PFGameScene : NSObject <PFScene>

- (id)initWithRuleSet:(PFRuleSet)ruleSet;

- (void)beginContact:(b2Contact*)contact;

@end
