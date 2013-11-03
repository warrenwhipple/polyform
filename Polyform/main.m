//
//  main.m
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAppDelegate.h"

//typedef int (*PYStdWriter)(void *, const char *, int);
//static PYStdWriter _oldStdWrite;

/*
int __pyStderrWrite(void *inFD, const char *buffer, int size) // temp xcode 5 fix
{
    if ( strncmp(buffer, "AssertMacros:", 13) == 0 ) {
        return 0;
    }
    return _oldStdWrite(inFD, buffer, size);
}
*/

int main(int argc, char *argv[])
{
    //_oldStdWrite = stderr->_write; // temp xcode 5 fix
    //stderr->_write = __pyStderrWrite; // temp xcode 5 fix
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([PFAppDelegate class]));
    }
}