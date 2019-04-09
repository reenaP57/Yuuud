//
//  UIActionSheet+EventHandler.h
//  MI API Example
//
//  Created by mac-0001 on 26/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionSheetButtonClickedHandler)(NSInteger buttonIndex);

@interface UIActionSheet (EventHandler) <UIActionSheetDelegate>

-(void)setActionHandler:(ActionSheetButtonClickedHandler)handler;

-(void)setDismissActionHandler:(ActionSheetButtonClickedHandler)handler;

@end
