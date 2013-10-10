//
//  ADTransitioningDelegate.m
//  ADTransitionController
//
//  Created by Patrick Nollet on 09/10/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ADTransitioningDelegate.h"
#import "ADTransitionController.h"

@interface ADTransitioningDelegate () {
    id<UIViewControllerContextTransitioning> _currentTransitioningContext;
}

@end

@interface ADTransitioningDelegate (Private)
- (void)_setupLayers:(NSArray *)layers;
- (void)_teardownLayers:(NSArray *)layers;
- (void)_transitionInContainerView:(UIView *)containerView fromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition;
@end

@implementation ADTransitioningDelegate
@synthesize transition = _transition;

- (void)dealloc {
    [_transition release], _transition = nil;
    [super dealloc];
}

- (id)initWithTransition:(ADTransition *)transition {
    self = [self init];
    if (self) {
        _transition = [transition retain];
        _transition.delegate = self;
    }
    return self;
}

#pragma mark - ADTransitionDelegate
- (void)pushTransitionDidFinish:(ADTransition *)transition {
    [_currentTransitioningContext completeTransition:YES];
    [_currentTransitioningContext release], _currentTransitioningContext = nil;
}
- (void)popTransitionDidFinish:(ADTransition *)transition {
    [_currentTransitioningContext completeTransition:YES];
    [_currentTransitioningContext release], _currentTransitioningContext = nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [_currentTransitioningContext release], _currentTransitioningContext = [transitionContext retain];
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = transitionContext.containerView;
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    if (self.transition.type == ADTransitionTypeNull) {
        self.transition.type = ADTransitionTypePush;
    }
    UIView * fromView = fromViewController.view;
    UIView * toView = toViewController.view;

    ADTransition * transition = nil;
    switch (self.transition.type) {
        case ADTransitionTypePush:
            transition = self.transition;
            break;
        case ADTransitionTypePop:
            transition = self.transition.reverseTransition;
        default:
            break;
    }
    [self _transitionInContainerView:containerView fromView:fromView toView:toView withTransition:transition];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transition.duration;
}
@end

@implementation ADTransitioningDelegate (Private)
- (void)_transitionInContainerView:(UIView *)containerView fromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition {
    viewIn.layer.doubleSided = NO;
    viewOut.layer.doubleSided = NO;

    [self _setupLayers:@[viewIn.layer, viewOut.layer]];
    [CATransaction setCompletionBlock:^{
        [self _teardownLayers:@[viewIn.layer, viewOut.layer]];
    }];

    if ([transition isKindOfClass:[ADTransformTransition class]]) { // ADTransformTransition
        ADTransformTransition * transformTransition = (ADTransformTransition *)transition;
        viewIn.layer.transform = transformTransition.inLayerTransform;
        viewOut.layer.transform = transformTransition.outLayerTransform;

        // We now balance viewIn.layer.transform by taking its invert and putting it in the superlayer of viewIn.layer
        // so that viewIn.layer appears ok in the final state.
        // (When pushing, viewIn.layer.transform == CATransform3DIdentity)
        containerView.layer.transform = CATransform3DInvert(viewIn.layer.transform);

        [containerView.layer addAnimation:transformTransition.animation forKey:nil];
    } else if ([transition isKindOfClass:[ADDualTransition class]]) { // ADDualTransition
        ADDualTransition * dualTransition = (ADDualTransition *)transition;
        [viewIn.layer addAnimation:dualTransition.inAnimation forKey:nil];
        [viewOut.layer addAnimation:dualTransition.outAnimation forKey:nil];
    } else if (transition != nil) {
        NSAssert(FALSE, @"Unhandled ADTransition subclass!");
    }
}

- (void)_setupLayers:(NSArray *)layers {
    for (CALayer * layer in layers) {
        layer.shouldRasterize = YES;
        layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}

- (void)_teardownLayers:(NSArray *)layers {
    for (CALayer * layer in layers) {
        layer.shouldRasterize = NO;
    }
}

@end
