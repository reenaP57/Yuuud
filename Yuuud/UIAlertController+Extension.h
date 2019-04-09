//
//  UIAlertController+Extension.h
//  Master
//
//  Created by mac-0001 on 08/12/14.
//  Copyright (c) 2014 mac-0001. All rights reserved.
//

#import <UIKit/UIKit.h>


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@interface UIAlertController (Extension)
#else
@interface UIAlertView (Extension)
#endif


//AlertView with One Button
+(void) alertViewWithOneButtonWithTitle:(NSString*)title withMessage:(NSString*)message buttonTitle:(NSString*)buttonTitle withDelegate:(id)delegate;

//AlertView with Two Buttons
+(void) alertViewWithTwoButtonsWithTitle:(NSString*)title withMessage:(NSString*)message firstButtonTitle:(NSString*)firstButtonTitle secondButtonTitle:(NSString*)secondButtonTitle withDelegate:(id)delegate;

//AlertView with Three Buttons
+(void) alertViewWithThreeButtonsWithTitle:(NSString*)title withMessage:(NSString*)message firstButtonTitle:(NSString*)firstButtonTitle secondButtonTitle:(NSString*)secondButtonTitle thirdButtonTitle:(NSString*)thirdButtonTitle withDelegate:(id)delegate;


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

//AlertController with One Button
+(void) alertControllerWithOneButtonWithStyle:(UIAlertControllerStyle)style title:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle handler:(void (^)(UIAlertAction *action))handler inView:(UIViewController*)view;

//AlertController with Two Buttons
+(void) alertControllerWithTwoButtonsWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view;

//AlertControoler with Three Buttons
+(void) alertControllerWithThreeButtonsWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler thirdButton:(NSString*)thirdButtonTitle thirdHandler:(void (^)(UIAlertAction *action))thirdHandler inView:(UIViewController*)view;

//AlertController with a single UITextField
+(void) alertControllerWithOneTextFieldWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view withDelegate:(id)delegate;

//AlertController with Sign In UITextFields
+(void) alertControllerSignInWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view withDelegate:(id)delegate;

//AlertController with Sign Up UITexfields
+(void) alertControllerSignUpWithStyle:(UIAlertControllerStyle)style  title:(NSString*)title message:(NSString*)message firstButton:(NSString*)firstButtonTitle firstHandler:(void (^)(UIAlertAction *action))firstHandler secondButton:(NSString*)secondButtonTitle secondHandler:(void (^)(UIAlertAction *action))secondHandler inView:(UIViewController*)view withDelegate:(id)delegate;

#endif


@end
