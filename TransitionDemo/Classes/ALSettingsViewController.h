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

@property (retain, nonatomic) IBOutlet UIScrollView * scrollView;
@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UILabel * speedLabel;
@property (retain, nonatomic) IBOutlet UISlider * slider;
@property (retain, nonatomic) IBOutlet UISwitch * navigationBarSwitch;
@property (retain, nonatomic) IBOutlet UISwitch * toolbarSwitch;
@property (retain, nonatomic) IBOutlet UIImageView * creditView;
@property (nonatomic, assign) id<ALSettingsDelegate> delegate;

- (IBAction)toggleNavigationBar:(id)sender;
- (IBAction)toggleToolbar:(id)sender;
- (IBAction)updateSpeed:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol ALSettingsDelegate <NSObject>
@optional
- (void)settingsViewControllerDidUpdateSettings:(ALSettingsViewController *)settingsViewController;
@end
