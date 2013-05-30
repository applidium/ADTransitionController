//
//  ADSwipeTransition.h
//  AppLibrary
//
//  Created by Patrick Nollet on 15/03/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADDualTransition.h"

@interface ADSwipeTransition : ADDualTransition
- (id)initWithDuration:(CFTimeInterval)duration orientation:(ADTransitionOrientation)orientation sourceRect:(CGRect)sourceRect;
@end
