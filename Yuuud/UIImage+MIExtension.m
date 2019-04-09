//
//  UIImage+MIExtension.m
//  MI API Example
//
//  Created by mac-0001 on 30/10/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIImage+MIExtension.h"

#import "Master.h"

@implementation UIImage (MIExtension)

// Not working, need to check
-(void)openInPreview
{
    if(!IS_IPHONE_SIMULATOR)
        return;
    
    NSString *filepath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"test.png"];
    [UIImagePNGRepresentation(self) writeToFile:filepath atomically:YES];
    
    //system("open /tmp/test.png");
}


- (UIImage *)compressForBiggestSize:(CGSize)size
{
    // If image have smaller resolution than required, than no need to compress or resize.
    if (self.size.width <= size.width && self.size.height <= size.height)
        return self;
    
    CGFloat compression = 1.0;
    
    
    NSUInteger imageSize  = CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
    
    
    if (imageSize>1*1024*1024)
    {
        // If image size is greater than 1 MB than compress it with maxmimum compression ratio.
        compression = 0;
    }
    else
    {
        // If image size is bigger than compress it more
        NSUInteger sizeInkb = imageSize/1024;
        
        compression = (1024 - sizeInkb)/1000;
    }
    
    return [UIImage imageWithData:UIImageJPEGRepresentation(self, compression)];
}


+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
