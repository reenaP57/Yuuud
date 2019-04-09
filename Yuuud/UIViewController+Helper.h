//
//  UIViewController+Helper.h
//  MI API Example
//
//  Created by mac-0001 on 13/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Master.h"

@interface UIViewController (Helper)

+(UIViewController *)viewController;

- (BOOL)isVisible;
- (BOOL)isDismissed;
- (BOOL)isPresented;


-(void)presentOnTop;


-(void)setBackButton;


-(void)setBackButton:(Block)block;



@end
