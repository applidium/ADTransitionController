//
//  ADFlipTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADFlipTransition.h"
#import "ADDualTransition.h"

@implementation ADFlipTransition
- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect {
    self = [super initWithType:ADTransitionTypePush];
    if (self != nil) {
        CGFloat viewWidth = sourceRect.size.width;
        CGFloat viewHeight = sourceRect.size.height;
        
        CAKeyframeAnimation * zTranslationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"zPosition"];
        
        CATransform3D inPivotTransform = CATransform3DIdentity;
        CATransform3D outPivotTransform = CATransform3DIdentity;

        switch (orientation) {
            case ADTransitionRightToLeft:
            {
                zTranslationAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:-viewWidth * 0.5f], [NSNumber numberWithFloat:0.0f], nil];
                inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI - 0.001, 0.0f, 1.0f, 0.0f);
                outPivotTransform = CATransform3DRotate(outPivotTransform, -M_PI + 0.001, 0.0f, 1.0f, 0.0f);
            }
                break;
            case ADTransitionLeftToRight:
            {
                zTranslationAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:-viewWidth * 0.5f], [NSNumber numberWithFloat:0.0f], nil];
                inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI + 0.001, 0.0f, 1.0f, 0.0f);
                outPivotTransform = CATransform3DRotate(outPivotTransform, - M_PI - 0.001, 0.0f, 1.0f, 0.0f);
            }
                break;
            case ADTransitionBottomToTop:
            {
                zTranslationAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:-viewHeight * 0.5f], [NSNumber numberWithFloat:0.0f], nil];
                inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI + 0.001, 1.0f, .0f, 0.0f);
                outPivotTransform = CATransform3DRotate(outPivotTransform, - M_PI - 0.001, 1.0f, 0.0f, 0.0f);
            }
                break;
            case ADTransitionTopToBottom:
            {
                zTranslationAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:-viewHeight * 0.5f], [NSNumber numberWithFloat:0.0f], nil];
                inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI - 0.001, 1.0f, .0f, 0.0f);
                outPivotTransform = CATransform3DRotate(outPivotTransform, - M_PI + 0.001, 1.0f, 0.0f, 0.0f);
            }
                break;
            default:
                NSAssert(FALSE, @"Unhandled ADFlipTransitionOrientation!");
                break;
        }
     

        zTranslationAnimation.timingFunctions = [self getCircleApproximationTimingFunctions];

        CAKeyframeAnimation * inFlipAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        inFlipAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:inPivotTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
        inFlipAnimation.timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
        
        CAKeyframeAnimation * outFlipAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        outFlipAnimation.values = [NSArray arrayWithObjects: [NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:outPivotTransform], nil];
        outFlipAnimation.timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
        
        CAAnimationGroup * inFlipGroup = [CAAnimationGroup animation];
        [inFlipGroup setAnimations:[NSArray arrayWithObjects:inFlipAnimation, zTranslationAnimation, nil]];
        CAAnimationGroup * outFlipGroup = [CAAnimationGroup animation];
        [outFlipGroup setAnimations:[NSArray arrayWithObjects:outFlipAnimation, zTranslationAnimation, nil]];
        
        for (CABasicAnimation * animation in inFlipGroup.animations) {
            animation.duration = duration;
        }
        for (CABasicAnimation * animation in outFlipGroup.animations) {
            animation.duration = duration;
        }
        _inAnimation = inFlipGroup;
        _outAnimation = outFlipGroup;
        _inAnimation.duration = duration;
        _outAnimation.duration = duration;
        [_inAnimation retain];
        [_outAnimation retain];
        [super finishInit];
    }
    return self;
}
@end
