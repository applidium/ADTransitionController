//
//  ADSettingsTableViewCell.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 03/06/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALSettingsTableViewCell.h"

@implementation ALSettingsTableViewCell

+ (id)newCell {
    NSArray * nibViews = [[NSBundle mainBundle] loadNibNamed:@"ALSettingsTableViewCell" owner:self options:nil];
    return [nibViews lastObject];
}


@end
