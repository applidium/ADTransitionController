//
//  ADTransition.m
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADTransition.h"

NSString * ADTransitionAnimationKey = @"ADTransitionAnimationKey";
NSString * ADTransitionAnimationInValue = @"ADTransitionAnimationInValue";
NSString * ADTransitionAnimationOutValue = @"ADTransitionAnimationOutValue";

@implementation ADTransition
@synthesize delegate = _delegate;
@synthesize type = _type;

+ (ADTransition *)nullTransition {
    return [[ADTransition alloc] init];
}

- (ADTransition *)reverseTransition {
    return nil;
}


- (NSArray *)getCircleApproximationTimingFunctions {
    // The following CAMediaTimingFunction mimics zPosition = sin(t)
    // Empiric (possibly incorrect, but it does the job) implementation based on the circle approximation with bezier cubic curves
    // ( http://www.whizkidtech.redprince.net/bezier/circle/ )
    // sin(t) tangent for t=0 is a diagonal. But we have to remap x=[0;PI/2] to t=[0;1]. => scale with M_PI/2.0f factor
    
    const double kappa = 4.0/3.0 * (sqrt(2.0)-1.0) / sqrt(2.0);
    CAMediaTimingFunction *firstQuarterCircleApproximationFuction = [CAMediaTimingFunction functionWithControlPoints:kappa /(M_PI/2.0f) :kappa :1.0-kappa :1.0];
    CAMediaTimingFunction * secondQuarterCircleApproximationFuction = [CAMediaTimingFunction functionWithControlPoints:kappa :0.0 :1.0-(kappa /(M_PI/2.0f)) :1.0-kappa];
    return @[firstQuarterCircleApproximationFuction, secondQuarterCircleApproximationFuction];
}

- (NSTimeInterval)duration {
    NSAssert(FALSE, @"This abstract method must be implemented!");
    return 0.0;
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {    
    switch (self.type) {
        case ADTransitionTypePop:
            [self.delegate popTransitionDidFinish:self];
            break;
        case ADTransitionTypePush:
            [self.delegate pushTransitionDidFinish:self];
            break;
        default:
            NSAssert(FALSE, @"Unexpected case in switch statement !");
            break;
    }
}

@end
