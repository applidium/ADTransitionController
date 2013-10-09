//
//  ADModernPushTransition.h
//  AppLibrary
//
//  Created by Martin Guillon on 23/09/13.
//
//

#import "ADDualTransition.h"

@interface ADModernPushTransition : ADDualTransition
- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect;

@end
