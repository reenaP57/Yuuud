//
//  UIViewController+ScreenShot.h
//  MI API Example
//
//  Created by mac-0001 on 19/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ScreenShot.h"

@interface UIViewController (ScreenShot)

-(UIImage *)screenshot;
+ (UIImage *)screenshot;

@end
