//
//  UIButton+EventHandler.h
//  MI API Example
//
//  Created by mac-0001 on 12/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIAlertView+EventHandler.h"

typedef void (^TouchUpInsideHandler)(void);

@interface UIButton (EventHandler)

-(void)touchUpInsideClicked:(TouchUpInsideHandler)clicked;  // We Can use this on cellForRowAtIndexPath, where tag needs to be set and required on click event to get data.



-(void)showAlertOnTouchUpInsideClicked:(NSString *)title message:(NSString *)message otherButtons:(NSArray *)otherButtons clicked:(AlertViewButtonClickedHandler)clicked;
-(void)showAlertOnTouchUpInsideClicked:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel otherButtons:(NSArray *)otherButtons clicked:(AlertViewButtonClickedHandler)clicked;

@end


// To-Do required testing on cellForRowAtIndexPath with deleting and refreshing rows. it still return same nsmanagedobject or not