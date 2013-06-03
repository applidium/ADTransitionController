//
//  ALTableViewCell.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 03/06/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALTableViewCell.h"

@implementation ALTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
