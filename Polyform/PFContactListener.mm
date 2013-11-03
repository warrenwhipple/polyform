//
//  PFContactListener.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFContactListener.h"
#import "PFGameScene.h"
#import "PFBody.h"

PFContactListener::PFContactListener(void *gs)
{
    gameScene = (__bridge PFGameScene*)gs;
}

void PFContactListener::BeginContact(b2Contact *contact)
{
    [gameScene beginContact:contact];
}