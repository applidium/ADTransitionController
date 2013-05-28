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

- (id)initWithInAnimation:(CAAnimation *)inAnimation andOutAnimation:(CAAnimation *)outAnimation forType:(ADTransitionType)type {
    self = [self init];
    if (self != nil) {
        _inAnimation = inAnimation;
        [_inAnimation retain];
        _outAnimation = outAnimation;
        [_outAnimation retain];
        _type = type;
        [self finishInit];
    }
    return self;
}

- (id)initWithDuration:(CFTimeInterval)duration {
    return nil;
}

- (id)initWithType:(ADTransitionType)type {
    self = [super init];
    if (self != nil) {
        _type = type;
    }
    return self;
}

- (void)dealloc {
    [_inAnimation release];
    [_outAnimation release];
    [super dealloc];
}

- (void)finishInit {
    _delegate = nil;
    _inAnimation.delegate = self; // The delegate object is retained by the receiver. This is a rare exception to the memory management rules described in 'Memory Management Programming Guide'.
    [_inAnimation setValue:ADTransitionAnimationInValue forKey:ADTransitionAnimationKey]; // See 'Core Animation Extensions To Key-Value Coding' : "while the key “someKey” is not a declared property of the CALayer class, however you can still set a value for the key “someKey” "
    _outAnimation.delegate = self;
    [_outAnimation setValue:ADTransitionAnimationOutValue forKey:ADTransitionAnimationKey];
}

- (ADTransition *)reverseTransition {
    if (self.type == ADTransitionTypeNull) {
        return self;
    }
    CAAnimation * inAnimationCopy = [self.inAnimation copy];
    CAAnimation * outAnimationCopy = [self.outAnimation copy];
    ADTransitionType reversedType;
    switch (self.type) {
        case ADTransitionTypePop:
            reversedType = ADTransitionTypePush;
            break;
        case ADTransitionTypePush:
            reversedType = ADTransitionTypePop;
            break;
        default:
            NSAssert(FALSE, @"Unhandled case in switch statement !");
            reversedType = ADTransitionTypeNull;
            break;
    }
    ADDualTransition * reversedTransition = [[ADDualTransition alloc] initWithInAnimation:outAnimationCopy // Swapped
                                                                          andOutAnimation:inAnimationCopy
                                                                                  forType:reversedType];
    reversedTransition.delegate = self.delegate; // Pointer assignment
    reversedTransition.inAnimation.speed = -1.0 * reversedTransition.inAnimation.speed;
    reversedTransition.outAnimation.speed = -1.0 * reversedTransition.outAnimation.speed;
    [outAnimationCopy release];
    [inAnimationCopy release];
    return [reversedTransition autorelease];
}

#pragma mark -
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if ([[animation valueForKey:ADTransitionAnimationKey] isEqualToString:ADTransitionAnimationOutValue]) {
        _outAnimation.delegate = nil;
    }
    if ([[animation valueForKey:ADTransitionAnimationKey] isEqualToString:ADTransitionAnimationInValue]) {
        _inAnimation.delegate = nil;
        [super animationDidStop:animation finished:flag];
    }
}
@end
