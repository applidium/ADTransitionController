//
//  ADGhostTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADGhostTransition.h"

@implementation ADGhostTransition

- (id)initWithDuration:(CFTimeInterval)duration {    
    CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inFadeAnimation.fromValue = @0.0f;
    inFadeAnimation.toValue = @1.0f;
    
    CABasicAnimation * inScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    inScaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0f, 2.0f, 2.0f)];
    inScaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
    [inAnimation setAnimations:@[inFadeAnimation, inScaleAnimation]];
    inAnimation.duration = duration;
    
    CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outFadeAnimation.fromValue = @1.0f;
    outFadeAnimation.toValue = @0.0f;
    
    CABasicAnimation * outScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    outScaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    outScaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)];
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    [outAnimation setAnimations:@[outFadeAnimation, outScaleAnimation]];
    outAnimation.duration = duration;
    
    self = [super initWithInAnimation:inAnimation andOutAnimation:outAnimation];
    return self;
}

@end
