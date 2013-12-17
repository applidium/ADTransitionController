# ADTransitionController - custom navigation controller

ADTransitionController is drop-in replacement for UINavigationController with custom transition animations.

## Installation

### Basic
1. Add the content of the `ADTransitionController` folder to your iOS project
2. Link against the `QuartzCore` Framework if you don't already
3. Import `ADTransitionController.h` in your project

### CocoaPods

1. Add `pod 'ADTransitionController'` to your `Podfile`
2. In your terminal run `$ pod install` and open your workspace `$ open yourApp.xcworkspace`
3. Import `<ADTransitionController.h>` in your project

### ARC

If you are working on an ARC project, use the `-fno-objc-arc` flag in *Build Phases > Compile Sources*.
![Compilation Flag For ARC](http://applidium.github.io/ADTransitionController/images/fno-objc_arc.png)

## Example

Your project is now ready to take advantage of `ADTransitionController`. Here are two examples of how to use it. One if you plan to develop for iOS7 only, the other one if you want to support both iOS7 and iOS6.

Our last API designed for iOS7 is so simple you don't even have to change your architecture. Just drag and drop our files in XCode, import the correct headers, make some minor adjustements to your code and that's it. You are ready to go.
If you want to support prior versions of iOS, we also provide an easy way to do so. You just need to replace your `UINavigationController` by our `ADTransitionController`.

Let's see exactly how it works.

### iOS7

The simplest way to use custom animations in iOS7 is to create a `UINavigationViewController` like in any other project and to make your view controllers inherit from `ADTransitioningViewController`. The `ADTransitioningViewController` class provides a property `transition` you should use to animate the push and pop actions.

First of all, create your `UINavigationController` and set its delegate with a `ADNavigationControllerDelegate` object. This setup enables the use of custom animations.
```
#import "ADNavigationControllerDelegate.h"
...
UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
ADNavigationControllerDelegate * navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
navigationController.delegate = navigationDelegate;
self.window.rootViewController = navigationController;
[navigationController release];
```

Then create your new controller (that inherits from `ADTransitioningViewController`), set its transition and push it onto the stack. In this example, this will animate the transition with a cube effect.
```
UIViewController * newViewController = [[UIViewController alloc] init];
ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
newViewController.transition = transition;
[self.navigationController pushViewController:newViewController animated:YES];
[transition release];
[newViewController release];
```

If your view controller can't inherit from `ADTransitioningViewController`, you can use directly an `ADTransitioningDelegate` object to control the transition.
It's just one more line of code.

```
UIViewController * newViewController = [[UIViewController alloc] init];
ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
ADTransitioningDelegate * transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
newViewController.transitioningDelegate = transitioningDelegate;
[self.navigationController pushViewController:newViewController animated:YES];
[transition release];
[newViewController release];
```

You may wonder what is really going on under the hood ? In fact we use the latest API provided by Apple to create custom animations for `UINavigationController`. This API is kinda difficult to put into place so that's why we chose to make things as simple as we could to help you use our animations. 

To create a custom animation, Apple provides different protocols we have implemented for you : `UIViewControllerTransitioningDelegate`, `UIViewControllerAnimatedTransitioning`, `UIViewControllerContextTransitioning`. That way, you shouldn't bother to dig into these APIs. 

As we have just seen it, in pratice, what you only have to do on iOS7 is to create a `UINavigationController`, and a `ADTransition`.

Then you have two options : 
- you make your viewControllers inherit from `ADTransitioningViewController`, which provides a property `transition` you will have to set to customize the animation of the push/pop.
- you can't make you viewControllers inherit from `ADTransitioningViewController` so you need to set the `transitioningDelegate` property of `UIViewController` with a `ADTransitioningDelegate` object.

In either way, you never worry about what's going on behind the scene. Just create you transition and push you new viewController onto the stack.

To sum up, we provide three different classes you may want to use : 
- `ADNavigationControllerDelegate` : used when you setup your navigation controller to perform custom animations
- `ADTransitioningViewController` : used for your view controllers to control their transitions
- `ADTransitioningDelegate` : used only if you can't inherit from `ADTransitioningViewController` and need to specify the transitioning delegate for the view controller

### Before iOS7
 
If you need to support prior versions of iOS7, there is also an easy way to do. You just have not to use a `UINavigationControler` but an `ADTransitionController` instead that behaves similarly. 

Instantiate an `ADTransitionController` like a `UINavigationController`:

```objective-c
UIViewController * viewController = [[UIViewController alloc] init];
ADTransitionController * transitionController = [[ADTransitionController alloc] initWithRootViewController:viewController];
[viewController release];
self.window.rootViewController = transitionController;
[transitionController release];
```

To push a viewController on the stack, instantiate an `ADTransition` and use the `pushViewController:withTransition:` method.

```objective-c
- (IBAction)pushWithCube:(id)sender {
    UIViewController * viewController = [[UIViewController alloc] init];
    ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:transition];
    [transition release];
    [viewController release];
}
```

To pop a viewController from the stack, just use the `popViewController` method.

```objective-c
- (IBAction)pop:(id)sender {
    [self.transitionController popViewController];
}
```

### Note
When a `UIViewController` is pushed onto the stack of view controllers, the property `transitionController` becomes available to the controller (see example above: `self.transitionController`). This way, an `ADTransitionController` can be used like a `UINavigationController`.

## ADTransition subclasses

For now, the built-in transitions available are the following. Try out [our demo application](https://github.com/applidium/ADTransitionController/archive/master.zip) to see them in action! 

`ADCarrouselTransition`, `ADCubeTransition`, `ADCrossTransition`, `ADFlipTransition`, `ADSwapTransition`, `ADFadeTransition`, `ADBackFadeTransition`, `ADGhostTransition`, `ADZoomTransition`, `ADSwipeTransition`, `ADSwipeFadeTransition`, `ADScaleTransition`, `ADGlueTransition`, `ADPushRotateTransition`, `ADFoldTransition`, `ADSlideTransition`.

## ADTransitionController API

The `ADTransitionController` API is fully inspired by the `UINavigationController`, to be very easy to integrate in your projects. The few differences between the two APIs are presented below.

### Methods

The point of `ADTransitionController` is to be able to customize the animations for a transition between two `UIViewController` instances. Here are the methods we added to let you take advantage of the built-in transitions: 

```objective-c
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition;
- (UIViewController *)popViewControllerWithTransition:(ADTransition *)transition;
- (NSArray *)popToViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition;
- (NSArray *)popToRootViewControllerWithTransition:(ADTransition *)transition;
```

Here are the convention for the push and pop actions:   

- pass `nil` to the transition parameter to disable the animation. Thus the transition won't be animated.
- pass an `ADTransition` instance to the transition parameter to animate the push action.
- by default the pop action uses the *reverse animation* used for the push action. However you can pass a different transition to the transition parameter to change this behavior.


### Delegate

Like a `UINavigationController`, an `ADTransitionController` informs its delegate that a viewController is going to be presented or was presented. The delegate implements the `ADTransitionControllerDelegate` protocol.

```objective-c
@property (nonatomic, assign) id<ADTransitionControllerDelegate> delegate;
```

```objective-c
@protocol ADTransitionControllerDelegate <NSObject>
- (void)transitionController:(ADTransitionController *)transitionController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)transitionController:(ADTransitionController *)transitionController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
```


## Going Further

If you want to totally take control of the `ADTransitionController` API, feel free to create your own transitions and animations!
All you need to do is to subclass `ADDualTransition` or `ADTransformTransition` and implement a `init` method.

The simplest example of a custom transition is the `ADFadeTransition` class. The effect is simple: the inViewController fades in. For this the inViewController changes its opacity from 0 to 1 and the outViewController from 1 to 0.

```objective-c
@interface ADFadeTransition : ADDualTransition
@end
@implementation ADFadeTransition
- (id)initWithDuration:(CFTimeInterval)duration {
    CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inFadeAnimation.fromValue = @0.0f;
    inFadeAnimation.toValue = @1.0f;
    inFadeAnimation.duration = duration;
    
    CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outFadeAnimation.fromValue = @1.0f;
    outFadeAnimation.toValue = @0.0f;
    outFadeAnimation.duration = duration;
    
    self = [super initWithInAnimation:inFadeAnimation andOutAnimation:outFadeAnimation];
    return self;
}
@end
```

This example is really basic and if you want to create more funky effects, just have a look to the following API and the examples we provided.

### ADTransition API

The `ADTransition` class is an abstract class that has two abstract subclasses: `ADDualTransition` and `ADTransformTransition`.

Instances of `ADDualTransition` have two importants properties: 

```objective-c
@property (nonatomic, readonly) CAAnimation * inAnimation;
@property (nonatomic, readonly) CAAnimation * outAnimation;
```

The `inAnimation` is the `CAAnimation` that will be applied to the layer of the viewController that is going to be presented during the transition.
The `outAnimation` is the `CAAnimation` that will be applied to the layer of the viewController that is going to be dismissed during the transition.

Instance of `ADTransformTransition` have three importants properties:

```objective-c
@property (readonly) CAAnimation * animation;
@property (readonly) CATransform3D inLayerTransform;
@property (readonly) CATransform3D outLayerTransform;
```

The `inLayerTransform` is the `CATransform3D` that will be applied to the layer of the viewController that is going to be presented during the transition.
The `outLayerTransform` is the `CATransform3D` that will be applied to the layer of the viewController that is going to be dismissed during the transition.
The `animation` is the `CAAnimation` that will be applied to the content layer of the ADTransitionController (i.e. the parent layer of the two former viewController layers).

## Future Work

There are a couple of improvements that could be done. Feel free to send us pull requests if you want to contribute!

- Add new custom transitions
- Add support for non plane transitions (Fold transition for instance)
- More?
