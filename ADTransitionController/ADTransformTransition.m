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

- (id)initWithAnimation:(CAAnimation *)animation inLayerTransform:(CATransform3D)inTransform outLayerTransform:(CATransform3D)outTransform {
    if (self = [super init]) {
        _animation = [animation copy]; // the instances should be different because we don't want them to have the same delegate
        _animation.delegate = self;
        _inLayerTransform = inTransform;
        _outLayerTransform = outTransform;
    }
    return self;
}

- (id)initWithDuration:(CFTimeInterval)duration {
    if (self = [super init]) {
        _inLayerTransform = CATransform3DIdentity;
        _outLayerTransform = CATransform3DIdentity;
    }
    return self;
}

- (id)initWithDuration:(CFTimeInterval)duration sourceRect:(CGRect)sourceRect {
    return [self initWithDuration:duration];
}

- (ADTransition *)reverseTransition {
    ADTransformTransition * reversedTransition = [[ADTransformTransition alloc] initWithAnimation:_animation inLayerTransform:_outLayerTransform outLayerTransform:_inLayerTransform];;
    reversedTransition.delegate = self.delegate; // Pointer assignment
    reversedTransition.animation.speed = - 1.0 * reversedTransition.animation.speed;
    reversedTransition.type = ADTransitionTypeNull;
    if (self.type == ADTransitionTypePush) {
        reversedTransition.type = ADTransitionTypePop;
    } else if (self.type == ADTransitionTypePop) {
        reversedTransition.type = ADTransitionTypePush;
    }
    return reversedTransition;
}

- (NSTimeInterval)duration {
    return self.animation.duration;
}

@end