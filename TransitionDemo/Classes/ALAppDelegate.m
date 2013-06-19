//
//  ADAppDelegate.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 27/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALAppDelegate.h"
#import "ADTransitionController.h"
#import "ALTransitionTestViewController.h"

@implementation ALAppDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Setup transitionController
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:nil bundle:nil index:0];
    ADTransitionController * transitionController = [[ADTransitionController alloc] initWithRootViewController:viewController];
    [viewController release];
    self.window.rootViewController = transitionController;
    [transitionController release];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Setup appearance
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ALNavigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    
    if (AD_IOS_PRIOR_7) {
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"ALDoneButtonOff"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"ALDoneButtonOn"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f] forState:UIControlStateHighlighted style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
    }
    
    self.window.backgroundColor = [UIColor lightGrayColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
