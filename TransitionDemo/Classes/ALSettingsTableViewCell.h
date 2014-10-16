//
//  ADSettingsTableViewCell.h
//  ADTransitionController
//
//  Created by Pierre Felgines on 03/06/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALSettingsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * orientationLabel;
@property (strong, nonatomic) IBOutlet UIImageView * checkImageView;

+ (id)newCell;

@end
