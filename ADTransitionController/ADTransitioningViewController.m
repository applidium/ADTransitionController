//
//  ADTransitioningViewController.m
//  ADTransitionController
//
//  Created by Patrick Nollet on 10/10/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ADTransitioningViewController.h"
#import "ADTransitioningDelegate.h"

@interface ADTransitioningViewController () {
    ADTransitioningDelegate * _customTransitioningDelegate;
}

@end

@implementation ADTransitioningViewController
@synthesize transition = _transition;

- (void)setTransitioningDelegate:(id <UIViewControllerTransitioningDelegate>)delegate {
    NSAssert(FALSE, @"This setter shouldn't be used! You should set the transition property instead.");
}

- (void)setTransition:(ADTransition *)transition {
    _transition = transition;
     _customTransitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
    [super setTransitioningDelegate:_customTransitioningDelegate]; // don't call the setter of the current class
}
@end
