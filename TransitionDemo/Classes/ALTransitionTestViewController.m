//
//  ALTransitionTestViewController.m
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ALTransitionTestViewController.h"

@interface ALTransitionTestViewController (Private)
- (void)_retrieveSettings;
- (void)_defaultsSettings;
- (void)_setupBarButtonItems;
- (void)_share:(id)sender;
- (void)_pushViewControllerWithTransition:(ADTransition *)transition;
@end

@interface ALTransitionTestViewController () {
    UIColor * _cellColor;
}
@end

@implementation ALTransitionTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil index:(NSInteger)index {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.index = index;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:AL_SPEED_KEY]) {
        [self _defaultsSettings];
    }
    [self _retrieveSettings];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Index: %d", self.index];
    
    UIColor * color = nil;
    switch (_index % 4) {
        case 0: // Green
            color = [UIColor colorWithRed:0.196 green:0.651 blue:0.573 alpha:1.000];
            break;
        case 1: // Orange
            color = [UIColor colorWithRed:1.000 green:0.569 blue:0.349 alpha:1.000];
            break;
        case 2: // Red
            color = [UIColor colorWithRed:0.949 green:0.427 blue:0.427 alpha:1.000];
            break;
        case 3: // Blue
            color = [UIColor colorWithRed:0.322 green:0.639 blue:0.800 alpha:1.000];
            break;
        default:
            break;
    }
    [_cellColor release];
    _cellColor = [color retain];
    
    [self _setupBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self _retrieveSettings];
}

- (void)viewDidUnload {
    [self setSettingsButton:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [_cellColor release];
    [_tableView release];
    [_settingsButton release];
    [_backButton release];
    [super dealloc];   
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: //ADDualTransition
            return 14;
        case 1: //ADTransformTransition
            return 3;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = _cellColor;
    cell.backgroundView.alpha = (indexPath.row % 2 == 0) ? 0.5 : 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 23.0f)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ALTableViewHeaderBackground"]];
    imageView.frame = headerView.frame;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:imageView];
    [imageView release];
    
    UILabel * label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.925 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:label];
    [label release];
    switch (section) {
        case 0:
            label.text = @"ADDualTransition";
            break;
        case 1:
            label.text = @"ADTransformTransition";
            break;
    }
    
    return [headerView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * sCellIdentifier = @"CellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier] autorelease];
    }
    
    UIView * backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.backgroundView = backgroundView;
    [backgroundView release];
    
    NSString * text = nil;
    switch (indexPath.section) {
        case 0: //ADDualTransition
            switch (indexPath.row) {
                case 0:
                    text = @"Slide";
                    break;
                case 1:
                    text = @"PushRotate";
                    break;
                case 2:
                    text = @"Fold";
                    break;
                case 3:
                    text = @"BackFade";
                    break;
                case 4:
                    text = @"Fade";
                    break;
                case 5:
                    text = @"Swap";
                    break;
                case 6:
                    text = @"Flip";
                    break;
                case 7:
                    text = @"SwipeFade";
                    break;
                case 8:
                    text = @"Scale";
                    break;
                case 9:
                    text = @"Glue";
                    break;
                case 10:
                    text = @"Zoom";
                    break;
                case 11:
                    text = @"Ghost";
                    break;
                case 12:
                    text = @"Swipe";
                    break;
                case 13:
                    text = @"Push";
                    break;
            }
            break;
        case 1: //ADTransformTransition
            switch (indexPath.row) {
                case 0:
                    text = @"Cross";
                    break;
                case 1:
                    text = @"Cube";
                    break;
                case 2:
                    text = @"Carrousel";
                    break;
            }
            break;
    }
    cell.textLabel.text = text;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithWhite:0.925f alpha:1.0f];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: //ADDualTransition
            switch (indexPath.row) {
                case 0: // Slide
                    [self slide:nil];
                    break;
                case 1: // PushRotate
                    [self pushRotate:nil];
                    break;
                case 2: // Fold
                    [self fold:nil];
                    break;
                case 3: // BackFade
                    [self backFade:nil];
                    break;
                case 4: // Fade
                    [self fade:nil];
                    break;
                case 5: // Swap
                    [self swap:nil];
                    break;
                case 6: // Flip
                    [self flip:nil];
                    break;
                case 7: // SwapFade
                    [self swipeFade:nil];
                    break;
                case 8: // Scale
                    [self scale:nil];
                    break;
                case 9: // Glue
                    [self glue:nil];
                    break;
                case 10: // Zoom
                    [self focus:[tableView cellForRowAtIndexPath:indexPath]];
                    break;
                case 11: // Ghost
                    [self ghost:nil];
                    break;
                case 12: // Swipe
                    [self swipe:nil];
                    break;
                case 13: // Push
                    [self push:nil];
                    break;
            }
            break;
        case 1: //ADTransformTransition
            switch (indexPath.row) {
                case 0: // Cross
                    [self cross:nil];
                    break;
                case 1: // Cube
                    [self cube:nil];
                    break;
                case 2: // Carrousel
                    [self carrousel:nil];
                    break;
            }
            break;
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)pop:(id)sender {
    if (AD_SYSTEM_VERSION_GREATER_THAN_7) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.transitionController popViewController];
    }
}

- (IBAction)slide:(id)sender {
    ADTransition * animation = [[ADSlideTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)fade:(id)sender {
    ADTransition * animation = [[ADFadeTransition alloc] initWithDuration:_duration];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)backFade:(id)sender {
    ADTransition * animation = [[ADBackFadeTransition alloc] initWithDuration:_duration];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)ghost:(id)sender {
    ADTransition * animation = [[ADGhostTransition alloc] initWithDuration:_duration];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)cube:(id)sender {
    ADTransition * animation = [[ADCubeTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)carrousel:(id)sender {
    ADTransition * animation = [[ADCarrouselTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)cross:(id)sender {
    ADTransition * animation = [[ADCrossTransition alloc] initWithDuration:_duration];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)swipe:(id)sender {
    ADTransition * animation = [[ADSwipeTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)swipeFade:(id)sender {
    ADTransition * animation = [[ADSwipeFadeTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)scale:(id)sender {
    ADTransition * animation = [[ADScaleTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)glue:(id)sender {
    ADTransition * animation = [[ADGlueTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)pushRotate:(id)sender {
    ADTransition * animation = [[ADPushRotateTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)fold:(id)sender {
    ADTransition * animation = [[ADFoldTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)swap:(id)sender {
    ADTransition * animation = [[ADSwapTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)flip:(id)sender {
    ADDualTransition * animation = [[ADFlipTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)focus:(id)sender {
    CGRect sourceRect = [sender frame];
    sourceRect.origin.y = sourceRect.origin.y - self.tableView.contentOffset.y;
    ADTransition * animation = [[ADZoomTransition alloc] initWithSourceRect:sourceRect andTargetRect:self.view.frame forDuration:_duration];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}
- (IBAction)push:(id)sender {
    ADTransition * animation = [[ADModernPushTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self _pushViewControllerWithTransition:animation];
    [animation release];
}

- (IBAction)showSettings:(id)sender {
    ALSettingsViewController * settingsViewController = [[ALSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [settingsViewController release];
    [navigationController release];
}

- (IBAction)back:(id)sender {
    if (AD_SYSTEM_VERSION_GREATER_THAN_7) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.transitionController popViewController];
    }
}

#pragma mark -
#pragma mark ALSettingsDelegate methods

- (void)settingsViewControllerDidUpdateSettings:(ALSettingsViewController *)settingsViewController {
    [self _retrieveSettings];
}

@end

@implementation ALTransitionTestViewController (Private)

- (void)_retrieveSettings {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _duration = [[defaults objectForKey:AL_SPEED_KEY] floatValue];
    _orientation = [[defaults objectForKey:AL_ORIENTATION_KEY] intValue];
    BOOL navigationBarHidden = [[defaults objectForKey:AL_NAVIGATION_BAR_HIDDEN_KEY] boolValue];
    BOOL toolbarHidden = [[defaults objectForKey:AL_TOOLBAR_HIDDEN_KEY] boolValue];
    if (AD_SYSTEM_VERSION_GREATER_THAN_7) {
        [self.navigationController setNavigationBarHidden:navigationBarHidden];
        [self.navigationController setToolbarHidden:toolbarHidden];
    } else {
        [self.transitionController setNavigationBarHidden:navigationBarHidden];
        [self.transitionController setToolbarHidden:toolbarHidden];
    }
    self.backButton.hidden = !navigationBarHidden || self.index == 0;
    self.settingsButton.hidden = !navigationBarHidden;
}

- (void)_defaultsSettings {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(0.5f) forKey:AL_SPEED_KEY];
    [defaults setValue:@NO forKey:AL_NAVIGATION_BAR_HIDDEN_KEY];
    [defaults setValue:@YES forKey:AL_TOOLBAR_HIDDEN_KEY];
    [defaults setValue:@(ADTransitionRightToLeft) forKey:AL_ORIENTATION_KEY];
    [defaults synchronize];
}

- (void)_setupBarButtonItems {
    if (self.index > 0) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 34.0f, 34.0f);
        [backButton setImage:[UIImage imageNamed:@"ALBackButtonOff"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"ALBackButtonOn"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = backButtonItem;
        [backButtonItem release];
    }
    
    UIButton * settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, 34.0f, 34.0f);
    [settingsButton setImage:[UIImage imageNamed:@"ALSettingsButtonOff"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"ALSettingsButtonOn"] forState:UIControlStateHighlighted];
    [settingsButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsButtonItem;
    [settingsButtonItem release];

    UIBarButtonItem * shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_share:)];
    self.toolbarItems = @[shareButtonItem];
    [shareButtonItem release];
}

- (void)_share:(id)sender {
    NSString * text = @"I use ADTransitionController by @applidium http://applidium.github.io/";
    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)_pushViewControllerWithTransition:(ADTransition *)transition {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    if (AD_SYSTEM_VERSION_GREATER_THAN_7) {
        viewController.transition = transition;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self.transitionController pushViewController:viewController withTransition:transition];
    }
    [viewController release];
}
@end