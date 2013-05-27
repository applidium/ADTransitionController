
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
    self = [super initWithType:ADTransitionTypePush];
    if (self != nil) {
        CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        inFadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        inFadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        outFadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        outFadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
        
        CAKeyframeAnimation * backFadeTranslation = [CAKeyframeAnimation animationWithKeyPath:@"zPosition"];
        backFadeTranslation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:-2000.0f], [NSNumber numberWithFloat:0.0f], nil];
        
        CAMediaTimingFunction * SShapedFunction = [CAMediaTimingFunction functionWithControlPoints:0.8f :0.0f :0.0f :0.2f];
        inFadeAnimation.timingFunction = SShapedFunction;
        outFadeAnimation.timingFunction = SShapedFunction;
        
        CAAnimationGroup * inBackFadeGroup = [CAAnimationGroup animation];
        [inBackFadeGroup setAnimations:[NSArray arrayWithObjects:backFadeTranslation, inFadeAnimation, nil]];
        CAAnimationGroup * outBackFadeGroup = [CAAnimationGroup animation];
        [outBackFadeGroup setAnimations:[NSArray arrayWithObjects:backFadeTranslation, outFadeAnimation, nil]];
        
        _inAnimation = inBackFadeGroup;
        _outAnimation = outBackFadeGroup;
        _inAnimation.duration = duration;
        _outAnimation.duration = duration;
        [_inAnimation retain];
        [_outAnimation retain];
        [self finishInit];
    }
    return self;
}
@end
