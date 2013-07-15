## Quickstart
1. Add the content of the `ADTransitionController` folder to your iOS project
2. Link against the `QuartzCore Framework` if you don't already
3. Import `ADTransitionController.h` and use it like you would use a UINavigationController
4. Navigate through your controllers by calling `pushViewController:withTransition:` and `popViewController`

## Example
 
Instantiate an ADTransitionController like a UINavigationController :

```objective-c
UIViewController * viewController = [[UIViewController alloc] init];
ADTransitionController * transitionController = [[ADTransitionController alloc] initWithRootViewController:viewController];
[viewController release];
self.window.rootViewController = transitionController;
[transitionController release];
```

To push a viewController on the stack, instantiate an ADTransition and use the `pushViewController:withTransition:` method.

```objective-c
- (IBAction)pushWithCube:(id)sender {
    UIViewController * viewController = [[UIViewController alloc] init];
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
When a `UIViewController` is pushed onto the stack of view controllers, the property `transitionController` becomes available to the controller (see example above: `self.transitionController`). This way, an `ADTransitionController` can be used like a `UINavigationController`.

## ADTransitionController API

The `ADTransitionController` API is fully inspired by the `UINavigationController`, to be very easy to integrate in your projects. The few differences between the two APIs are presented below.

### Methods

The point of ADTransitionController is to be able to customize the animations for a transition between two UIViewController instances. By default the behavior is the following : 

- pass `nil` to the transition parameters and the transition won't be animated
- pass an `ADTransition` instance to animate the push
- by default the pop uses the reverse animation used for the push but you can pass a different transition to change this behavior.

```objective-c
- (void)pushViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition;
- (UIViewController *)popViewControllerWithTransition:(ADTransition *)transition;
- (NSArray *)popToViewController:(UIViewController *)viewController withTransition:(ADTransition *)transition ;
- (NSArray *)popToRootViewControllerWithTransition:(ADTransition *)transition;
```

### Delegate

Like a UINavigationController, an ADTransitionController informs its delegate that a viewController is going to be presented or was presented. The delegate implements the `ADTransitionControllerDelegate` protocol.

```objective-c
@property (nonatomic, assign) id<ADTransitionControllerDelegate> delegate;
```

```objective-c
@protocol ADTransitionControllerDelegate <NSObject>
- (void)transitionController:(ADTransitionController *)transitionController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)transitionController:(ADTransitionController *)transitionController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
```

## ADTransitions

The `ADTransition` class is an abstract class that has two abstract subclasses : `ADDualTransition` and `ADTransformTransition`.

For now, the transitions available in the project are the following : 

`ADCarrouselTransition`, `ADCubeTransition`, `ADCrossTransition`, `ADFlipTransition`, `ADSwapTransition`, `ADFadeTransition`, `ADBackFadeTransition`, `ADGhostTransition`, `ADZoomTransition`, `ADSwipeTransition`, `ADSwipeFadeTransition`, `ADScaleTransition`, `ADGlueTransition`, `ADPushRotateTransition`, `ADFoldTransition`, `ADSlideTransition`.

The transitions included in the project are supposed to be a base for creating new ones. 


## Going Further

If you want to totally take control of the `ADTranstionController` API, feel free to create your own transitions and animations!
All you need to do to create your own transition is to subclass `ADDualTransition` or `ADTransformTransition` and implement a `init` method.

The simplest example of a custom transition is the `ADFadeTransition` class. The effect is simple : the inViewController changes its opacity from 0 to 1 and the outViewController from 1 to 0.

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

## Future Work

There are a couple of improvements that could be done. Feel free to send us pull requests if you want to contribute!

- Add new custom transitions
- Add support for non plane transitions (Fold transtion for instance)
- More?