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
    _tableView.backgroundColor = [UIColor clearColor];
    self.transitionController.navigationBar.translucent = YES;
    self.transitionController.toolbar.hidden = NO;
    self.transitionController.toolbar.translucent = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.extendedLayoutIncludesOpaqueBars= YES;
    }
    NSArray* toolbarItems = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                           target:self
                                                                           action:nil],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                           target:self
                                                                           action:nil],
                             nil];
    [toolbarItems makeObjectsPerformSelector:@selector(release)];
    self.toolbarItems = toolbarItems;
    self.transitionController.toolbarHidden = NO;
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
    label.textAlignment = UITextAlignmentCenter;
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
    cell.textLabel.textAlignment = UITextAlignmentCenter;
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
    [self.transitionController popViewController];
}

- (IBAction)fade:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADFadeTransition alloc] initWithDuration:_duration];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}

- (IBAction)backFade:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADBackFadeTransition alloc] initWithDuration:_duration];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)ghost:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADGhostTransition alloc] initWithDuration:_duration];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)cube:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADCubeTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)carrousel:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADCarrouselTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)cross:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADCrossTransition alloc] initWithDuration:_duration];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)swipe:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADSwipeTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)swipeFade:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADSwipeFadeTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)scale:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADScaleTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)glue:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADGlueTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)pushRotate:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADPushRotateTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)slide:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADSlideTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)fold:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADFoldTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)swap:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADSwapTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)flip:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADDualTransition * animation = [[ADFlipTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}

- (IBAction)focus:(id)sender {
    CGRect sourceRect = [sender frame];
    sourceRect.origin.y = sourceRect.origin.y - self.tableView.contentOffset.y;
    ADTransition * transition = [[ADZoomTransition alloc] initWithSourceRect:sourceRect andTargetRect:self.view.frame forDuration:_duration];
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    [self.transitionController pushViewController:viewController withTransition:transition];
    [transition release];
    [viewController release];
}

- (IBAction)push:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADModernPushTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}

- (IBAction)showSettings:(id)sender {
    ALSettingsViewController * settingsViewController = [[ALSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        [self presentModalViewController:navigationController animated:YES];
    }
    [settingsViewController release];
    [navigationController release];
}

- (IBAction)back:(id)sender {
    [self.transitionController popViewController];
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
    [self.transitionController setNavigationBarHidden:navigationBarHidden];
    [self.transitionController navigationBar].translucent = YES;
    self.backButton.hidden = !navigationBarHidden || self.index == 0;
    self.settingsButton.hidden = !navigationBarHidden;
}

- (void)_defaultsSettings {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(0.5f) forKey:AL_SPEED_KEY];
    [defaults setValue:@NO forKey:AL_NAVIGATION_BAR_HIDDEN_KEY];
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
}

@end