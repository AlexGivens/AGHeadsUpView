//
//  AGHeadsUpView.h
//
//  Created by Alex Givens on 10/31/14.
//  Copyright (c) 2014 Alex Givens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGHeadsUpView : UIView

/** Gives access to the shared instance of the loading view.
 
 @return Shared CMCircleMenuHUDView instance.
 */
+ (instancetype)sharedView;

@end

@interface AGHeadsUpView (Class)

+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text withDefiniteTime:(float)time;

+ (void)showLoadingView;
+ (void)showLoadingviewWithDefiniteTime:(float)time;

+ (void)dismiss;

@end