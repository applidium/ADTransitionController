//
//  ADTransitionController.m
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADTransitionController.h"
#import <QuartzCore/CoreAnimation.h>
#import <objc/runtime.h>

@implementation CATransformLayer (MyExtension)
-(void)setOpaque:(BOOL)opaque { return; } // Avoid warning at start "changing property opaque in transform-only layer, will have no effect"
@end

@implementation ADTransitionView
+ (Class)layerClass {
    return [CATransformLayer class];
}
@end

NSString * ADTransitionControllerAssociationKey = @"ADTransitionControllerAssociationKey";

#define AD_NAVIGATION_BAR_HEIGHT 44.0f
#define AD_TOOLBAR_HEIGHT 44.0f
#define AD_Z_DISTANCE 1000.0f

@interface ADTransitionController (Private)
- (void)_initialize;
- (void)_setupLayers:(NSArray *)layers;
- (void)_teardownLayers:(NSArray *)layers;
- (void)_transitionfromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition;
@end

@interface ADTransitionController () {
    BOOL _shoudPopItem;
}
@end

@implementation ADTransitionController
@synthesize viewControllers = _viewControllers;
@synthesize topViewController = _topViewController;
@synthesize visibleViewController = _visibleViewController;
@synthesize delegate = _delegate;
@synthesize navigationBar = _navigationBar;
@synthesize toolbar = _toolbar;

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

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        [self _initialize];
        [self pushViewController:rootViewController withTransition:nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // Setting the perspective
    float zDistance = AD_Z_DISTANCE;
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -zDistance;
    self.view.layer.sublayerTransform = sublayerTransform;
    
    // Create and add navigation bar to the view
    CGFloat navigationBarHeight = AD_NAVIGATION_BAR_HEIGHT;
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, navigationBarHeight)];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];

    CGFloat toolbarHeight = AD_TOOLBAR_HEIGHT;
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
    [_toolbar setBackgroundColor:[UIColor redColor]];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _toolbar.delegate = self;
    [self.view addSubview:_toolbar];
    
    // Create and add the container view that will hold the controller views
    _containerView = [[ADTransitionView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + navigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - toolbarHeight)];
    _containerView.autoresizesSubviews = YES;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_containerView];
    
    // Add previous view controllers to the container and create navigation items
    NSMutableArray * items = [[NSMutableArray alloc] init];
    for (UIViewController * viewController in self.viewControllers) {
        [self addChildViewController:viewController];
        viewController.view.frame = _containerView.bounds;
        if (viewController == self.viewControllers.lastObject) {
            [_containerView addSubview:viewController.view];
        }
        [viewController didMoveToParentViewController:self];
        
        UINavigationItem * navigationItem = viewController.navigationItem;
        if (!navigationItem) {
            navigationItem = [[UINavigationItem alloc] initWithTitle:viewController.title];
        }
        [items addObject:navigationItem];
    }
    [_navigationBar setItems:items];

    [_toolbar setItems:[[self.viewControllers lastObject] toolbarItems]];
}

- (UIViewController *)topViewController {
    return [_viewControllers lastObject];
}

- (UIViewController *)visibleViewController {
    UIViewController * topViewController = [self topViewController];
    if (topViewController.presentedViewController) {
        return topViewController.presentedViewController;
    } else {
        return topViewController;
    }
}

- (void)viewWillLayoutSubviews {
    if (_isContainerViewTransitioning)
        return;
    CGFloat previousNavigationBarHeight = self.navigationBar.frame.size.height;
    CGFloat previousToolbarHeight = self.toolbar.frame.size.height;
    [self.navigationBar sizeToFit];
    [self.toolbar sizeToFit];
    CGFloat navigationBarHeight = self.navigationBar.frame.size.height;
    CGFloat toolBarHeight = self.toolbar.frame.size.height;
    CGFloat navigationBarHeightDifference = navigationBarHeight - previousNavigationBarHeight;
    CGFloat toolbarHeightDifference = toolBarHeight - previousToolbarHeight;
    _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y + navigationBarHeightDifference, _containerView.frame.size.width, _containerView.frame.size.height - navigationBarHeightDifference - toolbarHeightDifference);
    _toolbar.frame = CGRectMake(_toolbar.frame.origin.x, _toolbar.frame.origin.y - navigationBarHeightDifference, _toolbar.frame.size.width, _toolbar.frame.size.height);
}

#pragma mark -
#pragma mark Appearance

// Forwarding appearance messages when the container appears or disappears
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[_viewControllers lastObject] beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[_viewControllers lastObject] endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[_viewControllers lastObject] beginAppearanceTransition:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[_viewControllers lastObject] endAppearanceTransition];
}

// We are responsible for telling the child when its views are going to appear or disappear
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark -
#pragma mark Push
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition {
    if (_isContainerViewTransitioning || _isNavigationBarTransitioning) {
        return;
    }
    
    objc_setAssociatedObject(viewController, (__bridge const void *)(ADTransitionControllerAssociationKey), self, OBJC_ASSOCIATION_ASSIGN);
    
    UIViewController * viewControllerToRemoveFromView = [_viewControllers lastObject];
    
    [_viewControllers addObject:viewController];
    if (transition) {
        [_transitions addObject:transition];
    } else {
        [_transitions addObject:[ADTransition nullTransition]];
    }
    
    if (!_containerView) {
        return;
    }
    
    BOOL animated = transition ? YES : NO;
    
    
    UIView * viewIn = viewController.view;
    [self addChildViewController:viewController];
    [viewController beginAppearanceTransition:YES animated:animated];
    if ([self.delegate respondsToSelector:@selector(transitionController:willShowViewController:animated:)]) {
        [self.delegate transitionController:self willShowViewController:viewController animated:animated];
    }
    viewIn.frame = _containerView.bounds;
    [_containerView addSubview:viewIn];
    
    UIView * viewOut = viewControllerToRemoveFromView.view;
    [viewControllerToRemoveFromView beginAppearanceTransition:NO animated:animated];
    
    _isContainerViewTransitioning = animated;
    transition.delegate = self;
    transition.type = ADTransitionTypePush;
    [self _transitionfromView:viewOut toView:viewIn withTransition:transition];
    
    _isNavigationBarTransitioning = animated;
    
    UINavigationItem * navigationItem = viewController.navigationItem;
    if (!navigationItem) {
        navigationItem = [[UINavigationItem alloc] initWithTitle:viewController.title];
    }
    if (animated) {
        _isNavigationBarTransitioning = YES;
    }
    navigationItem.hidesBackButton = (_viewControllers.count == 0); // Hide the "Back" button for the root view controller
    [_navigationBar pushNavigationItem:navigationItem animated:animated];
    [_toolbar setItems:viewController.toolbarItems animated:animated];
    
    if (!animated) { // Call the delegate method if no animation
        [self pushTransitionDidFinish:nil];
    }
}

#pragma mark -
#pragma mark Pop
- (UIViewController *)popViewController {
    if ([_transitions count] > 0) {
        UIViewController * viewController = [self popViewControllerWithTransition:[[_transitions lastObject] reverseTransition]];
        return viewController;
    }
    return nil;
}

- (UIViewController *)popViewControllerWithTransition:(ADTransition *)transition {
    if (self.viewControllers.count < 2 || _isContainerViewTransitioning || _isNavigationBarTransitioning) {
        return nil;
    }
    BOOL animated = transition ? YES : NO;
    [_transitions removeLastObject];
    
    UIViewController * inViewController = _viewControllers[([_viewControllers count] - 2)];
    [inViewController beginAppearanceTransition:YES animated:animated];
    if ([self.delegate respondsToSelector:@selector(transitionController:willShowViewController:animated:)]) {
        [self.delegate transitionController:self willShowViewController:inViewController animated:animated];
    }
    inViewController.view.frame = _containerView.bounds;
    [_containerView addSubview:inViewController.view];
    
    UIViewController * outViewController = [_viewControllers lastObject];
    [outViewController willMoveToParentViewController:nil];
    [outViewController beginAppearanceTransition:NO animated:animated];
    
    _isNavigationBarTransitioning = animated;
    _shoudPopItem = YES;
    [_navigationBar popNavigationItemAnimated:animated];
    [_toolbar setItems:inViewController.toolbarItems animated:animated];
    
    _isContainerViewTransitioning = animated;
    transition.delegate = self;
    transition.type = ADTransitionTypePop;
    [self _transitionfromView:outViewController.view toView:inViewController.view withTransition:transition];
    
    if (!animated) { // Call the delegate method if no animation
        [self popTransitionDidFinish:nil];
    }
    
    return outViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController {
    if ([_transitions count] > 0) {
        NSArray * viewControllers = [self popToViewController:viewController withTransition:[[_transitions lastObject] reverseTransition]];
        return viewControllers;
    }
    return nil;
}

- (NSArray *)popToViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition {
    NSUInteger indexInViewController = [_viewControllers indexOfObject:viewController];
    if (indexInViewController == NSNotFound || _isContainerViewTransitioning || _isNavigationBarTransitioning) {
        return nil;
    }
    
    // Create array that will be returned
    NSMutableArray * outViewControllers = [NSMutableArray arrayWithCapacity:(_viewControllers.count - indexInViewController - 1)];
    for (int i = indexInViewController + 1; i < _viewControllers.count; i++) {
        [outViewControllers addObject:_viewControllers[i]];
    }
    
    ADTransition * lastTransition = [_transitions lastObject];
    // Remove all viewControllers and transitions from stack
    for (UIViewController * viewController in outViewControllers) {
        [_viewControllers removeLastObject];
        [_transitions removeLastObject];
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    // and re-add last transition to keep the right count and to pop it later
    [_transitions addObject:lastTransition];
    
    // Set up navigation bar items
    NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:(_viewControllers.count - indexInViewController - 1)];
    for (int i = 0 ; i < _navigationBar.items.count && i <= indexInViewController; i++) {
        [items addObject:_navigationBar.items[i]];
    }
    // add last item to keep the right count and to pop it later
    [items addObject:[_navigationBar.items lastObject]];
    [_navigationBar setItems:items];
    
    // Push last view controller on stack to pop it later
    UIViewController * outViewController = [outViewControllers lastObject];
    [_viewControllers addObject:outViewController];
    [self addChildViewController:outViewController];
    [outViewController didMoveToParentViewController:self];
    
    [self popViewControllerWithTransition:transition];
    
    return outViewControllers;
}

- (NSArray *)popToRootViewController {
    if ([_transitions count] > 0) {
        NSArray * viewControllers = [self popToRootViewControllerWithTransition:[[_transitions lastObject] reverseTransition]];
        return viewControllers;
    }
    return nil;
}

- (NSArray *)popToRootViewControllerWithTransition:(ADTransition *)transition {
    if (_viewControllers.count > 1) { // need at least two controllers
        return [self popToViewController:_viewControllers[0] withTransition:transition];
    }
    return nil;
}

#pragma mark -
#pragma mark ADTransitionDelegate
- (void)pushTransitionDidFinish:(ADTransition *)transition {
    BOOL animated = transition ? YES : NO;
    if ([_viewControllers count] >= 2) {
        UIViewController * outViewController = _viewControllers[([_viewControllers count] - 2)];
        [outViewController.view removeFromSuperview];
        [outViewController endAppearanceTransition];
    }
    UIViewController * inViewController = [_viewControllers lastObject];
    [inViewController endAppearanceTransition];
    [inViewController didMoveToParentViewController:self];
    _isContainerViewTransitioning = NO;
    if ([self.delegate respondsToSelector:@selector(transitionController:didShowViewController:animated:)]) {
        [self.delegate transitionController:self didShowViewController:inViewController animated:animated];
    }
}

- (void)popTransitionDidFinish:(ADTransition *)transition {
    BOOL animated = transition ? YES : NO;
    _containerView.layer.transform = CATransform3DIdentity;

    UIViewController * outViewController = [_viewControllers lastObject];
    [outViewController.view removeFromSuperview];
    [outViewController endAppearanceTransition];
    [outViewController removeFromParentViewController];
    [_viewControllers removeLastObject];
    
    UIViewController * inViewController = [_viewControllers lastObject];
    inViewController.view.layer.transform = CATransform3DIdentity;
    [inViewController endAppearanceTransition];
    _isContainerViewTransitioning = NO;
    if ([self.delegate respondsToSelector:@selector(transitionController:didShowViewController:animated:)]) {
        [self.delegate transitionController:self didShowViewController:inViewController animated:animated];
    }
}

#pragma mark -
#pragma mark UINavigationBar

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat navigationBarHeight = _navigationBar.frame.size.height;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    if ([self isNavigationBarHidden] && !hidden) {
        _navigationBar.alpha = 1.0f;
        _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y + navigationBarHeight, _containerView.frame.size.width, _containerView.frame.size.height - navigationBarHeight);
    } else if (![self isNavigationBarHidden] && hidden) {
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
    if (_shoudPopItem) {
        _shoudPopItem = NO;
        return YES;
    } else { // Hit the back button of the navigation bar
        [self popViewController];
        return NO;
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    _isNavigationBarTransitioning = NO;
}

-(void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    _isNavigationBarTransitioning = NO;
}

#pragma mark -
#pragma mark UIToolbar

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat toolbarHeight = _toolbar.frame.size.height;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    CGRect frame = _containerView.frame;
    if ([self isToolbarHidden] && !hidden) {
        _toolbar.alpha = 1.0f;
        frame.size.height = _containerView.frame.size.height - toolbarHeight;
    } else if (![self isToolbarHidden] && hidden) {
        _toolbar.alpha = 0.0f;
        frame.size.height = _containerView.frame.size.height + toolbarHeight;
    }
    _containerView.frame = frame;
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)setToolbarHidden:(BOOL)hidden {
    [self setToolbarHidden:hidden animated:NO];
}

- (BOOL)isToolbarHidden {
    return _toolbar.alpha < 0.5f;
}

@end

@implementation ADTransitionController (Private)

- (void)_initialize {
    if (self) {
        _viewControllers = [[NSMutableArray alloc] init];
        _transitions = [[NSMutableArray alloc] init];
        _isContainerViewTransitioning = NO;
        _isNavigationBarTransitioning = NO;
        _shoudPopItem = NO;
        _delegate = nil;
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

- (void)_transitionfromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition {
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

