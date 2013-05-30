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
    self = [super init];
    if (self != nil) {
        CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        inFadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        inFadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        outFadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        outFadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
        
        CABasicAnimation * scaleInAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleInAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0f, 2.0f, 2.0f)];
        scaleInAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        CAAnimationGroup * inScaleFadeGroup = [CAAnimationGroup animation];
        [inScaleFadeGroup setAnimations:[NSArray arrayWithObjects:inFadeAnimation, scaleInAnimation, nil]];
        
        CABasicAnimation * scaleOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleOutAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleOutAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)]; 
        CAAnimationGroup * outScaleFadeGroup = [CAAnimationGroup animation];
        [outScaleFadeGroup setAnimations:[NSArray arrayWithObjects:outFadeAnimation, scaleOutAnimation, nil]];
        
        for (CABasicAnimation * animation in inScaleFadeGroup.animations) {
            animation.duration = duration;
        }
        for (CABasicAnimation * animation in outScaleFadeGroup.animations) {
            animation.duration = duration;
        }
        
        _inAnimation = inScaleFadeGroup;
        _outAnimation = outScaleFadeGroup;
        _inAnimation.duration = duration;
        _outAnimation.duration = duration;
        [_inAnimation retain];
        [_outAnimation retain];
        [self finishInit];
    }
    return self;
}
@end
