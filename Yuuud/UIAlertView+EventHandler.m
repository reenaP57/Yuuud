//
//  UIAlertView+EventHandler.m
//  MI API Example
//
//  Created by mac-0001 on 19/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIAlertView+EventHandler.h"

#import "Master.h"

#import "NSObject+NewProperty.h"




@implementation UIAlertView (EventHandler)

-(void)show:(AlertViewButtonClickedHandler)clicked
{
    [self show];
    [self setObject:clicked forKey:@"alertHandler"];
    self.delegate = self;
}

#pragma mark - Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertViewButtonClickedHandler obj = [self objectForKey:@"alertHandler"];
    
    if (obj)
        obj(buttonIndex);
}



@end
