//
//  ADTransitioningDelegate.m
//  ADTransitionController
//
//  Created by Patrick Nollet on 09/10/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ADTransitioningDelegate.h"
#import "ADTransitionController.h"

#define AD_Z_DISTANCE 1000.0f

@interface ADTransitioningDelegate () {
    id<UIViewControllerContextTransitioning> _currentTransitioningContext;
}

@end

@interface ADTransitioningDelegate (Private)
- (void)_setupLayers:(NSArray *)layers;
- (void)_teardownLayers:(NSArray *)layers;
- (void)_completeTransition;
- (void)_transitionInContainerView:(UIView *)containerView fromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition;
@end

@implementation ADTransitioningDelegate
@synthesize transition = _transition;

- (id)initWithTransition:(ADTransition *)transition {
    self = [self init];
    if (self) {
        _transition = transition;
        _transition.delegate = self;
    }
    return self;
}

#pragma mark - ADTransitionDelegate
- (void)pushTransitionDidFinish:(ADTransition *)transition {
    [self _completeTransition];
}

- (void)popTransitionDidFinish:(ADTransition *)transition {
    [self _completeTransition];
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
    _currentTransitioningContext = transitionContext;
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.transition.type == ADTransitionTypeNull) {
        self.transition.type = ADTransitionTypePush;
    }

    UIView * containerView = transitionContext.containerView;
    UIView * fromView = fromViewController.view;
    UIView * toView = toViewController.view;

    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -AD_Z_DISTANCE;
    containerView.layer.sublayerTransform = sublayerTransform;

    UIView * wrapperView = [[ADTransitionView alloc] initWithFrame:fromView.frame];
    fromView.frame = fromView.bounds;
    toView.frame = toView.bounds;

    wrapperView.autoresizesSubviews = YES;
    wrapperView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [wrapperView addSubview:fromView];
    [wrapperView addSubview:toView];
    [containerView addSubview:wrapperView];

    ADTransition * transition = nil;
    switch (self.transition.type) {
        case ADTransitionTypePush:
            transition = self.transition;
            break;
        case ADTransitionTypePop:
            transition = self.transition.reverseTransition;
            transition.type = ADTransitionTypePop;
        default:
            break;
    }
    transition.delegate = self;
    [self _transitionInContainerView:wrapperView fromView:fromView toView:toView withTransition:transition];
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
        viewIn.layer.transform = CATransform3DIdentity;
        viewOut.layer.transform = CATransform3DIdentity;
        containerView.layer.transform = CATransform3DIdentity;

        UIView * contextView = [_currentTransitioningContext containerView];
        viewOut.frame = containerView.frame;
        [contextView addSubview:viewOut];
        viewIn.frame = containerView.frame;
        [contextView addSubview:viewIn];
        [containerView removeFromSuperview];
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

- (void)_completeTransition {
    UIView * containerView = _currentTransitioningContext.containerView;
    CATransform3D sublayerTransform = CATransform3DIdentity;
    containerView.layer.sublayerTransform = sublayerTransform;

    [_currentTransitioningContext completeTransition:YES];
    _currentTransitioningContext = nil;
}

@end
