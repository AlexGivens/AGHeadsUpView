//
//  AGHeadsUpView+Class.m
//
//  Created by Alex Givens on 10/31/14.
//  Copyright (c) 2014 Alex Givens. All rights reserved.
//

#import "AGHeadsUpView.h"

@interface AGHeadsUpView ()

- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text withDefiniteTime:(float)time;

- (void)showLoadingView;
- (void)showLoadingviewWithDefiniteTime:(float)time;

- (void)dismiss;

@end

@implementation AGHeadsUpView (Class)

+ (void)showText:(NSString *)text {
    [[AGHeadsUpView sharedView] showText:text];
}

+ (void)showText:(NSString *)text withDefiniteTime:(float)time {
    [[AGHeadsUpView sharedView] showText:text withDefiniteTime:time];
}

+ (void)showLoadingView {
    [[AGHeadsUpView sharedView] showLoadingView];
}

+ (void)showLoadingviewWithDefiniteTime:(float)time {
    [[AGHeadsUpView sharedView] showLoadingviewWithDefiniteTime:time];
}

+ (void)dismiss {
    [[AGHeadsUpView sharedView] dismiss];
}

@end