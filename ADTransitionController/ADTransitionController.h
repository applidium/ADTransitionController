//
//  ADTransitionController.h
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ADTransitionController.h"
#import "ADTransition.h"
#import "ADDualTransition.h"
#import "ADTransformTransition.h"
#import "ADCarrouselTransition.h"
#import "ADCubeTransition.h"
#import "ADCrossTransition.h"
#import "ADFadeTransition.h"
#import "ADFlipTransition.h"
#import "ADSwapTransition.h"
#import "ADGhostTransition.h"
#import "ADBackFadeTransition.h"
#import "ADZoomTransition.h"
#import "ADSwipeTransition.h"
#import "ADSwipeFadeTransition.h"
#import "ADScaleTransition.h"
#import "ADGlueTransition.h"
#import "ADPushRotateTransition.h"
#import "ADFoldTransition.h"
#import "ADSlideTransition.h"
#import "ADModernPushTransition.h"

/**
 The class represent root controller in a view hierarchy.
 */
@protocol UIViewControllerIOS7Support <NSObject>
/* Legacy support: UIViewController methods introduced in iOS 7.0
 * For those still on 5.x and 6.x, we have to declare these methods so the
 * the compiler knows the right return datatypes.
 */
@optional
@property(nonatomic,assign) NSUInteger edgesForExtendedLayout; // Defaults to UIRectEdgeAll on iOS7. We will set to UIRectEdgeNone
@property(nonatomic,assign) BOOL extendedLayoutIncludesOpaqueBars; // Defaults to NO, but bars are translucent by default on 7_0.
@property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets; // Defaults to NO
@end

@protocol UIImageIOS7Support <NSObject>
@optional
- (UIImage *)imageWithRenderingMode:(NSInteger)renderingMode;
@end

// Our container view must be backed by a CATransformLayer
@interface ADTransitionView : UIView
@end

@protocol ADTransitionControllerDelegate;

@interface ADTransitionController : UIViewController <ADTransitionDelegate, UINavigationBarDelegate, UIToolbarDelegate> {
    NSMutableArray *  _viewControllers;
    NSMutableArray *  _transitions; // Transition stack, paired with the view controller stack
    BOOL              _isContainerViewTransitioning;
    BOOL              _isNavigationBarTransitioning;
    UINavigationBar * _navigationBar;
    UIToolbar *       _toolbar;
    UIView *          _containerView;
}

@property (nonatomic, copy) NSMutableArray * viewControllers;
@property (nonatomic, readonly, retain) UIViewController * topViewController;
@property (nonatomic, readonly, retain) UIViewController * visibleViewController;
@property(nonatomic, readonly) UINavigationBar * navigationBar;
@property(nonatomic, readonly) UIToolbar* toolbar;
@property (nonatomic, assign) id<ADTransitionControllerDelegate> delegate;
@property(nonatomic, getter = isNavigationBarHidden, setter = setNavigationBarHidden:) BOOL navigationBarHidden;
@property(nonatomic, getter = isToolbarHidden, setter = setToolbarHidden:) BOOL toolbarHidden;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition;
- (UIViewController *)popViewController;
- (UIViewController *)popViewControllerWithTransition:(ADTransition *)transition;
- (NSArray *)popToViewController:(UIViewController *)viewController;
- (NSArray *)popToViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition ;
- (NSArray *)popToRootViewController;
- (NSArray *)popToRootViewControllerWithTransition:(ADTransition *)transition;
@end

@protocol ADTransitionControllerDelegate <NSObject>
- (void)transitionController:(ADTransitionController *)transitionController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)transitionController:(ADTransitionController *)transitionController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end