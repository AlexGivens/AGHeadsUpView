//
//  AGHeadsUpView.m
//
//  Created by Alex Givens on 10/31/14.
//  Copyright (c) 2014 Alex Givens. All rights reserved.
//

#define kViewHUDPadding 32
#define KOpeningDuration 0.2

#import "AGHeadsUpView.h"
#import "AGHeadsUpWindow.h"
#import "LLARingSpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@interface AGHeadsUpView ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AGHeadsUpWindow *window;
@property (nonatomic, strong) UIViewController *presentationViewController;

@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) NSLayoutConstraint *hudViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudViewHeightConstraint;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSLayoutConstraint *textLabelWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textLabelHeightConstraint;

@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property (nonatomic, strong) NSLayoutConstraint *spinnerViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *spinnerViewHeightConstraint;

@end

@implementation AGHeadsUpView

#pragma mark - Class Methods
+ (instancetype)sharedView {
    static AGHeadsUpView *__sharedView = nil;
    
    static dispatch_once_t mmSharedOnceToken;
    dispatch_once(&mmSharedOnceToken, ^{
        __sharedView = [[AGHeadsUpView alloc] init];
    });
    
    return __sharedView;
}

- (void)buildWindow {
    if (self.window == nil) {
        
        self.window = [[AGHeadsUpWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.windowLevel = UIWindowLevelAlert;
        self.window.backgroundColor = [UIColor clearColor];
        
        if (self.presentationViewController == nil) {
            self.presentationViewController = [UIViewController new];
            [self.presentationViewController setView:self];
        }
        
        [self.window setRootViewController:self.presentationViewController];
        
        [self.window setHidden:NO];
    }
}

- (void)buildHUD {

    [self buildWindow];
    
    if (self.hudView == nil) {
        self.hudView = [[UIView alloc] init];
        [self.hudView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.hudView setLayoutMargins:UIEdgeInsetsZero];
        self.hudView.layer.cornerRadius = 6;
        self.hudView.layer.masksToBounds = YES;
        [self addSubview:self.hudView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hudView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hudView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        self.hudViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.hudView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:0.0];
        [self addConstraint:self.hudViewWidthConstraint];
        self.hudViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.hudView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:0.0];
        [self addConstraint:self.hudViewHeightConstraint];
        
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.hudView addSubview:visualEffectView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(visualEffectView);
        [self.hudView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[visualEffectView]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
        [self.hudView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[visualEffectView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    }

}

- (void)buildTextLabel {
    [self buildHUD];
    
    if (self.textLabel == nil) {
        self.textLabel = [UILabel new];
        [self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:26.0]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        [self.textLabel setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        self.textLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:0.0];
        [self addConstraint:self.textLabelWidthConstraint];
        self.textLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:0.0];
        [self addConstraint:self.textLabelHeightConstraint];
    }
}

- (void)buildActivityspinnerView {
    [self buildHUD];
    
    if (self.spinnerView == nil) {
        self.spinnerView = [LLARingSpinnerView new];
        
        [self.spinnerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.spinnerView setTintColor:[UIColor whiteColor]];
        [self.spinnerView setLineWidth:1.0];
        [self.spinnerView setHidesWhenStopped:YES];
        [self.spinnerView startAnimating];
        [self.spinnerView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.spinnerView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinnerView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinnerView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        self.spinnerViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.spinnerView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:0.0];
        [self addConstraint:self.spinnerViewWidthConstraint];
        self.spinnerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.spinnerView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:0.0];
        [self addConstraint:self.spinnerViewHeightConstraint];
    }
}

- (void)animateOpen {
    
    [UIView animateWithDuration:KOpeningDuration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)createDismissTimerWithTime:(float)time {
    if (self.timer) [self.timer invalidate];
    
    time += KOpeningDuration;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time
                                                  target:self
                                                selector:@selector(dismiss)
                                                userInfo:nil
                                                 repeats:NO];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

#pragma mark - Public Methods

- (void)showText:(NSString *)text {
    if (self.spinnerView) {
        [self.spinnerView removeFromSuperview];
        self.spinnerView = nil;
    }
    
    [self buildTextLabel];
    [self layoutIfNeeded];
    
    [self.textLabel setText:text];    
    CGSize textSize = [[self.textLabel text] sizeWithAttributes:@{NSFontAttributeName:self.textLabel.font}];
    
    self.hudViewWidthConstraint.constant = textSize.width + kViewHUDPadding + 20;
    self.hudViewHeightConstraint.constant = textSize.height + kViewHUDPadding;
    self.textLabelWidthConstraint.constant = textSize.width + 20;
    self.textLabelHeightConstraint.constant = textSize.height;

    [self animateOpen];
}

- (void)showText:(NSString *)text withDefiniteTime:(float)time {
    [self showText:text];
    [self createDismissTimerWithTime:time];
}

- (void)showLoadingView {
    if (self.textLabel) {
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
    }
    
    [self buildActivityspinnerView];
    [self layoutIfNeeded];
    
    self.hudViewWidthConstraint.constant = 84;
    self.hudViewHeightConstraint.constant = 84;
    self.spinnerViewWidthConstraint.constant = 32;
    self.spinnerViewHeightConstraint.constant = 32;
    
    [self animateOpen];
}

- (void)showLoadingviewWithDefiniteTime:(float)time {
    [self showLoadingView];
    [self createDismissTimerWithTime:time];
}

- (void)dismiss {
    [UIView animateWithDuration:KOpeningDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.hudView setAlpha:0.0];
                         [self.spinnerView setAlpha:0.0];
                         [self.textLabel setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         if (self.window) [self.window setHidden:YES];
                         
                         if (self.textLabel) {
                             [self.textLabel removeFromSuperview];
                             self.textLabel = nil;
                         }
                         
                         if (self.spinnerView) {
                             [self.spinnerView removeFromSuperview];
                             self.spinnerView = nil;
                         }
                         
                         self.hudView = nil;
                         self.presentationViewController = nil;
                         self.window = nil;
                     }];
}

@end
