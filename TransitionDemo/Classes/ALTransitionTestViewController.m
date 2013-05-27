//
//  ALTransitionTestViewController.m
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ALTransitionTestViewController.h"
#import "UIViewController+ADTransitionController.h"
#import "ADDualTransition.h"
#import "ADCarrouselTransition.h"
#import "ADCubeTransition.h"
#import "ADCrossTransition.h"
#import "ADFadeTransition.h"
#import "ADFlipTransition.h"
#import "ADSwapTransition.h"
#import "ADGhostTransition.h"
#import "ADBackFadeTransition.h"
#import "ADTransformTransition.h"
#import "ADZoomTransition.h"
#import "ADSwipeTransition.h"

@implementation ALTransitionTestViewController
@synthesize indexLabel = _indexLabel;
@synthesize durationLabel = _durationLabel;
@synthesize index = _index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil index:(NSInteger)index {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.index = index;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexLabel.text = [NSString stringWithFormat:@"%d", self.index];
    self.title = [NSString stringWithFormat:@"Index: %d", self.index];
    _orientation = ADTransitionRightToLeft;
    _duration = 0.5f;
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %.1fs", _duration];
    
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
    self.view.backgroundColor = color;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_durationLabel release], _durationLabel = nil;
    [_indexLabel release], _indexLabel = nil;       
}

- (void)dealloc {
    [_durationLabel release], _durationLabel = nil;
    [_indexLabel release], _indexLabel = nil;
    [super dealloc];   
}

- (IBAction)pop:(id)sender {
#if USE_NAVIGATIONCONTROLLER
    [self.navigationController popViewControllerAnimated:YES];
#else
    [self.transitionController popViewController];
#endif
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
    ADTransition * animation = [[ADCubeTransition alloc] initWithDuration:_duration forType:ADTransitionTypePush orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)carrousel:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADCarrouselTransition alloc] initWithDuration:_duration forType:ADTransitionTypePush orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)cross:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADCrossTransition alloc] initWithDuration:_duration forType:ADTransitionTypePush];
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
- (IBAction)swap:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    ADTransition * animation = [[ADSwapTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    [self.transitionController pushViewController:viewController withTransition:animation];
    [animation release];
    [viewController release];
}
- (IBAction)flip:(id)sender {
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
#if !USE_NAVIGATIONCONTROLLER
    ADDualTransition * animation = [[ADFlipTransition alloc] initWithDuration:_duration orientation:_orientation sourceRect:self.view.frame];
    
    [self.transitionController pushViewController:viewController withTransition:animation];
#else
    [self.navigationController pushViewController:viewController animated:YES];
#endif
#if !USE_NAVIGATIONCONTROLLER
    [animation release];
#endif
    [viewController release];
}

- (IBAction)focus:(id)sender {
    ADTransition * transition = [[ADZoomTransition alloc] initWithSourceRect:[sender frame] andTargetRect:self.view.frame forDuration:_duration];
    ALTransitionTestViewController * viewController = [[ALTransitionTestViewController alloc] initWithNibName:@"ALTransitionTestViewController" bundle:nil index:self.index+1];
    [self.transitionController pushViewController:viewController withTransition:transition];
    [transition release];
    [viewController release];
}

- (IBAction)showHideNavigationBar:(id)sender {
    [self.transitionController setNavigationBarHidden:![self.transitionController isNavigationBarHidden]];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ALTransitionTestViewController viewDidAppear: %d", animated);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"ALTransitionTestViewController viewWillAppear: %d", animated);
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"ALTransitionTestViewController viewDidDisappear: %d", animated);
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"ALTransitionTestViewController viewWillDisappear: %d", animated);
}

- (IBAction)setTop:(id)sender {
    _orientation = ADTransitionBottomToTop;
}
- (IBAction)setBottom:(id)sender {
    _orientation = ADTransitionTopToBottom;
}
- (IBAction)setLeft:(id)sender {
    _orientation = ADTransitionRightToLeft;
}
- (IBAction)setRight:(id)sender {
    _orientation = ADTransitionLeftToRight;
}

- (IBAction)durationChanged:(id)sender {
    _duration = ((UISlider *)sender).value;
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %.1fs", _duration];
}
@end