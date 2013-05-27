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
    self = [super initWithType:ADTransitionTypePush];
    if (self != nil) {
        CGFloat viewWidth = sourceRect.size.width;
        CGFloat viewHeight = sourceRect.size.height;
        
        CABasicAnimation * inZPosition = [CABasicAnimation animationWithKeyPath:@"zPosition"];
        inZPosition.fromValue = [NSNumber numberWithFloat: -2000.0f];
        inZPosition.toValue = [NSNumber numberWithFloat:0.0f];
        
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
                inPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:rightTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
                outPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:leftTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
            }
                break;
            case ADTransitionLeftToRight:
            {
                inPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:leftTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
                outPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:rightTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
            }
                break;
            case ADTransitionBottomToTop:
            {
                inPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:bottomTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
                outPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:topTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
            }
                break;
            case ADTransitionTopToBottom:
            {
                inPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:topTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
                outPosition.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:bottomTransform], [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];
            }
                break;
            default:
                NSAssert(FALSE, @"Unhandlded ADSwapTransitionOrientation!");
                break;
        }
        
        CABasicAnimation * outZPosition = [CABasicAnimation animationWithKeyPath:@"zPosition"];
        outZPosition.fromValue = [NSNumber numberWithFloat: 0.0f];
        outZPosition.toValue = [NSNumber numberWithFloat:-2000.0f];
     
        inPosition.timingFunctions = [self getCircleApproximationTimingFunctions];
        outPosition.timingFunctions = [self getCircleApproximationTimingFunctions];
        
        CAMediaTimingFunction * LinearFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        inPosition.timingFunction = LinearFunction;
        outPosition.timingFunction = LinearFunction;
        
        CAAnimationGroup * inSwapGroup = [CAAnimationGroup animation];
        [inSwapGroup setAnimations:[NSArray arrayWithObjects:inZPosition, inPosition, nil]];
        CAAnimationGroup * outSwapGroup = [CAAnimationGroup animation];
        [outSwapGroup setAnimations:[NSArray arrayWithObjects:outZPosition, outPosition, nil]];
        
        _inAnimation = inSwapGroup;
        _outAnimation = outSwapGroup;
        _inAnimation.duration = duration;
        _outAnimation.duration = duration;
        [_inAnimation retain];
        [_outAnimation retain];
        [self finishInit];
    }
    return self;
}
@end
