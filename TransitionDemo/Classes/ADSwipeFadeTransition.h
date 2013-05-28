//
//  ADSwipeFade.h
//  ADTransitionController
//
//  Created by Pierre Felgines on 28/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ADDualTransition.h"

@interface ADSwipeFadeTransition : ADDualTransition
- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect;
@end
