//
//  ViewController.h
//  PadlockAnimationView
//
//  Created by Yannis on 11/3/20.
//  Copyright © 2020 isklikas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockView.h"

@interface ViewController : UIViewController

@property LockView *lockView;
@property UISlider *slider;
@property UILabel *sliderLabel;
@property CGFloat currentProgress;


@end

