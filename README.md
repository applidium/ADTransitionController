# ADTransitionController - custom navigation controller

ADTransitionController is drop-in replacement of UINavigationController built with custom transition animations.

## How to use
1. Add the content of the ADTransitionController folder to your iOS project
2. Link against the QuartzCore framework if you don't already
3. Import `ADTransitionController.h` and use it like you would use a UINavigationController
4. Navigate through your controllers by calling `pushViewController:withTransition:` and `popViewController`.

## Example
 
Instantiate an ADTransitionController like a UINavigationController :
```objective-c
ADViewController * viewController = [[ADViewController alloc] init];
ADTransitionController * transitionController = [[ADTransitionController alloc] initWithRootViewController:viewController];
[viewController release];
self.window.rootViewController = transitionController;
[transitionController release];
```

To push a viewController on the stack, instantiate an ADTransition and use the `pushViewController:withTransition:` method.
```objective-c
- (IBAction)pushWithCube:(id)sender {
    ADViewController * viewController = [[ADViewController alloc] init];
    ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:transition];
    [transition release];
    [viewController release];
}
```

To pop a viewController from the stack, just use the popViewController method.
```objective-c
- (IBAction)pop:(id)sender {
    [self.transitionController popViewController];
}
```

### Note
When a `UIViewController` is pushed onto the stack of view controllers, the property `transitionController` becomes available to the controller (see example below: `viewController.transitionController`). This way, an `ADTransitionController` can be used like a `UINavigationController`.

## ADTransitionController API

The ADTransitionController API is fully inspired by the UINavigationController, to be very easy to integrate in your projects.

### Properties

```objective-c
@property (nonatomic, copy) NSMutableArray * viewControllers;
```
The view controllers that are currently in the hierarchy. The rootViewController is at index 0, the top view controller at index n-1.

```objective-c
@property (nonatomic, readonly, retain) UIViewController * topViewController;
```
The view controller at the top of the navigation stack. (read-only)

```objective-c
@property (nonatomic, readonly, retain) UIViewController * visibleViewController;
```
The visible view that belongs either to the top view controller or to a view controller that was presented modally. (read-only)

```objective-c
@property(nonatomic, getter = isNavigationBarHidden, setter = setNavigationBarHidden:) BOOL navigationBarHidden;
```
A boolean value that indicates if the navigation bar is hidden.

```objective-c
@property(nonatomic, readonly) UINavigationBar * navigationBar;
```
The navigation bar managed by the transition controller. (read-only)

```objective-c
@property (nonatomic, assign) id<ADTransitionControllerDelegate> delegate;
```
The receiver’s delegate or nil if it doesn’t have a delegate. Implements the `ADTransitionControllerDelegate` protocol.

### Methods

```objective-c
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
```
Show or hide the navigation bar. This behavior can be animated.

```objective-c
- (id)initWithRootViewController:(UIViewController *)rootViewController;
```
Init the view controller stack with `rootViewController`.

```objective-c
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition;
```
Push the view controller `viewController` onto the stack of view controllers. Pass an `ADTransition` instance to animate the transition. Pass `nil` to push the view controller without animation.

```objective-c
- (UIViewController *)popViewController;
- (UIViewController *)popViewControllerWithTransition:(ADTransition *)transition;
```
Return and pop the topViewController. The method `popViewController` uses the reverse transition of the last one used to push a controller. `popViewControllerWithTransition:` allows you to pass another transition.

```objective-c
- (NSArray *)popToViewController:(UIViewController *)viewController;
- (NSArray *)popToViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition ;
```
Return an array of view controllers that are poped from the stack. `viewController` becomes the topViewController. The method `popToViewController:` uses the reverse of the last transition used to push a controller. `popToViewController:withTransition:` take an `ADTransition` instance in parameter. If you pass nil, no animation is preformed.

```objective-c
- (NSArray *)popToRootViewController;
- (NSArray *)popToRootViewControllerWithTransition:(ADTransition *)transition;
```
Return an array of viewControllers that are poped from the stack. The rootViewController becomes the topViewController. The method `popToRootViewController` uses the reverse of the last transition used to push a controller. `popToRootViewControllerWithTransition:` take an `ADTransition` instance in parameter. If you pass nil, no animation is preformed.

### Delegate

Like a UINavigationController, an ADTransitionController informs its delegate that a viewController is going to be presented or was presented.

```objective-c
@protocol ADTransitionControllerDelegate <NSObject>
- (void)transitionController:(ADTransitionController *)transitionController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)transitionController:(ADTransitionController *)transitionController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
```

## ADTransitions

The `ADTransition` class is an abstract class that has two abstract subclasses : `ADDualTransition` and `ADTransformTransition`.

For now, the transitions available in the project are the following : 

- ADCarrousselTransition
- ADCubeTransition
- ADCrossTransition
- ADFlipTransition
- ADSwapTransition
- ADFadeTransition
- ADBackFadeTransition
- ADGhostTransition
- ADZoomTransition
- ADSwipeTransition
- ADSwipeFadeTransition
- ADScaleTransition
- ADGlueTransition
- ADPushRotateTransition
- ADFoldTransition
- ADSlideTransition

The transitions included in the project are supposed to be a base for creating new ones. 

### ADDualTransition

Instances of `ADDualTransition` have two importants properties: 
```objective-c
@property (nonatomic, readonly) CAAnimation * inAnimation;
@property (nonatomic, readonly) CAAnimation * outAnimation;
```

The `inAnimation` is the `CAAnimation` that will be applied to the layer of the viewController that is going to be presented during the transition.
The `outAnimation` is the `CAAnimation` that will be applied to the layer of the viewController that is going to be dismissed during the transition.

### ADTransformTransition

Instance of `ADTransformTransition` have three importants properties:
```objective-c
@property (readonly) CAAnimation * animation;
@property (readonly) CATransform3D inLayerTransform;
@property (readonly) CATransform3D outLayerTransform;
```

The `inLayerTransform` is the `CATransform3D` that will be applied to the layer of the viewController that is going to be presented during the transition.
The `outLayerTransform` is the `CATransform3D` that will be applied to the layer of the viewController that is going to be dismissed during the transition.
The `animation` is the `CAAnimation` that will be applied to the content layer of the ADTransitionController (i.e. the parent layer of the two viewController layers above).

## Create your own transitions

All you need to do to create your own transition is to subclass `ADDualTransition` or `ADTransformTransition` and implement a `init` method.

Feel free to be inspired by the transition already available.

The simplest example of a custom transition is the `ADFadeTransition` class. The effect is simple : the inViewController changes its opacity from 0 to 1 and the outViewController from 1 to 0.

```objective-c
@interface ADFadeTransition : ADDualTransition
@end
@implementation ADFadeTransition
- (id)initWithDuration:(CFTimeInterval)duration {
    CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inFadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    inFadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    inFadeAnimation.duration = duration;
    
    CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outFadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    outFadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    outFadeAnimation.duration = duration;
    
    self = [super initWithInAnimation:inFadeAnimation andOutAnimation:outFadeAnimation];
    return self;
}
@end
```

## Future Work

There are a couple of improvements that could be done. Feel free to send us pull requests if you want to contribute!

- Add new custom transitions
- Add support for non plane transitions
- More?