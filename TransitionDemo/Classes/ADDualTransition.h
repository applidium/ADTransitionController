//
//  ADDualTransition.h
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTransition.h"

typedef enum {
    ADDualTransitionTemplateFade,
    ADDualTransitionTemplateScaleFade,
    ADDualTransitionTemplateFlip,
    ADDualTransitionTemplateBackFade,
    ADDualTransitionTemplateSwipe,
    ADDualTransitionTemplateSwap,
    ADDualTransitionTemplateCarrouselRightToLeft
} ADDualTransitionTemplate;

@interface ADDualTransition : ADTransition {
    CAAnimation * _inAnimation;
    CAAnimation * _outAnimation;
}

@property (nonatomic, readonly) CAAnimation * inAnimation;
@property (nonatomic, readonly) CAAnimation * outAnimation;

- (id)initWithDuration:(CFTimeInterval)duration; // ADTransitionTypePush is assumed
- (id)initWithType:(ADTransitionType)type;
- (id)initWithInAnimation:(CAAnimation *)inAnimation andOutAnimation:(CAAnimation *)outAnimation forType:(ADTransitionType)type;
- (void)finishInit;

@end
