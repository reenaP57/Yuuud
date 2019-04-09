//
//  UIActionSheet+EventHandler.m
//  MI API Example
//
//  Created by mac-0001 on 26/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIActionSheet+EventHandler.h"

#import "NSObject+NewProperty.h"

static NSString *const ACTIONSHEETDELEGATE = @"actionSheetDelegate";
static NSString *const ACTIONSHEETDELEGATECALLBACKHANDLER = @"dismissHandler";


@implementation UIActionSheet (EventHandler)

-(void)setActionHandler:(ActionSheetButtonClickedHandler)handler
{
    self.delegate = self;
    [self setObject:handler forKey:ACTIONSHEETDELEGATE];
}


-(void)setDismissActionHandler:(ActionSheetButtonClickedHandler)handler
{
    self.delegate = self;
    [self setObject:handler forKey:ACTIONSHEETDELEGATECALLBACKHANDLER];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ActionSheetButtonClickedHandler handler = [self objectForKey:ACTIONSHEETDELEGATE];
    
    if (handler)
        handler(buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    ActionSheetButtonClickedHandler handler = [self objectForKey:ACTIONSHEETDELEGATECALLBACKHANDLER];
    
    if (handler)
        handler(buttonIndex);
}



@end
