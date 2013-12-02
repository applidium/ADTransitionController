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
#import "ADNavigationControllerDelegate.h"

@interface ALAppDelegate () {
    ADNavigationControllerDelegate * _navigationDelegate;
}

@end

@implementation ALAppDelegate

- (void)dealloc {
    [_navigationDelegate release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    // Setup transitionController
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:nil bundle:nil index:0];
    UIViewController * transitionController = nil;
    if (AD_SYSTEM_VERSION_GREATER_THAN_7) {
        transitionController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [_navigationDelegate release], _navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
        ((UINavigationController *)transitionController).delegate = _navigationDelegate;
    } else {
        transitionController = [[ADTransitionController alloc] initWithRootViewController:viewController];
    }
    [viewController release];
    self.window.rootViewController = transitionController;
    [transitionController release];

    // Setup appearance
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"ALNavigationBarBackground"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f] forBarMetrics:UIBarMetricsDefault];
    NSDictionary * navigationBarTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],
                                                   UITextAttributeTextShadowColor : [UIColor blackColor],
                                                   UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(-1.0f, 0)]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTextAttributes];

    if (!AD_SYSTEM_VERSION_GREATER_THAN_7) {
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"ALDoneButtonOff"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"ALDoneButtonOn"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        NSDictionary * barButtonItemTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],
                                                       UITextAttributeFont : [UIFont systemFontOfSize:14.0]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTextAttributes forState:UIControlStateNormal];
    }


    [[UIToolbar appearance] setBackgroundImage:[[UIImage imageNamed:@"ALNavigationBarBackground"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    // Remove status bar
    [UIApplication sharedApplication].statusBarHidden = YES;

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
