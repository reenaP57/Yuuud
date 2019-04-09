//
//  UIAlertController+Extension.m
//  Master
//
//  Created by mac-0001 on 08/12/14.
//  Copyright (c) 2014 mac-0001. All rights reserved.
//

#import "UIAlertController+Extension.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@implementation UIAlertController (Extension)
#else
@implementation UIAlertView (Extension)
#endif


+(void) alertViewWithOneButtonWithTitle:(NSString*)title withMessage:(NSString*)message buttonTitle:(NSString*)buttonTitle withDelegate:(id)delegate{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:buttonTitle otherButtonTitles:nil];
#warning insert tag number
    //    alertView.tag = "a reference number for you to identify in delegate methods"
    alertView.delegate = delegate;
    [alertView show];
}

+(void) alertViewWithTwoButtonsWithTitle:(NSString*)title withMessage:(NSString*)message firstButtonTitle:(NSString*)firstButtonTitle secondButtonTitle:(NSString*)secondButtonTitle withDelegate:(id)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:firstButtonTitle otherButtonTitles:secondButtonTitle, nil];
#warning insert tag number
    //    alertView.tag = "a reference number for you to identify in delegate methods"
    alertView.delegate = delegate;
    [alertView show];
}

+(void) alertViewWithThreeButtonsWithTitle:(NSString*)title withMessage:(NSString*)message firstButtonTitle:(NSString*)firstButtonTitle secondButtonTitle:(NSString*)secondButtonTitle thirdButtonTitle:(NSString*)thirdButtonTitle withDelegate:(id)delegate {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:firstButtonTitle otherButtonTitles:secondButtonTitle, thirdButtonTitle, nil];
#warning insert tag number
    //    alertView.tag = "a reference number for you to identify in delegate methods"
    alertView.delegate = delegate;
    [alertView show];
    
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

+(void) alertControllerWithOneButtonWithStyle:(UIAlertControllerStyle)style title:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle handler:(void (^)(UIAlertAction *action))handler inView:(UIViewController*)view {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:handler];
    
    [alertView addAction:okAction];
    [view presentViewController:alertView animated:YES completion:nil];
}

+(void) alertControllerWithTwoButtonsWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:firstHandler];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:secondHandler];
    
    [alertView addAction:firstAction];
    [alertView addAction:secondAction];
    [view presentViewController:alertView animated:YES completion:nil];
}

+(void) alertControllerWithThreeButtonsWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler thirdButton:(NSString*)thirdButtonTitle thirdHandler:(void (^)(UIAlertAction *action))thirdHandler inView:(UIViewController*)view{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:firstHandler];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:secondHandler];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:thirdButtonTitle style:UIAlertActionStyleDefault handler:thirdHandler];
    
    [alertView addAction:firstAction];
    [alertView addAction:secondAction];
    [alertView addAction:thirdAction];
    [view presentViewController:alertView animated:YES completion:nil];
}

+(void) alertControllerWithOneTextFieldWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view withDelegate:(id)delegate{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:firstHandler];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:secondHandler];
    
    //textField
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"What ever you want to ask the user";
#warning insert tag number
        //        textField.tag = ;
        textField.delegate = delegate;
    }];
    
    [alertView addAction:firstAction];
    [alertView addAction:secondAction];
    [view presentViewController:alertView animated:YES completion:nil];
}

+(void) alertControllerSignInWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view withDelegate:(id)delegate{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:firstHandler];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:secondHandler];
    
    //userName textField
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
#warning insert tag number
        //        textField.tag = ;
        textField.delegate = delegate;
    }];
    
    //password texfield
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
#warning insert tag number
        //        textField.tag = ;
        textField.delegate = delegate;
    }];
    
    [alertView addAction:firstAction];
    [alertView addAction:secondAction];
    [view presentViewController:alertView animated:YES completion:nil];
}

+(void) alertControllerSignUpWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view withDelegate:(id)delegate {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault handler:firstHandler];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault handler:secondHandler];
    
    //userName textField
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
#warning insert tag number
        //        textField.tag = ;
        textField.delegate = delegate;
    }];
    
    //password texfield
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
#warning insert tag number
        //        textField.tag = ;
        textField.delegate = delegate;
    }];
    
    
    //password texfield
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Confirm Password";
        textField.secureTextEntry = YES;
#warning insert tag number
        //        textField.tag = ;
        textField.delegate = delegate;
    }];
    //Check password textfield
    [alertView addAction:firstAction];
    [alertView addAction:secondAction];
    [view presentViewController:alertView animated:YES completion:nil];
}

#endif

@end
