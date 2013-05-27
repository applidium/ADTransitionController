//
//  ADFadeTransition.m
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADFadeTransition.h"


@implementation ADFadeTransition

- (id)initWithDuration:(CFTimeInterval)duration {
    self = [super initWithType:ADTransitionTypePush];
    if (self != nil) {
        CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        inFadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        inFadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        outFadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        outFadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
        _inAnimation = inFadeAnimation;
        _outAnimation = outFadeAnimation;  
        _inAnimation.duration = duration;
        _outAnimation.duration = duration;
        [_inAnimation retain];
        [_outAnimation retain];
        [self finishInit];
    }
    return self;
}

@end
