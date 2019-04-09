//
//  UIViewController+LoaderAndAlerts.m
//  MI API Example
//
//  Created by mac-0001 on 22/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+LoaderAndAlerts.h"

@implementation UIViewController (LoaderAndAlerts)

#pragma mark - Alert Methods

-(void)showAlert:(NSString *)message
{
    [self showAlertWithType:AlertTypeDefault withMessage:message withTitle:nil];
}

-(void)showAlertWithTitleOnly:(NSString *)title
{
    [self showAlertWithType:AlertTypeDefault withMessage:nil withTitle:title];
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [self showAlertWithType:AlertTypeDefault withMessage:message withTitle:title];
}

-(void)showAlertWithType:(AlertType)type withMessage:(NSString *)message
{
    [[PPAlerts sharedAlerts] showAlertWithType:type withMessage:message withTitle:nil];
}

-(void)showAlertWithType:(AlertType)type withMessage:(NSString *)message withTitle:(NSString *)title
{
    [[PPAlerts sharedAlerts] showAlertWithType:type withMessage:message withTitle:title];
}

-(void)showAlertWithType:(AlertType)type withMessage:(NSString *)message withTitle:(NSString *)title withTimeoutImterval:(NSTimeInterval)interval
{
    [[PPAlerts sharedAlerts] showAlertWithType:type withMessage:message withTitle:title withTimeoutImterval:interval];
}


#pragma mark - Loader Methods

-(void)ShowHudLoaderWithText:(NSString *)text
{
    [[PPLoader sharedLoader] ShowHudLoaderWithText:text];
}

-(void)ShowHudLoader
{
    [[PPLoader sharedLoader] ShowHudLoader];
}

-(void)HideHudLoader
{
    [[PPLoader sharedLoader] HideHudLoader];
}

@end
