//
//  ALSettingsViewController.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 30/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALSettingsViewController.h"

@interface ALSettingsViewController () {
    CGFloat _speed;
    ADTransitionOrientation _orientation;
    BOOL _navigationBarHidden;
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
    }
    return self;
}

- (void)dealloc {
    [_tableView release];
    [_speedLabel release];
    [_slider release];
    [_switchView release];
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSpeedLabel:nil];
    [self setSlider:nil];
    [self setSwitchView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.value = _speed;
    self.speedLabel.text = [NSString stringWithFormat:@"%.2fs", self.slider.value];
    self.switchView.on = !_navigationBarHidden;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.tableView.frame) - 64.0f);
}

- (IBAction)toggleNavigationBar:(UISwitch *)sender {
    _navigationBarHidden = !sender.on;
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
    [defaults synchronize];
    [self.delegate settingsViewControllerDidUpdateSettings:self];
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - 
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
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
    cell.textLabel.text = text;

    if (_orientation == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _orientation = indexPath.row;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end
