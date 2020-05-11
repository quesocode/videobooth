//
//  BuffaloAppDelegate.m
//  Buffalo
//
//  Created by Travis Weerts on 3/28/11.
//  Copyright 2011 Buffalomatic. All rights reserved.
//

#import "BuffaloAppDelegate.h"

// this framework was imported so we could use the kCFURLErrorNotConnectedToInternet error code
#import "BuffaloApp.h"
#import "BmAction.h"
#import "UIColor+Buffalo.h"
#import "BmStyles.h"



static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
        double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
        return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}



@implementation BuffaloAppDelegate

@synthesize window, viewController, app, lastAcceleration;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    
    NSString *settingsFile = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
	settingsDict = [[NSDictionary alloc] initWithContentsOfFile:settingsFile];
    if(settingsDict)
    {
        
        
        viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = [UIColor blackColor];
        
        if([[settingsDict objectForKey:@"screen"] objectForKey:@"style"])
        {
            BmStyles *styles = [[BmStyles alloc] initWithProperties:[[settingsDict objectForKey:@"screen"] objectForKey:@"style"] withOwner:viewController.view];
            [styles applyToView:viewController.view];
            [styles release];
        }
        
        
        [UIAccelerometer sharedAccelerometer].delegate = self;
        self.window.rootViewController= viewController;
        [self.window makeKeyAndVisible];
        app = [BuffaloApp instance];
        
        [app launch:settingsDict];
    }
	return YES;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
    if (self.lastAcceleration) {
        if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.7)) {
            histeresisExcited = YES;

            //[BmAction perform:@"reload" properties:[[NSDictionary alloc] init] ];
			
        } else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
            histeresisExcited = NO;
        }
    }
	
    self.lastAcceleration = acceleration;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
    [BuffaloApp pause];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
	 */
    [BuffaloApp enterBackground];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	/*
	 Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
	 */
    [BuffaloApp enterForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
    [BuffaloApp resume];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
	/*
	 Called when the application is about to terminate.
	 See also applicationDidEnterBackground:.
	 */
    [BuffaloApp terminate];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    // Do something with the url here
    //NSLog(@"URL: %@", [url absoluteString]);
    
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	/*
	 Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	 */
}


- (void)dealloc {
    [app release];
    [settingsDict release];
    [viewController release];
	[window release];
	[super dealloc];
}


@end
