//
//  ALTransitionTestViewController.h
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALSettingsViewController.h"
#import "ADTransitionController.h"

#define AD_SYSTEM_VERSION_GREATER_THAN_7 ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] == NSOrderedDescending)

@interface ALTransitionTestViewController : ADTransitioningViewController <UITableViewDataSource, UITableViewDelegate, ALSettingsDelegate> {
    NSInteger _index;
    CGFloat _duration;
    ADTransitionOrientation _orientation;
}

@property (retain, nonatomic) IBOutlet UIButton * settingsButton;
@property (retain, nonatomic) IBOutlet UIButton * backButton;
@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (nonatomic) NSInteger index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil index:(NSInteger)index;
- (IBAction)fade:(id)sender;
- (IBAction)backFade:(id)sender;
- (IBAction)ghost:(id)sender;
- (IBAction)cube:(id)sender;
- (IBAction)carrousel:(id)sender;
- (IBAction)cross:(id)sender;
- (IBAction)swipe:(id)sender;
- (IBAction)swipeFade:(id)sender;
- (IBAction)scale:(id)sender;
- (IBAction)glue:(id)sender;
- (IBAction)pushRotate:(id)sender;
- (IBAction)fold:(id)sender;
- (IBAction)slide:(id)sender;
- (IBAction)swap:(id)sender;
- (IBAction)flip:(id)sender;
- (IBAction)focus:(id)sender;
- (IBAction)push:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)back:(id)sender;
@end