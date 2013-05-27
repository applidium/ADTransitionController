//
//  ADTransformTransition.m
//  Transition
//
//  Created by Patrick Nollet on 08/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADTransformTransition.h"

@interface ADTransformTransition (Private)
- (void)_initADTransformTransitionTemplateCrossWithDuration:(CFTimeInterval)duration;
@end

@implementation ADTransformTransition
@synthesize inLayerTransform = _inLayerTransform;
@synthesize outLayerTransform = _outLayerTransform;
@synthesize animation = _animation;

- (void)dealloc {
    [_animation release], _animation = nil;
    [super dealloc];
}
- (id)initWithAnimation:(CAAnimation *)animation inLayerTransform:(CATransform3D)inTransform outLayerTransform:(CATransform3D)outTransform forType:(ADTransitionType)type {
    self = [super init];
    if (self) {
        _animation = [animation copy]; // the instances should be different because we don't want them to have the same delegate
        _animation.delegate = self;
        _inLayerTransform = inTransform;
        _outLayerTransform = outTransform;
        _type = type;
    }
    return self;
}

- (id)initWithDuration:(CFTimeInterval)duration forType:(ADTransitionType)type {
    self = [super init];
    if (self != nil) {
        _inLayerTransform = CATransform3DIdentity;
        _outLayerTransform = CATransform3DIdentity;
        _type = type;
    }
    return self;
}

- (id)initWithDuration:(CFTimeInterval)duration forType:(ADTransitionType)type sourceRect:(CGRect)sourceRect {
    return  [self initWithDuration:duration forType:type];
}
- (ADTransition *)reverseTransition {
    if (self.type == ADTransitionTypeNull) {
        return self;
    }
    ADTransformTransition * reversedTransition = nil;
    switch (self.type) {
        case ADTransitionTypePop:
            reversedTransition = [[ADTransformTransition alloc] initWithAnimation:_animation inLayerTransform:_outLayerTransform outLayerTransform:_inLayerTransform forType:ADTransitionTypePush];
            break;
        case ADTransitionTypePush:
            reversedTransition = [[ADTransformTransition alloc] initWithAnimation:_animation inLayerTransform:_outLayerTransform outLayerTransform:_inLayerTransform forType:ADTransitionTypePop];
            break;
        default:
            NSAssert(FALSE, @"Unhandled case in switch statement !");
            break;
    }
    reversedTransition.delegate = self.delegate; // Pointer assignment
    reversedTransition.animation.speed = - 1.0 * reversedTransition.animation.speed;

    return [reversedTransition autorelease];
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