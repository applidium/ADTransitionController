//
//  ALSettingsViewController.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 30/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALSettingsViewController.h"
#import "ALSettingsTableViewCell.h"

@interface ALSettingsViewController () {
    CGFloat _speed;
    ADTransitionOrientation _orientation;
    BOOL _navigationBarHidden;
    BOOL _toolbarHidden;
}
@end

@implementation ALSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        _speed = [[defaults objectForKey:AL_SPEED_KEY] floatValue];
        _orientation = [[defaults objectForKey:AL_ORIENTATION_KEY] intValue];
        _navigationBarHidden = [[defaults objectForKey:AL_NAVIGATION_BAR_HIDDEN_KEY] boolValue];
        _toolbarHidden = [[defaults objectForKey:AL_TOOLBAR_HIDDEN_KEY] boolValue];
        self.title = @"Settings";
    }
    return self;
}

- (void)dealloc {
    [_tableView release];
    [_speedLabel release];
    [_slider release];
    [_navigationBarSwitch release];
    [_scrollView release];
    [_creditView release];
    [_toolbarSwitch release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSpeedLabel:nil];
    [self setSlider:nil];
    [self setNavigationBarSwitch:nil];
    [self setScrollView:nil];
    [self setCreditView:nil];
    [self setToolbarSwitch:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.value = _speed;
    self.speedLabel.text = [NSString stringWithFormat:@"%.2fs", self.slider.value];
    self.navigationBarSwitch.on = !_navigationBarHidden;
    self.toolbarSwitch.on = !_toolbarHidden;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.creditView.frame) + 20.0f);
    
    UIBarButtonItem * doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [doneButtonItem release];
}

- (IBAction)toggleNavigationBar:(UISwitch *)sender {
    _navigationBarHidden = !sender.on;
}

- (IBAction)toggleToolbar:(UISwitch *)sender {
    _toolbarHidden = !sender.on;
}

- (IBAction)updateSpeed:(UISlider *)sender {
    _speed = sender.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%.2fs", _speed];
}

- (IBAction)done:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(_speed) forKey:AL_SPEED_KEY];
    [defaults setValue:@(_orientation) forKey:AL_ORIENTATION_KEY];
    [defaults setValue:@(_navigationBarHidden) forKey:AL_NAVIGATION_BAR_HIDDEN_KEY];
    [defaults setValue:@(_toolbarHidden) forKey:AL_TOOLBAR_HIDDEN_KEY];
    [defaults synchronize];
    [self.delegate settingsViewControllerDidUpdateSettings:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALSettingsTableViewCell * cell = [[ALSettingsTableViewCell newCell] autorelease];
    
    NSString * text = nil;
    switch (indexPath.row) {
        case ADTransitionRightToLeft:
            text = @"ADTransitionRightToLeft";
            break;
        case ADTransitionLeftToRight:
            text = @"ADTransitionLeftToRight";
            break;
        case ADTransitionTopToBottom:
            text = @"ADTransitionTopToBottom";
            break;
        case ADTransitionBottomToTop:
            text = @"ADTransitionBottomToTop";
            break;
    }
    cell.orientationLabel.text = text;
    cell.checkImageView.hidden = _orientation != indexPath.row;
    if (_orientation == indexPath.row) {
        cell.checkImageView.hidden = NO;
        cell.orientationLabel.textColor = [UIColor colorWithRed:0.000 green:0.498 blue:0.918 alpha:1.0f];
    } else {
        cell.checkImageView.hidden = YES;
        cell.orientationLabel.textColor = [UIColor colorWithRed:0.133 green:0.118 blue:0.149 alpha:1.0f];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _orientation = indexPath.row;
    [self.tableView reloadData];
}

@end
