//
//  ADDualTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADDualTransition.h"

@implementation ADDualTransition
@synthesize inAnimation = _inAnimation;
@synthesize outAnimation = _outAnimation;

- (id)initWithInAnimation:(CAAnimation *)inAnimation andOutAnimation:(CAAnimation *)outAnimation {
    if (self = [self init]) {
        _inAnimation = inAnimation;
        _outAnimation = outAnimation;
        [self finishInit];
    }
    return self;
}

- (id)initWithDuration:(CFTimeInterval)duration {
    return nil;
}


- (void)finishInit {
    _delegate = nil;
    _inAnimation.delegate = self; // The delegate object is retained by the receiver. This is a rare exception to the memory management rules described in 'Memory Management Programming Guide'.
    [_inAnimation setValue:ADTransitionAnimationInValue forKey:ADTransitionAnimationKey]; // See 'Core Animation Extensions To Key-Value Coding' : "while the key “someKey” is not a declared property of the CALayer class, however you can still set a value for the key “someKey” "
    _outAnimation.delegate = self;
    [_outAnimation setValue:ADTransitionAnimationOutValue forKey:ADTransitionAnimationKey];
}

- (ADTransition *)reverseTransition {
    CAAnimation * inAnimationCopy = [self.inAnimation copy];
    CAAnimation * outAnimationCopy = [self.outAnimation copy];
    ADDualTransition * reversedTransition = [[ADDualTransition alloc] initWithInAnimation:outAnimationCopy // Swapped
                                                                          andOutAnimation:inAnimationCopy];
    reversedTransition.delegate = self.delegate; // Pointer assignment
    reversedTransition.inAnimation.speed = -1.0 * reversedTransition.inAnimation.speed;
    reversedTransition.outAnimation.speed = -1.0 * reversedTransition.outAnimation.speed;
    reversedTransition.type = ADTransitionTypeNull;
    if (self.type == ADTransitionTypePush) {
        reversedTransition.type = ADTransitionTypePop;
    } else if (self.type == ADTransitionTypePop) {
        reversedTransition.type = ADTransitionTypePush;
    }
    return reversedTransition;
}

- (NSTimeInterval)duration {
    return MAX(self.inAnimation.duration, self.outAnimation.duration);
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if ([[animation valueForKey:ADTransitionAnimationKey] isEqualToString:ADTransitionAnimationInValue]) {
        [super animationDidStop:animation finished:flag];
    }
}

@end
