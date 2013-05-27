//
//  ALTransitionTestViewController.h
//  Transition
//
//  Created by Patrick Nollet on 21/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADTransition.h"

@interface ALTransitionTestViewController : UIViewController {
    NSInteger _index;
    UILabel * _indexLabel;
    UILabel * _durationLabel;
    UIImageView * _backgroundView;
    void * _garbage;
    CGFloat _duration;
    ADTransitionOrientation _orientation;
}
@property (nonatomic, retain) IBOutlet UILabel * indexLabel;
@property (nonatomic, retain) IBOutlet UILabel * durationLabel;
@property (nonatomic) NSInteger index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil index:(NSInteger)index;
- (IBAction)fade:(id)sender;
- (IBAction)backFade:(id)sender;
- (IBAction)ghost:(id)sender;
- (IBAction)cube:(id)sender;
- (IBAction)carrousel:(id)sender;
- (IBAction)cross:(id)sender;
- (IBAction)swipe:(id)sender;
- (IBAction)swap:(id)sender;
- (IBAction)flip:(id)sender;
- (IBAction)pop:(id)sender;
- (IBAction)showHideNavigationBar:(id)sender;
- (IBAction)setTop:(id)sender;
- (IBAction)setBottom:(id)sender;
- (IBAction)setLeft:(id)sender;
- (IBAction)setRight:(id)sender;
- (IBAction)focus:(id)sender;
- (IBAction)durationChanged:(id)sender;
@end