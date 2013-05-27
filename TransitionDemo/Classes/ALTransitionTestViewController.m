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
@synthesize backgroundView = _backgroundView;

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
    
    NSString * imageName = nil;
    int imageIndex = arc4random()%3;
    switch (imageIndex) {
        case 0:
            imageName = @"ALTransitionTestImage2.jpg";
            break;
        case 1:
            imageName = @"ALTransitionTestImage3.jpeg";
            break;
        case 2:
            imageName = @"ALTransitionTestImage4.png";
            break;
        default:
            break;
    }
    [self.backgroundView setImage:[UIImage imageNamed:imageName]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [_durationLabel release], _durationLabel = nil;
    [_backgroundView release], _backgroundView = nil;
    [_indexLabel release], _indexLabel = nil;       
}

- (void)dealloc {
    [_durationLabel release], _durationLabel = nil;
    [_backgroundView release], _backgroundView = nil;
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