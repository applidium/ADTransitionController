//
//  ADCarrouselTransition.h
//  AppLibrary
//
//  Created by Patrick Nollet on 14/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTransformTransition.h"

@interface ADCarrouselTransition : ADTransformTransition {
    
}
- (id)initWithDuration:(CFTimeInterval)duration forType:(ADTransitionType)type orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect;
@end
