//
//  ADSwapTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADSwapTransition.h"
#import "ADDualTransition.h"

@implementation ADSwapTransition

- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect {
    CGFloat viewWidth = sourceRect.size.width;
    CGFloat viewHeight = sourceRect.size.height;
    
    CABasicAnimation * inZPosition = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    inZPosition.fromValue = @-2000.0f;
    inZPosition.toValue = @0.0f;
    
    CATransform3D rightTransform = CATransform3DMakeTranslation(viewWidth * 0.6f, 0.0f, 0.0f);
    rightTransform = CATransform3DRotate(rightTransform,- M_PI / 5.0f, 0.0f, 1.0f, 0.0f);
    CATransform3D leftTransform = CATransform3DMakeTranslation(-viewWidth * 0.6, 0.0f, 0.0f);
    leftTransform = CATransform3DRotate(leftTransform, M_PI / 5.0f, 0.0f, 1.0f, 0.0f);
    CATransform3D topTransform = CATransform3DMakeTranslation(0.0f, -viewHeight * 0.6f, 0.0f);
    topTransform = CATransform3DRotate(topTransform,- M_PI / 5.0f, 1.0f, 0.0f, 0.0f);
    CATransform3D bottomTransform = CATransform3DMakeTranslation(0.0f, viewHeight * 0.6f, 0.0f);
    bottomTransform = CATransform3DRotate(bottomTransform, M_PI / 5.0f, 1.0f, 0.0f, 0.0f);
    
    CAKeyframeAnimation * inPosition = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CAKeyframeAnimation * outPosition = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    switch (orientation) {
        case ADTransitionRightToLeft:
        {
            inPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:rightTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            outPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:leftTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        }
            break;
        case ADTransitionLeftToRight:
        {
            inPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:leftTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            outPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:rightTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        }
            break;
        case ADTransitionBottomToTop:
        {
            inPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:bottomTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            outPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:topTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        }
            break;
        case ADTransitionTopToBottom:
        {
            inPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:topTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            outPosition.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:bottomTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        }
            break;
        default:
            NSAssert(FALSE, @"Unhandlded ADSwapTransitionOrientation!");
            break;
    }
    
    CABasicAnimation * outZPosition = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    outZPosition.fromValue = @0.0f;
    outZPosition.toValue = @-2000.0f;
    
    inPosition.timingFunctions = [self getCircleApproximationTimingFunctions];
    outPosition.timingFunctions = [self getCircleApproximationTimingFunctions];
    
    CAMediaTimingFunction * LinearFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    inPosition.timingFunction = LinearFunction;
    outPosition.timingFunction = LinearFunction;
    
    CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
    [inAnimation setAnimations:@[inZPosition, inPosition]];
    inAnimation.duration = duration;
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    [outAnimation setAnimations:@[outZPosition, outPosition]];
    outAnimation.duration = duration;
    
    self = [super initWithInAnimation:inAnimation andOutAnimation:outAnimation];
    return self;
}

@end
