
//
//  ADBackFadeTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADBackFadeTransition.h"
#import "ADDualTransition.h"

@implementation ADBackFadeTransition

- (id)initWithDuration:(CFTimeInterval)duration {
    CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inFadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    inFadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outFadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    outFadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAKeyframeAnimation * backFadeTranslation = [CAKeyframeAnimation animationWithKeyPath:@"zPosition"];
    backFadeTranslation.values = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:-2000.0f], [NSNumber numberWithFloat:0.0f]];
    
    CAMediaTimingFunction * SShapedFunction = [CAMediaTimingFunction functionWithControlPoints:0.8f :0.0f :0.0f :0.2f];
    inFadeAnimation.timingFunction = SShapedFunction;
    outFadeAnimation.timingFunction = SShapedFunction;
    
    CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
    [inAnimation setAnimations:@[backFadeTranslation, inFadeAnimation]];
    inAnimation.duration = duration;
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    [outAnimation setAnimations:@[backFadeTranslation, outFadeAnimation]];
    outAnimation.duration = duration;
    
    self = [super initWithInAnimation:inAnimation andOutAnimation:outAnimation];
    return self;
}

@end
