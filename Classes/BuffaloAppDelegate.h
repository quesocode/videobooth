//
//  BuffaloAppDelegate.h
//  Buffalo
//
//  Created by Travis Weerts on 3/28/11.
//  Copyright 2011 Buffalomatic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuffaloApp.h"
#import "BmScreen.h"

@class BuffaloApp;

@interface BuffaloAppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate> {
	UIWindow *window;
    BuffaloApp *app;
    NSDictionary *settingsDict;
    UIViewController *viewController;
    BOOL histeresisExcited;
	UIAcceleration* lastAcceleration;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) BuffaloApp *app;
@property (nonatomic, retain) UIViewController *viewController;

@property(retain) UIAcceleration* lastAcceleration;

@end

