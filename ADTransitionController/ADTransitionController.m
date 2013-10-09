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

#define AD_NAVIGATION_BAR_HEIGHT_PORTRAIT 44.0f
#define AD_TOOLBAR_BAR_HEIGHT 44.0f
#define AD_Z_DISTANCE 1000.0f

@interface ADTransitionController (Private)
- (void)_initialize;
- (void)_setupLayers:(NSArray *)layers;
- (void)_teardownLayers:(NSArray *)layers;
- (void)_transitionfromView:(UIView *)viewOut toView:(UIView *)viewIn withTransition:(ADTransition *)transition;
@end

@interface ADTransitionController () {
    BOOL _shoudPopItem;
    BOOL _ios7OrGreater;
    CGFloat _statusBarDecale;
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

- (void)dealloc {
    [_transitions release], _transitions = nil;
    [_viewControllers release], _viewControllers = nil;
    [_navigationBar release], _navigationBar = nil;
    [_toolbar release], _toolbar = nil;
    [super dealloc];
}

- (void) updateLayout
{
    // Adjust the toolbar height depending on the screen orientation
    [self.toolbar sizeToFit];
    CGSize toolbarSize = self.toolbar.frame.size;
    self.toolbar.frame = (CGRect){CGPointMake(0.f, CGRectGetHeight(self.view.bounds) - toolbarSize.height), toolbarSize};
    [self.navigationBar sizeToFit];
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
    
    // Create and add the container view that will hold the controller views
    _containerView = [[ADTransitionView alloc] initWithFrame:CGRectZero];
    _containerView.autoresizesSubviews = YES;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_containerView];
    [_containerView release];
    
    // Create and add navigation bar to the view
    id vcbasedStatHidden = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];

    _statusBarDecale = (_ios7OrGreater && (!vcbasedStatHidden || [vcbasedStatHidden boolValue]))?20:0;
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, _statusBarDecale, 0, 0)];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
    
    // Create and add toolbar to the view
    _toolbar= [[UIToolbar alloc] initWithFrame:CGRectZero];
//    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _toolbar.delegate = self;
    _toolbar.hidden = YES;
    [self.view addSubview:_toolbar];
    
    [self updateLayout];

    
    // Add previous view controllers to the container and create navigation items
    NSMutableArray * items = [[NSMutableArray alloc] init];
    for (UIViewController * viewController in self.viewControllers) {
        [self addChildViewController:viewController];
        viewController.view.frame = _containerView.bounds;
        if (viewController == self.viewControllers.lastObject) {
            [_containerView addSubview:viewController.view];
            [self updateLayoutForController:viewController];
        }
        [viewController didMoveToParentViewController:self];
        
        UINavigationItem * navigationItem = viewController.navigationItem;
        if (!navigationItem) {
            navigationItem = [[[UINavigationItem alloc] initWithTitle:viewController.title] autorelease];
        }
        [items addObject:navigationItem];
    }
    [_navigationBar setItems:items];
    [items release];
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

#pragma mark -
#pragma mark Appearance

// Forwarding appearance messages when the container appears or disappears
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLayout];
    [self updateLayoutForController:self.viewControllers.lastObject];
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


-(void)adjustScrollViewInsetsForView:(UIView*)inView topCrop:(BOOL)topCrop bottomCrop:(BOOL)bottomCrop
{
    CGFloat navigationBarHeight = _navigationBar.hidden?0:_navigationBar.frame.size.height;
    CGFloat toolbarHeight = _toolbar.hidden?0:_toolbar.frame.size.height;
    for (UIView* view in inView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView* scrollview = (UIScrollView*)view;
            CGRect originalFrame = scrollview.frame;
            CGRect scrollviewRect = [scrollview convertRect:originalFrame toView:_containerView];
            UIEdgeInsets oldInset = scrollview.contentInset;
            CGPoint oldOffset = scrollview.contentOffset;
            scrollviewRect.origin.y += oldOffset.y;
            
            UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
            if (!topCrop && navigationBarHeight > 0 && scrollviewRect.origin.y <= navigationBarHeight)
            {
                inset.top = navigationBarHeight + _statusBarDecale - scrollviewRect.origin.y;
            }
            if (!bottomCrop && toolbarHeight > 0)
            {
                CGFloat diff = toolbarHeight - (self.view.bounds.size.height - (_containerView.frame.origin.y + scrollviewRect.origin.y + scrollviewRect.size.height));
                if (diff <= toolbarHeight) {
                    inset.bottom = diff;
                }
            }
            if (!UIEdgeInsetsEqualToEdgeInsets(oldInset, inset)) {
                scrollview.contentInset = scrollview.scrollIndicatorInsets = inset;
                scrollview.contentOffset = CGPointMake(0,-inset.top);
            }
        }
        [self adjustScrollViewInsetsForView:view topCrop:topCrop bottomCrop:bottomCrop];
    }
}


-(void)updateLayoutForController:(id)controller
{
    BOOL topEdge = _navigationBar.translucent;
    BOOL bottomEdge = _toolbar.translucent;
    BOOL includeOpaqueBars = NO;
    BOOL adjustScrollViewInsets = NO;
    if (_ios7OrGreater) {
        id<UIViewControllerIOS7Support> theController = controller;
        int edges = [theController edgesForExtendedLayout];
        topEdge = ((edges & 1/*UIRectEdgeTop*/) != 0);
        bottomEdge = ((edges & 4/*UIRectEdgeBottom*/) != 0);
        includeOpaqueBars = [theController extendedLayoutIncludesOpaqueBars];
        adjustScrollViewInsets = [theController automaticallyAdjustsScrollViewInsets];
    }
    
    BOOL navigationBarVisible = !_navigationBar.hidden;
    BOOL toolbarBarVisible = !_toolbar.hidden;
    
    BOOL bottomCrop = !bottomEdge && toolbarBarVisible && !includeOpaqueBars;
    BOOL topCrop = !topEdge && navigationBarVisible && !includeOpaqueBars;
    CGRect frame = CGRectMake(0, 0, self.navigationBar.frame.size.width, self.view.bounds.size.height);
    CGFloat navigationBarHeight = _navigationBar.frame.size.height;
    CGFloat toolbarHeight = _toolbar.frame.size.height;
    if (topCrop) {
        frame.origin.y = navigationBarHeight;
        frame.size.height -= navigationBarHeight;
    }
    if (bottomCrop) {
        frame.size.height -= toolbarHeight;
    }
    
    _containerView.frame = frame;
    ((UIViewController*)controller).view.frame = _containerView.bounds;
   if (adjustScrollViewInsets) {
        [self adjustScrollViewInsetsForView:((UIViewController*)controller).view topCrop:topCrop bottomCrop:bottomCrop];
    }
    _toolbar.items = ((UIViewController*)controller).toolbarItems;
}

#pragma mark -
#pragma mark Push
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition {
    if (_isContainerViewTransitioning || _isNavigationBarTransitioning) {
        return;
    }
    
    objc_setAssociatedObject(viewController, ADTransitionControllerAssociationKey, self, OBJC_ASSOCIATION_ASSIGN);
    
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
    [self updateLayoutForController:viewController];
    
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
        navigationItem = [[[UINavigationItem alloc] initWithTitle:viewController.title] autorelease];
    }
    if (animated) {
        _isNavigationBarTransitioning = YES;
    }
    navigationItem.hidesBackButton = (_viewControllers.count == 0); // Hide the "Back" button for the root view controller
    [_navigationBar pushNavigationItem:navigationItem animated:animated];
    
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
    
    UIViewController * inViewController = [_viewControllers objectAtIndex:([_viewControllers count] - 2)];
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
    
    ADTransition * lastTransition = [[_transitions lastObject] retain];
    // Remove all viewControllers and transitions from stack
    for (UIViewController * viewController in outViewControllers) {
        [_viewControllers removeLastObject];
        [_transitions removeLastObject];
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    // and re-add last transition to keep the right count and to pop it later
    [_transitions addObject:lastTransition];
    [lastTransition release];
    
    // Set up navigation bar items
    NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:(_viewControllers.count - indexInViewController - 1)];
    for (int i = 0 ; i < _navigationBar.items.count && i <= indexInViewController; i++) {
        [items addObject:_navigationBar.items[i]];
    }
    // add last item to keep the right count and to pop it later
    [items addObject:[_navigationBar.items lastObject]];
    [_navigationBar setItems:items];
    [items release];
    
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
        UIViewController * outViewController = [_viewControllers objectAtIndex:([_viewControllers count] - 2)];
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
    if (_navigationBar.hidden == hidden) return;
    CGFloat navigationBarHeight = _navigationBar.frame.size.height;
    _navigationBar.hidden = hidden;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    [self updateLayoutForController:self.viewControllers.lastObject];
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

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    if ([bar isKindOfClass:[UIToolbar class]])
        return UIBarPositionBottom;
    return UIBarPositionTopAttached;
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
        _ios7OrGreater = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
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


#pragma mark -
#pragma mark UIToolBar

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated {
    
    if (_toolbar.hidden == hidden) return;
    _toolbar.hidden = hidden;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    [self updateLayoutForController:self.viewControllers.lastObject];
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

-(void)updateLayoutForInterfaceRotation
{
    [self updateLayout];
    [self updateLayoutForController:self.viewControllers.lastObject];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayout];
    [self updateLayoutForController:self.viewControllers.lastObject];
}

@end

