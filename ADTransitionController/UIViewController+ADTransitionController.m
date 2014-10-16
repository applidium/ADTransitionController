//
//  UIViewController+ADTransitionController.m
//  Transition
//
//  Created by Romain Goyet on 22/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "UIViewController+ADTransitionController.h"
#import <objc/runtime.h>

extern NSString * ADTransitionControllerAssociationKey;

@implementation UIViewController (ADTransitionController)

- (ADTransitionController *)transitionController {
    return (ADTransitionController *)objc_getAssociatedObject(self, (__bridge const void *)(ADTransitionControllerAssociationKey));
}

@end
