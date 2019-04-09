//
//  UIBarButtonItem+Extension.m
//  Master
//
//  Created by mac-0001 on 16/04/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

#import "NSObject+NewProperty.h"

static NSString *const BARBUTTONITEMCALLBACKHANDLER = @"barbuttonitemHandler";

@implementation UIBarButtonItem (Extension)

-(void)clicked:(TouchUpInsideHandler)handler
{
    [self setObject:handler forKey:BARBUTTONITEMCALLBACKHANDLER];
    [self setTarget:self];
    [self setAction:@selector(touchUpInsideClickedEventFired:)];
}

-(void)touchUpInsideClickedEventFired:(UIBarButtonItem *)sender
{
    TouchUpInsideHandler handler = [self objectForKey:BARBUTTONITEMCALLBACKHANDLER];

    if (handler)
        handler();
}


@end
