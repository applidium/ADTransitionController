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
@end

@implementation ALTransitionTestViewController

@synthesize index = _index;

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
    int imageIndex = arc4random()%6;
    switch (imageIndex) {
        case 0:
            color = [UIColor colorWithRed:138.0f / 255.0f green:214.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
            break;
        case 1:
            color = [UIColor colorWithRed:240.0f / 255.0f green:193.0f / 255.0f blue:93.0f / 255.0f alpha:1.0f];
            break;
        case 2:
            color = [UIColor colorWithRed:227.0f / 255.0f green:107.0f / 255.0f blue:95.0f / 255.0f alpha:1.0f];
            break;
        case 3:
            color = [UIColor colorWithRed:102.0f / 255.0f green:192.0f / 255.0f blue:210.0f / 255.0f alpha:1.0f];
            break;
        case 4:
            color = [UIColor colorWithRed:138.0f / 255.0f green:181.0f / 255.0f blue:251.0f / 255.0f alpha:1.0f];
            break;
        case 5:
            color = [UIColor colorWithRed:255.0f / 255.0f green:140.0f / 255.0f blue:185.0f / 255.0f alpha:1.0f];
            break;
        default:
            break;
    }
    self.tableView.backgroundColor = color;
    [self _retrieveSettings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidUnload {
    [self setSettingsButton:nil];
    [super viewDidUnload];
    [_durationLabel release], _durationLabel = nil;
    [_indexLabel release], _indexLabel = nil;       
}

- (void)dealloc {
    [_durationLabel release], _durationLabel = nil;
    [_indexLabel release], _indexLabel = nil;
    [_tableView release];
    [_settingsButton release];
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
            return 13;
        case 1: //ADTransformTransition
            return 3;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"ADDualTransition";
        case 1:
            return @"ADTransformTransition";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * sCellIdentifier = @"CellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier] autorelease];
    }
    
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

- (IBAction)showSettings:(id)sender {
    ALSettingsViewController * settingsViewController = [[ALSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:settingsViewController animated:YES completion:nil];
    } else {
        [self presentModalViewController:settingsViewController animated:YES];
    }
    [settingsViewController release];
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
    [self.transitionController setNavigationBarHidden:[[defaults objectForKey:AL_NAVIGATION_BAR_HIDDEN_KEY] boolValue]];
}

- (void)_defaultsSettings {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(0.5f) forKey:AL_SPEED_KEY];
    [defaults setValue:@NO forKey:AL_NAVIGATION_BAR_HIDDEN_KEY];
    [defaults setValue:@(ADTransitionRightToLeft) forKey:AL_ORIENTATION_KEY];
    [defaults synchronize];
}

@end