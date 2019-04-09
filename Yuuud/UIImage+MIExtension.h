//
//  UIImage+MIExtension.h
//  MI API Example
//
//  Created by mac-0001 on 30/10/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MIExtension)

-(void)openInPreview;

- (UIImage *)compressForBiggestSize:(CGSize)size;

+(UIImage *)imageWithColor:(UIColor *)color;

@end
