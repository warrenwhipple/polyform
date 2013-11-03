//
//  PFContactListener.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "Box2D.h"

@class PFGameScene;

class PFContactListener : public b2ContactListener
{
    PFGameScene *gameScene;
public:
    PFContactListener(void*);
private:
	void BeginContact(b2Contact *contact);
};