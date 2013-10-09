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
    CGFloat viewWidth = sourceRect.size.width;
    CGFloat viewHeight = sourceRect.size.height;
    
    CAKeyframeAnimation * zTranslationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"zPosition"];
    
    CATransform3D inPivotTransform = CATransform3DIdentity;
    CATransform3D outPivotTransform = CATransform3DIdentity;
    
    switch (orientation) {
        case ADTransitionRightToLeft:
        {
            zTranslationAnimation.values = @[@0.0f, @(-viewWidth * 0.5f), @0.0f];
            inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI - 0.001, 0.0f, 1.0f, 0.0f);
            outPivotTransform = CATransform3DRotate(outPivotTransform, -M_PI + 0.001, 0.0f, 1.0f, 0.0f);
        }
            break;
        case ADTransitionLeftToRight:
        {
            zTranslationAnimation.values = @[@0.0f, @(-viewWidth * 0.5f), @0.0f];
            inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI + 0.001, 0.0f, 1.0f, 0.0f);
            outPivotTransform = CATransform3DRotate(outPivotTransform, - M_PI - 0.001, 0.0f, 1.0f, 0.0f);
        }
            break;
        case ADTransitionBottomToTop:
        {
            zTranslationAnimation.values = @[@0.0f, @(-viewHeight * 0.5f), @0.0f];
            inPivotTransform = CATransform3DRotate(inPivotTransform, M_PI + 0.001, 1.0f, .0f, 0.0f);
            outPivotTransform = CATransform3DRotate(outPivotTransform, - M_PI - 0.001, 1.0f, 0.0f, 0.0f);
        }
            break;
        case ADTransitionTopToBottom:
        {
            zTranslationAnimation.values = @[@0.0f, @(-viewHeight * 0.5f), @0.0f];
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
    inFlipAnimation.values = @[[NSValue valueWithCATransform3D:inPivotTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    inFlipAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    CAKeyframeAnimation * outFlipAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    outFlipAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:outPivotTransform]];
    outFlipAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
    [inAnimation setAnimations:@[inFlipAnimation, zTranslationAnimation]];
    inAnimation.duration = duration;
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    [outAnimation setAnimations:@[outFlipAnimation, zTranslationAnimation]];
    outAnimation.duration = duration;
    
    self = [super initWithInAnimation:inAnimation andOutAnimation:outAnimation];
    return self;
}

@end
