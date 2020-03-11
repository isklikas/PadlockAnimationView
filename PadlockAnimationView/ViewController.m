//
//  ViewController.m
//  PadlockAnimationView
//
//  Created by Yannis on 11/3/20.
//  Copyright © 2020 isklikas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.lockView = [[LockView alloc] initWithFrame:CGRectMake(0, 0, 50, 71.5)];
        self.slider = [[UISlider alloc] init];
        self.sliderLabel = [[UILabel alloc] init];
        self.currentProgress = 0.00f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.lockView.clipsToBounds = false;
    self.lockView.center = self.view.center;

    self.slider.frame = CGRectMake(50, self.view.bounds.size.height - 100, self.view.bounds.size.width - 100, 40);
    [self.slider addTarget:self action:@selector(updateLock:) forControlEvents:UIControlEventValueChanged];

    self.sliderLabel.frame = CGRectMake(self.slider.frame.origin.x, self.slider.frame.origin.y - 20, self.slider.frame.size.width, 20);
    [self.sliderLabel setTextColor:[UIColor whiteColor]];
    [self.sliderLabel setTextAlignment:NSTextAlignmentCenter];
    [self.sliderLabel setFont:[UIFont systemFontOfSize:12]];
    [self.sliderLabel setText:@"Tap Lock to animate"];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.lockView addGestureRecognizer:tapGesture];

    [self.view addSubview:self.lockView];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.sliderLabel];
}

- (void)updateLock:(UISlider *)sender {
    CGFloat truncatedValue = roundf(100*(sender.value)) / 100.0;
    self.sliderLabel.text = [NSString stringWithFormat:@"%0.2f", truncatedValue];
    
    // Note: Not sure if this helps at all?
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.lockView.progress = truncatedValue;
    });
}

- (void)tap:(id)sender {
    // Run a fixed animation to (un)lock depending on current progress
    if (self.lockView.progress < 1.0) {
        self.lockView.progress = 0;
        self.currentProgress = 0.0;
        
        [self animatePadlockViewWithDuration:18.0 andDestination:1.0]; //Write the time you intend, times x60. No idea why.
    }
    else {
        self.currentProgress = 1.0;
        [self animatePadlockViewWithDuration:18.0 andDestination:0.0]; //Write the time you intend, times x60. No idea why.
    }
    
}

- (void)animatePadlockViewWithDuration:(CGFloat)duration andDestination:(CGFloat)destination {
    [UIView animateWithDuration:0.01 animations:^{
        self.lockView.progress = self.currentProgress;
    } completion:^(BOOL finished) {
        /* Destination is either 1, or 0, so we can base our decisions here*/
        //The step is 0.01 divided by total duration, multiplied by the destination, which is 1 (or a decrease by 1 so it can be skipped as a neutral multiplier).
        CGFloat animationProgress = 100 * fabs(destination - self.currentProgress); //This when complete will approach 0. So when times 100, it's less than 1, it's complete
        if (animationProgress > 1) {
            CGFloat stepValue = 0.01 / duration;
            if (destination == 1.0) {
                //This means values go up.
                self.currentProgress += stepValue;
            }
            else {
                //This means we must go to 0.
                self.currentProgress -= stepValue;
            }
            [self animatePadlockViewWithDuration:duration andDestination:destination];
        }
        else {
            self.lockView.progress = destination;
        }
    }];
}

@end
