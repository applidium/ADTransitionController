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
    CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inFadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    inFadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    inFadeAnimation.duration = duration;
    
    CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outFadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    outFadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    outFadeAnimation.duration = duration;
    
    self = [super initWithInAnimation:inFadeAnimation andOutAnimation:outFadeAnimation];
    return self;
}

@end
