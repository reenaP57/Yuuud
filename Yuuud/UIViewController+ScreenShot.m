//
//  UIViewController+ScreenShot.m
//  MI API Example
//
//  Created by mac-0001 on 19/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+ScreenShot.h"

#import "Master.h"

@implementation UIViewController (ScreenShot)

-(UIImage *)screenshot
{
    return [self.view screenshot];
}

+ (UIImage *)screenshot
{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    

    UIGraphicsBeginImageContextWithOptions(win.frame.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    //NSInteger count = 0;
    
    NSMutableArray *arrAllWindow = [[NSMutableArray alloc] init];
    [arrAllWindow addObjectsFromArray:[[UIApplication sharedApplication] windows]]; // This will allow keyboard capturing
    
    //below code will allow UIAlertview capturing
    if (IS_Ios8)
    {
        if ([[[UIApplication sharedApplication].keyWindow description] hasPrefix:@"<_UIAlertControllerShimPresenterWin"])
        {
            [arrAllWindow addObject:[UIApplication sharedApplication].keyWindow];
        }
    }
    else
    {
        if ([[[UIApplication sharedApplication].keyWindow description] hasPrefix:@"<_UIModalItemHostingWin"])
        {
            [arrAllWindow addObject:[UIApplication sharedApplication].keyWindow];
        }
    }
    
    for (int i=0;i<arrAllWindow.count; i++)
    {
        UIWindow *window = [arrAllWindow objectAtIndex:i];
        // -renderInContext: renders in the coordinate space of the layer,
        // so we must first apply the layer's geometry to the graphics context
        CGContextSaveGState(context);
        // Center the context around the window's anchor point
        CGContextTranslateCTM(context, [window center].x, [window center].y);
        // Apply the window's transform about the anchor point
        CGContextConcatCTM(context, [window transform]);
        
        // Y-offset for the status bar (if it's showing)
        NSInteger yOffset = [UIApplication sharedApplication].statusBarHidden ? 0 : -20;
        
        // Offset by the portion of the bounds left of and above the anchor point
        CGContextTranslateCTM(context,
                              -[window bounds].size.width * [[window layer] anchorPoint].x,
                              -[window bounds].size.height * [[window layer] anchorPoint].y + yOffset);
        
        [window drawViewHierarchyInRect:win.frame afterScreenUpdates:YES];
        
        // Restore the context
        CGContextRestoreGState(context);
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
