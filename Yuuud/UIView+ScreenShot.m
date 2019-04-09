//
//  UIView+ScreenShot.m
//  MI API Example
//
//  Created by mac-0001 on 19/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIView+ScreenShot.h"


@implementation UIView (ScreenShot)

-(UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageView;
}


-(void)scanCode:(ScanCode)completion
{
    [UIViewController scanCodeOnView:self completion:completion];
}

@end
