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
#define AL_TOOLBAR_HIDDEN_KEY @"toolbarHidden"

@protocol ALSettingsDelegate;

@interface ALSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView * scrollView;
@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) IBOutlet UILabel * speedLabel;
@property (strong, nonatomic) IBOutlet UISlider * slider;
@property (strong, nonatomic) IBOutlet UISwitch * navigationBarSwitch;
@property (strong, nonatomic) IBOutlet UISwitch * toolbarSwitch;
@property (strong, nonatomic) IBOutlet UIImageView * creditView;
@property (nonatomic, weak) id<ALSettingsDelegate> delegate;

- (IBAction)toggleNavigationBar:(id)sender;
- (IBAction)toggleToolbar:(id)sender;
- (IBAction)updateSpeed:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol ALSettingsDelegate <NSObject>
@optional
- (void)settingsViewControllerDidUpdateSettings:(ALSettingsViewController *)settingsViewController;
@end
