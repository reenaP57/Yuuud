//
//  UIAlertView+EventHandler.h
//  MI API Example
//
//  Created by mac-0001 on 19/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertViewButtonClickedHandler)(NSInteger buttonIndex);

@interface UIAlertView (EventHandler) <UIAlertViewDelegate>

-(void)show:(AlertViewButtonClickedHandler)clicked;

@end
