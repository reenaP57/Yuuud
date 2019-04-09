//
//  UIView+ScreenShot.h
//  MI API Example
//
//  Created by mac-0001 on 19/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+UIImagePickerController.h"

@interface UIView (ScreenShot)

-(UIImage *)screenshot;
-(void)scanCode:(ScanCode)completion;

@end
