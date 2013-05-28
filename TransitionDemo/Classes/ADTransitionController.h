//
//  ADTransitionController.h
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTransition.h"

// Our container view must be backed by a CATransformLayer
@interface ADTransitionView : UIView {    
}
@end

@interface ADTransitionController : UIViewController <ADTransitionDelegate, UINavigationBarDelegate> {
    NSMutableArray *  _viewControllers;
    NSMutableArray *  _transitions; // Transition stack, paired with the view controller stack
    BOOL              _isContainerViewTransitioning;
    BOOL              _isNavigationBarTransitioning;
    UINavigationBar * _navigationBar;
    UIView *          _containerView;
}

@property (nonatomic,copy) NSMutableArray * viewControllers;
@property(nonatomic, getter = isNavigationBarHidden, setter = setNavigationBarHidden:) BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)animation;
- (UIViewController *)popViewController;
- (UIViewController *)popViewControllerWithTransition:(ADTransition *)animation;

@end
