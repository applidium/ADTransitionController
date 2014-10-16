//
//  ADCrossTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADCrossTransition.h"

@implementation ADCrossTransition

- (id)initWithDuration:(CFTimeInterval)duration {
    if (self = [super initWithDuration:duration]) {
        CAAnimation * animation = nil;
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        ((CABasicAnimation *)animation).fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 0.5f, 0.0f, 1.0f, 0.0f)];
        ((CABasicAnimation *)animation).toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        _outLayerTransform = CATransform3DRotate(_outLayerTransform, -M_PI * 0.5f, 0.0f, 1.0f, 0.0f);
        
        _animation = animation;
        _animation.duration = duration;
        _animation.delegate = self;
    }
    return self;
}

@end
