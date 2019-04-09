//
//  UIViewController+LoaderAndAlerts.h
//  MI API Example
//
//  Created by mac-0001 on 22/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPLoader.h"
#import "PPAlerts.h"

@interface UIViewController (LoaderAndAlerts)

-(void)showAlert:(NSString *)message;
-(void)showAlertWithTitleOnly:(NSString *)title;
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

-(void)showAlertWithType:(AlertType)type withMessage:(NSString *)message;
-(void)showAlertWithType:(AlertType)type withMessage:(NSString *)message withTitle:(NSString *)title;
-(void)showAlertWithType:(AlertType)type withMessage:(NSString *)message withTitle:(NSString *)title withTimeoutImterval:(NSTimeInterval)interval;






-(void)ShowHudLoaderWithText:(NSString *)text;
-(void)ShowHudLoader;
-(void)HideHudLoader;



@end
