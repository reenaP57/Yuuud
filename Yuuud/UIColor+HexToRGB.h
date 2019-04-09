//
//  UIColor+HexToRGB.h
//  GoPro Motorplex
//
//  Created by mac-0009 on 12/6/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexToRGB)


+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end
