//
//  ADTransitionController.m
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADTransitionController.h"
#import "ADTransformTransition.h"
#import "ADDualTransition.h"

#import <QuartzCore/CoreAnimation.h>
#import <objc/runtime.h>
#import "UIViewController+ADTransitionController.h"

@implementation ADTransitionView
+ (Class)layerClass {
    return [CATransformLayer class];
}
@end

NSString * ADTransitionControllerAssociationKey = @"ADTransitionControllerAssociationKey";

@interface ADTransitionController (Private)
- (void)_initialize;
- (void)_transitionfromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)animation;
@end

@implementation ADTransitionController
@synthesize viewControllers = _viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self _initialize];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self _initialize];
    return self;
}

- (void)loadView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    view.autoresizesSubviews = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    [view release];
    
    CGFloat navigationBarHeight = 44.0f;
    _containerView = [[ADTransitionView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + navigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
    
    // Setting the perspective
    float zDistance = 1000.0f;
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -zDistance;
    self.view.layer.sublayerTransform = sublayerTransform;
    
    _containerView.autoresizesSubviews = YES;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _containerView.clipsToBounds = YES;
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, navigationBarHeight)];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
    [_navigationBar release];
    [self.view addSubview:_containerView];
    [_containerView release];
    
    UIViewController * topViewController = self.viewControllers.lastObject;
    [_containerView addSubview:topViewController.view];
    topViewController.view.frame = CGRectMake(0.0f, 0.0f, _containerView.frame.size.width, _containerView.frame.size.height);
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    for (UIViewController * viewController in self.viewControllers) {
        UINavigationItem * navigationItem = [[UINavigationItem alloc] initWithTitle:viewController.title];
        [items addObject:navigationItem];
        [navigationItem release];
    }
    [_navigationBar setItems:items];
    [items release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[_viewControllers lastObject] viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[_viewControllers lastObject] viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[_viewControllers lastObject] viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[_viewControllers lastObject] viewDidDisappear:animated];
}

- (void)dealloc {
    [_transitions release], _transitions = nil;
    [_viewControllers release], _viewControllers = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Push - Pop
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition {
    if (_isContainerViewTransitioning || _isNavigationBarTransitioning) {
        return;
    }
    
    objc_setAssociatedObject(viewController, ADTransitionControllerAssociationKey, self, OBJC_ASSOCIATION_ASSIGN);
    
    BOOL animated = transition ? YES : NO;
    
    
    transition.delegate = self;
    UIViewController * viewControllerToRemoveFromView = [_viewControllers lastObject];
    
    [_viewControllers addObject:viewController];
    if (transition) {
        [_transitions addObject:transition];
    } else {
        [_transitions addObject:[ADTransition nullTransition]];
    }
    
    UIView * viewIn = viewController.view;
    UIView * viewOut = viewControllerToRemoveFromView.view;
    
    [viewController viewWillAppear:animated];
    [viewControllerToRemoveFromView viewWillDisappear:animated];
    
    [_containerView addSubview:viewIn];
    viewIn.frame = CGRectMake(0.0f, 0.0f, _containerView.frame.size.width, _containerView.frame.size.height);
    
    _isContainerViewTransitioning = animated;
    [self _transitionfromView:viewOut toView:viewIn withTransition:transition];
    
    _isNavigationBarTransitioning = animated;
    UINavigationItem * navigationItem = [[UINavigationItem alloc] initWithTitle:viewController.title];
    if (animated) {
        _isNavigationBarTransitioning = YES;
    }
    navigationItem.hidesBackButton = (_viewControllers.count == 0); // Hide the "Back" button for the root view controller
    [_navigationBar pushNavigationItem:navigationItem animated:animated];
    [navigationItem release];
    
    if (!animated) {
        [self pushTransitionDidFinish:nil];
    }
}

- (UIViewController *)popViewController {
    if ([_transitions count] > 0) {
        UIViewController * viewController = [self popViewControllerWithTransition:[[_transitions lastObject] reverseTransition]];
        return viewController;
    } else {
        return nil;
    }
}

- (UIViewController *)popViewControllerWithTransition:(ADTransition *)transition {
    if (self.viewControllers.count < 2 || _isContainerViewTransitioning || _isNavigationBarTransitioning) {
        return nil;
    }
    BOOL animated = transition ? YES : NO;
    [_transitions removeLastObject];
    UIViewController * outVC = [_viewControllers lastObject];
    UIViewController * inVC = [_viewControllers objectAtIndex:([_viewControllers count]-2)];
    [outVC viewWillDisappear:animated];
    [inVC viewWillAppear:animated];
    [_containerView addSubview:inVC.view];
    
    _isNavigationBarTransitioning = animated;
    [_navigationBar popNavigationItemAnimated:animated];
    
    _isContainerViewTransitioning = animated;
    [self _transitionfromView:outVC.view toView:inVC.view withTransition:transition];
    
    if (!animated) {
        [self popTransitionDidFinish:nil];
    }
    return outVC;
}

#pragma mark -
#pragma mark ADTransitionDelegate
- (void)pushTransitionDidFinish:(ADTransition *)transition {
    BOOL animated = transition ? YES : NO;
    if ([_viewControllers count] >= 2) {
        UIViewController * outVC = [_viewControllers objectAtIndex:([_viewControllers count]-2)];
        [outVC.view removeFromSuperview];
        [outVC viewDidDisappear:animated];
    }
    [[_viewControllers lastObject] viewDidAppear:animated];
    _isContainerViewTransitioning = NO;
}

- (void)popTransitionDidFinish:(ADTransition *)transition {
    _containerView.layer.transform = CATransform3DIdentity;
    ((UIViewController *)[_viewControllers objectAtIndex:_viewControllers.count - 2]).view.layer.transform = CATransform3DIdentity;
    
    BOOL animated = transition ? YES : NO;
    UIViewController * outVC = [_viewControllers lastObject];
    [outVC.view removeFromSuperview];
    [outVC viewDidDisappear:animated];
    [_viewControllers removeLastObject];
    [[_viewControllers lastObject] viewDidAppear:animated]; // the VC on the screen is now the one on the top of the viewControllers stack
    _isContainerViewTransitioning = NO;
}

#pragma mark -
#pragma mark UINavigationBar

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat navigationBarHeight = _navigationBar.frame.size.height;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    if ([self isNavigationBarHidden]) {
        _navigationBar.alpha = 1.0f;
        _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y + navigationBarHeight, _containerView.frame.size.width, _containerView.frame.size.height - navigationBarHeight);
    } else {
        _navigationBar.alpha = 0.0f;
        _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y - navigationBarHeight, _containerView.frame.size.width, _containerView.frame.size.height + navigationBarHeight);
    }
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)setNavigationBarHidden:(BOOL)hidden {
    [self setNavigationBarHidden:hidden animated:NO];
}

- (BOOL)isNavigationBarHidden {
    return _navigationBar.alpha < 0.5f;
}

#pragma mark -
#pragma mark UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (_isContainerViewTransitioning) {
        return NO;
    } else {
        [self popViewController]; // warning: this makes popViewController to be called twice if the pop was not initiated by the navigationBar. Fortunately, as _navigationBarTransitioning == YES, the second call does nothing (at least if the pop transition is animated).
        return YES;
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    _isNavigationBarTransitioning = NO;
}

-(void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    _isNavigationBarTransitioning = NO;
}
@end

@implementation ADTransitionController (Private)
- (void)_initialize {
    if (self) {
        _viewControllers = [[NSMutableArray alloc] init];
        _transitions = [[NSMutableArray alloc] init];
        _isContainerViewTransitioning = NO;
        _isNavigationBarTransitioning = NO;
    }
}

NSString * NSStringFromCATransform3D(CATransform3D transform) {
    return [NSString stringWithFormat:@"%.2f   %.2f   %.2f   %.2f\n%.2f   %.2f   %.2f   %.2f\n%.2f   %.2f   %.2f   %.2f\n%.2f   %.2f   %.2f   %.2f\n", transform.m11, transform.m21, transform.m31, transform.m41, transform.m12, transform.m22, transform.m32, transform.m42, transform.m13, transform.m23, transform.m33, transform.m43, transform.m14, transform.m24, transform.m34, transform.m44];
}

- (void)_transitionfromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition {
    viewIn.layer.doubleSided = NO;
    viewOut.layer.doubleSided = NO;
    if ([transition isKindOfClass:[ADTransformTransition class]]) { // ADTransformTransition
        ADTransformTransition * transformTransition = (ADTransformTransition *)transition;
        // 
        viewIn.layer.transform = transformTransition.inLayerTransform;
        viewOut.layer.transform = transformTransition.outLayerTransform;
        
        // We now balance viewIn.layer.transform by taking its invert and putting it in the superlayer of viewIn.layer
        // so that viewIn.layer appears ok in the final state.
        // (When pushing, viewIn.layer.transform == CATransform3DIdentity)
        _containerView.layer.transform = CATransform3DInvert(viewIn.layer.transform);
        
        [_containerView.layer addAnimation:transformTransition.animation forKey:nil];
    } else if ([transition isKindOfClass:[ADDualTransition class]]) { // ADDualTransition
        ADDualTransition * dualTransition = (ADDualTransition *)transition;
        [viewIn.layer addAnimation:dualTransition.inAnimation forKey:nil];
        [viewOut.layer addAnimation:dualTransition.outAnimation forKey:nil];
    } else if (transition != nil) {
        NSAssert(FALSE, @"Unhandled ADTransition subclass!");
    }
}
@end

