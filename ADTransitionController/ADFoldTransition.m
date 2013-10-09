//
//  ADFoldTransition.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 29/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ADFoldTransition.h"

@implementation ADFoldTransition

- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect {
    const CGFloat viewWidth = sourceRect.size.width;
    const CGFloat viewHeight = sourceRect.size.height;
    const CGFloat inAngle = M_PI - 0.001f; // epsilon for modulo
    const CGFloat outAngle = M_PI / 2.0f;
    
    CGPoint inAnchorPoint;
    CGPoint outAnchorPoint;
    CATransform3D inStartTranslation;
    CATransform3D outStartTranslation;
    CATransform3D inRotation;
    CATransform3D outRotation;
    switch (orientation) {
        case ADTransitionRightToLeft:
        {
            inAnchorPoint = CGPointMake(1.0f, 0.5f);
            outAnchorPoint = CGPointMake(0, 0.5f);
            inStartTranslation = CATransform3DMakeTranslation(viewWidth * 0.5f, 0, 0);
            outStartTranslation = CATransform3DMakeTranslation(-viewWidth * 0.5f, 0, 0);
            inRotation = CATransform3DRotate(inStartTranslation, -inAngle, 0, 1.0f, 0);
            outRotation = CATransform3DRotate(outStartTranslation, outAngle, 0, 1.0f, 0);
        }
            break;
        case ADTransitionLeftToRight:
        {
            inAnchorPoint = CGPointMake(0, 0.5f);
            outAnchorPoint = CGPointMake(1.0f, 0.5f);
            inStartTranslation = CATransform3DMakeTranslation(-viewWidth * 0.5f, 0, 0);
            outStartTranslation = CATransform3DMakeTranslation(viewWidth * 0.5f, 0, 0);
            inRotation = CATransform3DRotate(inStartTranslation, inAngle, 0, 1.0f, 0);
            outRotation = CATransform3DRotate(outStartTranslation, -outAngle, 0, 1.0f, 0);
        }
            break;
        case ADTransitionTopToBottom:
        {
            inAnchorPoint = CGPointMake(0.5f, 0);
            outAnchorPoint = CGPointMake(0.5f, 1.0f);
            inStartTranslation = CATransform3DMakeTranslation(0, -viewHeight * 0.5f, 0);
            outStartTranslation = CATransform3DMakeTranslation(0, viewHeight * 0.5f, 0);
            inRotation = CATransform3DRotate(inStartTranslation, -inAngle, 1.0f, 0, 0);
            outRotation = CATransform3DRotate(outStartTranslation, outAngle, 1.0f, 0, 0);
        }
            break;
        case ADTransitionBottomToTop:
        {
            inAnchorPoint = CGPointMake(0.5f, 1.0f);
            outAnchorPoint = CGPointMake(0.5f, 0);
            inStartTranslation = CATransform3DMakeTranslation(0, viewHeight * 0.5f, 0);
            outStartTranslation = CATransform3DMakeTranslation(0, -viewHeight * 0.5f, 0);
            inRotation = CATransform3DRotate(inStartTranslation, inAngle, 1.0f, 0, 0);
            outRotation = CATransform3DRotate(outStartTranslation, -outAngle, 1.0f, 0, 0);
        }
            break;
        default:
            NSAssert(FALSE, @"Unhandled ADTransitionOrientation");
            break;
    }
    
    CABasicAnimation * inAnchorPointAnimation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    inAnchorPointAnimation.fromValue = [NSValue valueWithCGPoint:inAnchorPoint];
    inAnchorPointAnimation.toValue = [NSValue valueWithCGPoint:inAnchorPoint];
    
    CABasicAnimation * outAnchorPointAnimation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    outAnchorPointAnimation.fromValue = [NSValue valueWithCGPoint:outAnchorPoint];
    outAnchorPointAnimation.toValue = [NSValue valueWithCGPoint:outAnchorPoint];
    
    CABasicAnimation * inRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    inRotationAnimation.fromValue = [NSValue valueWithCATransform3D:inRotation];
    inRotationAnimation.toValue = [NSValue valueWithCATransform3D:inStartTranslation];
    
    CABasicAnimation * outRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    outRotationAnimation.fromValue = [NSValue valueWithCATransform3D:outStartTranslation];
    outRotationAnimation.toValue = [NSValue valueWithCATransform3D:outRotation];
    
    CABasicAnimation * inOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inOpacityAnimation.fromValue = @0.0f;
    inOpacityAnimation.toValue = @1.0f;
    
    CABasicAnimation * outOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outOpacityAnimation.fromValue = @1.0f;
    outOpacityAnimation.toValue = @0.0f;
    
    CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
    [inAnimation setAnimations:@[inOpacityAnimation, inRotationAnimation, inAnchorPointAnimation]];
    inAnimation.duration = duration;
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    [outAnimation setAnimations:@[outOpacityAnimation, outRotationAnimation, outAnchorPointAnimation]];
    outAnimation.duration = duration;
    
    self = [super initWithInAnimation:inAnimation andOutAnimation:outAnimation];
    return self;
}

@end
