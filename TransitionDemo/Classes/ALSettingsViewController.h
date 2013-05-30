//
//  ALSettingsViewController.h
//  ADTransitionController
//
//  Created by Pierre Felgines on 30/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTransition.h"

#define AL_SPEED_KEY @"speed"
#define AL_ORIENTATION_KEY @"orientation"
#define AL_NAVIGATION_BAR_HIDDEN_KEY @"navigationBarHidden"

@protocol ALSettingsDelegate;

@interface ALSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UILabel * speedLabel;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UISwitch * switchView;
@property (nonatomic, assign) id<ALSettingsDelegate> delegate;

- (IBAction)toggleNavigationBar:(id)sender;
- (IBAction)updateSpeed:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol ALSettingsDelegate <NSObject>
@optional
- (void)settingsViewControllerDidUpdateSettings:(ALSettingsViewController *)settingsViewController;
@end
