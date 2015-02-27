//
//  ViewController.m
//  Color Myx HUD
//
//  Created by Alexander Givens on 2/25/15.
//  Copyright (c) 2015 Alex Givens. All rights reserved.
//

#import "ViewController.h"
#import "AGHeadsUpView.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

- (IBAction)didTouchCustomMessageButton:(id)sender;
- (IBAction)didTouchActivityIndicatorButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self initializeBlurBackground];
}

- (void)initializeBlurBackground {
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    [self.containerView setLayoutMargins:UIEdgeInsetsZero];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.containerView insertSubview:visualEffectView atIndex:0];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(visualEffectView);
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[visualEffectView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[visualEffectView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.messageTextField) [self.messageTextField resignFirstResponder];
    return YES;
}

- (void)keyboardWillChange:(NSNotification*)notification {
    
    NSValue *animationCurve = [[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve keyboardAnimationCurve;
    [animationCurve getValue:&keyboardAnimationCurve];
    UIViewAnimationOptions keyboardAnimationOptions = keyboardAnimationCurve << 16;
    
    NSValue *animationDuration = [[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval keyboardAnimationDuration;
    [animationDuration getValue:&keyboardAnimationDuration];
    
    NSValue *endingFrame = [[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndingframe;
    [endingFrame getValue:&keyboardEndingframe];
    
    self.containerViewBottomConstraint.constant = self.view.frame.size.height - keyboardEndingframe.origin.y;
    
    [UIView animateWithDuration:keyboardAnimationDuration
                          delay:0.0
                        options:keyboardAnimationOptions
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)dismissKeyboard {
    [self.messageTextField resignFirstResponder];
}

- (IBAction)didTouchCustomMessageButton:(id)sender {
    [AGHeadsUpView showText:self.messageTextField.text withDefiniteTime:2.0];
}

- (IBAction)didTouchActivityIndicatorButton:(id)sender {
    [AGHeadsUpView showLoadingviewWithDefiniteTime:2.0];
}

@end
